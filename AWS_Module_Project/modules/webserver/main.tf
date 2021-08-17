terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

#Create ubuntu server and install/enable apache2
resource "aws_instance" "instance-terra" {
  ami           = var.ami
  instance_type = var.instance_type  
  #depends_on    = var.vpc
  availability_zone = var.availability_zone
  key_name = var.key_name
  subnet_id = var.subnet_id

  # network_interface {
  #   network_interface_id = var.network_interface_id
  #   device_index         = 0
  # }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              EOF  

  tags = {
    Name = "instance-terra"
  }
}