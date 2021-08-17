terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

resource "aws_vpc" "vpc-terra" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-terra"
  }
}