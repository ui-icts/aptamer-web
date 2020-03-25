data "aws_vpc" "its" {
  tags = {
    Name = "its-vpc"
  }
}

data "aws_subnet" "db-a" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "DbSubnetA"
  }
}

data "aws_subnet" "db-b" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "DbSubnetB"
  }
}

data "aws_subnet" "db-c" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "DbSubnetC"
  }
}

data "aws_subnet" "public-a" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "PublicSubnetA"
  }
}

data "aws_subnet" "public-b" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "PublicSubnetB"
  }
}

data "aws_subnet" "public-c" {
  vpc_id = data.aws_vpc.its.id
  tags = {
    Name = "PublicSubnetC"
  }
}

data "aws_internet_gateway" "its" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.its.id]
  }
}

data "aws_ssm_parameter" "its-db-subnet-group" {
  name     = "/its/its-vpc/db-subnet-group"
}

data "aws_availability_zones" "available" {
  state = "available"
}
