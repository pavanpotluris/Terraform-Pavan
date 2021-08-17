terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

resource "aws_internet_gateway" "gw-terra" {
  vpc_id = var.vpc_id

  tags = {
    Name = "gw-terra"
  }
}