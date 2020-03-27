
resource "aws_security_group" "database" {
  name_prefix = "appdb"
  vpc_id      = data.aws_vpc.its.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["10.64.0.0/16"]
  }

  tags = {
    Name        = "Database security group"
  }
}
resource "aws_db_instance" "app" {
  depends_on                = [aws_security_group.database]
  identifier_prefix         = "appdb"
  allocated_storage         = 10
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "10.6"
  instance_class            = "db.t2.micro"
  name                      = "aptamer"
  username                  = "aptamer"
  password                  = "aptamerpass2018"
  vpc_security_group_ids    = [aws_security_group.database.id]
  db_subnet_group_name      = data.aws_ssm_parameter.its-db-subnet-group.value
  final_snapshot_identifier = "aptamer-database-snapshot"
  skip_final_snapshot       = false
}

