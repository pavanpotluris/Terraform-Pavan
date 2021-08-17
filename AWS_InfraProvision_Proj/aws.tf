# Configure the AWS Provider
# Below is to use AWS provider
provider "aws" {
  region = "us-east-2"
}

#resource "<provider>_<resource_type>" "name" {
#    config options.......
#    key1 = "value"
#    key2 = "another value"
#}

# Deploy an VPC 
resource "aws_vpc" "first-vpc" {
  cidr_block       = "10.1.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "first-vpc"
  }
}

resource "aws_subnet" "first-subnet1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.1.0.0/28"
  availability_zone = "us-east-2a"

  tags = {
    Name = "first-subnet1"
  }
}

resource "aws_subnet" "first-subnet2" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.1.0.16/28"
  availability_zone = "us-east-2c"

  tags = {
    Name = "first-subnet2"
  }
}

# # Deploy an EC2 instance
# resource "aws_instance" "first-web" {
#   ami           = "ami-00399ec92321828f5"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "Terraform"
#     Id = "Automation"
#   }
# }

