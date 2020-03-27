terraform {
  required_version = ">= 0.12"
  backend "remote" {
    organization = "uiowa-icts-bmi"
    workspaces {
      name = "aptamer"
    }
  }
}
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.49.0"
}

resource "aws_key_pair" "terraform" {
  key_name   = "Terraform key"
  public_key = file("~/.ssh/terraform.pub")
}

variable "region_subnet_map" {
  type = map(list(string))
  default = {
    "us-east-1" = ["us-east-1c", "us-east-1a"]
    "us-east-2" = ["us-east-2c", "us-east-2a"]
    "us-west-2" = ["us-west-2c", "us-west-2a"]
  }
}

