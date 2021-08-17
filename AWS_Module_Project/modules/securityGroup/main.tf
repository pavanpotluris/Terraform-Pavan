terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

#Create Security Group
resource "aws_security_group" "secruity-terraform" {
  name        = "security-terraform"
  description = "Allow traffic 80,443,8080,22"
  vpc_id = var.vpc_id

  ingress = [
    {
      description      = "SSH Traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null,
      security_groups  = null,
      self = null
    },

    {
      description      = "HTTP Traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null,
      security_groups  = null,
      self = null
    },

    {
      description      = "HTTPS Traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null,
      security_groups  = null,
      self = null
    }
  ]

  egress = [
    {
      description = "Egress Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null
      security_groups = null
      self = null
    }
  ]

  tags = {
    Name = "security-terraform"
  }
}