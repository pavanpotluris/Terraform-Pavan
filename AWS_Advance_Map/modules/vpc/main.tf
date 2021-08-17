terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.infra_env}-vpc"
        Project = "adv"
        environment = var.infra_env
        ManagedBy = "terraform"
    }
}


resource "aws_subnet" "public" {
    for_each = var.public_subnet_numbers

    vpc_id = aws_vpc.vpc.id

    cidr_block = cidrsubnet(var.vpc_cidr, 4, each.value)
    
    tags = {
        Name = "${var.infra_env}-public-subnet"
        Project = "adv"
        Environment = var.infra_env
        Role = "public"
        ManagedBy = "terraform"
        Subnet = "${each.key}-${each.value}"
    }
}

resource "aws_subnet" "private" {
    for_each = var.private_subnet_numbers

    vpc_id = aws_vpc.vpc.id

    cidr_block = cidrsubnet(var.vpc_cidr, 4, each.value)
    
    tags = {
        Name = "pavan-${var.infra_env}-private-subnet"
        Project = "pavan-adv"
        Environment = var.infra_env
        Role = "private"
        ManagedBy = "terraform"
        Subnet = "${each.key}-${each.value}"
    }
}