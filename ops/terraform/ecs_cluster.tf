resource "aws_ecs_cluster" "default" {
  name = "default-cluster"
}

data "aws_iam_policy" "default_for_ec2_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-default-to-my-role" {
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = data.aws_iam_policy.default_for_ec2_role.arn
}

/* Cannot easily change because it can't be dropped and re-created
   without dropping any ec2-instances and network interfaces that
   are using it.
   Best to create a new security group and put it where needed
   OR perhaps import the existing into a different resource first
*/
resource "aws_security_group" "cluster_instance" {
  name_prefix = "ecs-container-host"
  description = "Managed by Terraform"
  vpc_id = data.aws_vpc.its.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["208.126.207.39/32"]
    description = "Allows SSH access from Chris house"
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
    description = "Allows communication from ALB to EC2 instance"
  }

  # Allow outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Outbound internet access"
  }

  tags = {
    Name = "ECS Container Host"
    Description = "Applied to EC2 instances running in ECS cluster"
  }

  depends_on = [
    aws_security_group.load_balancer
  ]
}


resource "aws_security_group" "load_balancer" {
  name_prefix = "alb"
  vpc_id = data.aws_vpc.its.id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound internet access, minimum it needs
  # to get to our other instances within the VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Outbound internet access"
  }
  tags = {
    Name = "Internet ELB"
    Description = "Applied to internet facing load balancer"
  }
}

resource "aws_lb" "app" {
  name = "application-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.public-a.id,
    data.aws_subnet.public-b.id,
    data.aws_subnet.public-c.id
  ]
  security_groups = [aws_security_group.load_balancer.id]
  depends_on = [
    aws_security_group.load_balancer,
    aws_security_group.cluster_instance
  ]
}


resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.app.arn

    port = "80"
    protocol = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.web.arn
        type = "forward"
    }
}

resource "aws_lb_target_group" "web" {
  name_prefix = "appweb"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.its.id
}

resource "aws_iam_instance_profile" "default" {
  name = "ecsInstanceRole"
  role = aws_iam_role.ecsInstanceRole.name
}


data "template_file" "user-data" {
  template = <<-EOF
    #!/bin/bash

    # ECS config
    {
      echo "ECS_CLUSTER=${aws_ecs_cluster.default.name}"
    } >> /etc/ecs/ecs.config

    start ecs

    echo "Done"
  EOF
}

resource "aws_launch_template" "default" {
  name = "inexpensive-spot-launch"
  image_id = data.aws_ami.ecs.id

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  cpu_options {
    core_count = 1
    threads_per_core = 2
  }

  ebs_optimized = true

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0208
      spot_instance_type = "one-time"
    }
  }

  instance_type = "t3.small"

  iam_instance_profile {
    name = aws_iam_instance_profile.default.name
  }
  key_name = aws_key_pair.terraform.key_name

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [
    aws_security_group.cluster_instance.id
  ]

  user_data = base64encode(data.template_file.user-data.rendered)

  depends_on = [
    aws_security_group.cluster_instance
  ]
}

resource "aws_autoscaling_group" "default" {
  name_prefix = "spot_group"

  launch_template {
    id = aws_launch_template.default.id
    version = "$Latest"
  }
  vpc_zone_identifier  = [
    data.aws_subnet.public-a.id,
    data.aws_subnet.public-b.id,
    data.aws_subnet.public-c.id
  ]
  max_size             = 3
  min_size             = 1
  desired_capacity     = 1

  lifecycle {
    create_before_destroy = true
  }
}

output "service_cluster_name" {
  value = aws_ecs_cluster.default.name
}
output "service_group_target_arn" {
  value = aws_lb_target_group.web.arn
}
