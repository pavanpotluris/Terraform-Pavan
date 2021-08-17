# Configure the AWS Provider
# Below is to use AWS provider
provider "aws" {
  profile = "terraform-access"
}

#resource "<provider>_<resource_type>" "name" {
#    config options.......
#    key1 = "value"
#    key2 = "another value"
#}

variable "cidr_prefix" {
  description = "cidr block for the vpc"
  type = list
}
variable "vpc_cidr" {
  description = "cidr block for the vpc"
  default = "10.1.0.0/26"
  type = string
}

variable "pub_subnet_cidr" {
  description = "cidr block for the public subnet"
  default = "10.1.0.0/28"
  type = string
}

variable "prv_subnet_cidr" {
  description = "cidr block for the private subnet"
  default = "10.1.0.16/28"
  type = string
}

#Create VPC
resource "aws_vpc" "vpc-terra" {
  #cidr_block       = "10.1.0.0/26"
  #cidr_block = var.vpc_cidr
  cidr_block = var.cidr_prefix[0]
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-terra"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw-terra" {
  vpc_id = aws_vpc.vpc-terra.id

  tags = {
    Name = "gw-terra"
  }
}

#Create Public Route Table
resource "aws_route_table" "pub-rt-terra" {
  vpc_id = aws_vpc.vpc-terra.id
  # depends_on = [aws_internet_gateway.gw-terra]
  route = [
    {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-terra.id
    carrier_gateway_id = null
    destination_prefix_list_id = null
    egress_only_gateway_id = null
    instance_id = null
    ipv6_cidr_block = null
    local_gateway_id = null
    nat_gateway_id = null
    network_interface_id = null
    transit_gateway_id = null
    vpc_endpoint_id = null
    vpc_peering_connection_id = null
    }
  ]

  tags = {
    Name = "pub-rt-terra"
  }
}

# resource "aws_route" "rt-terra" {
#   route_table_id            = aws_route_table.pub-rt-terra.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.gw-terra.id
#   depends_on                = [aws_route_table.pub-rt-terra]
# }

# resource "aws_route" "rt-terra-ipv6" {
#   route_table_id  = aws_route_table.pub-rt-terra.id
#   destination_cidr_block = ""
#   gateway_id  = aws_internet_gateway.gw-terra.id
#   depends_on  = [aws_route_table.pub-rt-terra]
# }

#Create Private Route Table
resource "aws_route_table" "prv-rt-terra" {
  vpc_id = aws_vpc.vpc-terra.id

  route = []

  tags = {
    Name = "prv-rt-terra"
  }
}

#Create Public Subnet In ZoneA
resource "aws_subnet" "pub-a-subnet-terra" {
  vpc_id     = aws_vpc.vpc-terra.id
  #cidr_block = "10.1.0.0/28"
  cidr_block = var.cidr_prefix[1]
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-a-subnet-terra"
  }
}

#Create Private Subnet In ZoneB
resource "aws_subnet" "prv-b-subnet-terra" {
  vpc_id     = aws_vpc.vpc-terra.id
  #cidr_block = "10.1.0.16/28"
  cidr_block = var.cidr_prefix[2]
  availability_zone = "us-east-2b"

  tags = {
    Name = "prv-b-subnet-terra"
  }
}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "associate-pub-rt" {
  subnet_id      = aws_subnet.pub-a-subnet-terra.id
  route_table_id = aws_route_table.pub-rt-terra.id
}

#Associate Private Route Table to Private Subnets
resource "aws_route_table_association" "associate-prv-rt" {
  subnet_id      = aws_subnet.prv-b-subnet-terra.id
  route_table_id = aws_route_table.prv-rt-terra.id
}

#Create Security Group
resource "aws_security_group" "secruity-terraform" {
  name        = "security-terraform"
  description = "Allow traffic 80,443,8080,22"
  vpc_id      = aws_vpc.vpc-terra.id

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

#Create a network interface with an IP in the subnet that was created in step 4
resource "aws_network_interface" "nic-terra" {
  subnet_id       = aws_subnet.pub-a-subnet-terra.id
  private_ips     = ["10.1.0.5"]
  security_groups = [aws_security_group.secruity-terraform.id]
}

#Assign an elastic IP to the network interface, created in step 7
# resource "aws_eip" "eip-terra" {
#   vpc                       = true
#   network_interface         = aws_network_interface.nic-terra.id
#   associate_with_private_ip = "10.1.0.5"
#   depends_on                = [aws_instance.instance-terra]
# }

#Create ubuntu server and install/enable apache2
resource "aws_instance" "instance-terra" {
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"
  depends_on    = [aws_vpc.vpc-terra]
  availability_zone = "us-east-2a"
  key_name = "AWSLogin"

  network_interface {
    network_interface_id = aws_network_interface.nic-terra.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              EOF  

  tags = {
    Name = "instance-terra"
  }
}

output "server_public_dns" {
  value = aws_instance.instance-terra.public_dns
}

output "server_public_ip" {
  value = aws_instance.instance-terra.public_ip
}

output "server_private_ip" {
  value = aws_instance.instance-terra.private_ip
}









