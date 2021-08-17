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

#Create VPC
resource "aws_internet_gateway" "gw-terra" {
  vpc_id = "pavan-vpc"

  tags = {
    Name = "gw-terra"
  }
}

#Create Public Route Table
resource "aws_route_table" "pub-rt-terra" {
  vpc_id = "pavan-vpc"

  route = []

  tags = {
    Name = "pub-rt-terra"
  }
}










