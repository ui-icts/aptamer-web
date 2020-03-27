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

