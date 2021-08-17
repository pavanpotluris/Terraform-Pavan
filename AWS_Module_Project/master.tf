# Configure the AWS Provider
# Below is to use AWS provider
provider "aws" {
  #profile = "terraform-access"
  region = "us-east-2"
}

#Create VPC by calling module
module "pavan-vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.cidr_prefix
}

#Create Internet Gateway by calling module
module "pavan-igw" {
  source = "./modules/internetGateway" 
  vpc_id = module.pavan-vpc.vpc_details.id
}

#Create Public Route Table by calling module
module "pavan-routetables" {
  source = "./modules/routeTables" 
  vpc_id = module.pavan-vpc.vpc_details.id
  igw_id = module.pavan-igw.igw_details.id
}

#Create Pub & Prv subnets by calling module
module "pavan-subnet" {
source = "./modules/subnet"
product = "pavan" 
environment = "dev" 
vpc_id = module.pavan-vpc.vpc_details.id
public_subnets = var.public_subnets
private_subnets = var.private_subnets
availability_zones = var.availability_zones
}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "associate-pub-rt" {
  count           = length(split(",", var.public_subnets))
  subnet_id       = element(module.pavan-subnet.pub_subnet_details.*.id, count.index)
  route_table_id  = element(module.pavan-routetables.pub-rt-table.*.id, count.index)
}

#Associate Private Route Table to Private Subnets
resource "aws_route_table_association" "associate-prv-rt" {
  count           = length(split(",", var.private_subnets))
  subnet_id       = element(module.pavan-subnet.prv_subnet_details.*.id, count.index)
  route_table_id  = element(module.pavan-routetables.prv-rt-table.*.id, count.index)
}

#Create Security Group by calling module
module "pavan-aws-security-group" {
  source = "./modules/securityGroup"
  vpc_id = module.pavan-vpc.vpc_details.id
}

#Create a network interface with an IP in the subnet that was created in step 4
# resource "aws_network_interface" "nic-terra" {
#   subnet_id       = aws_subnet.pub-a-subnet-terra.id
#   private_ips     = ["10.1.0.5"]
#   security_groups = [module.pavan-aws-security-group.security_group.id]
# }

#Assign an elastic IP to the network interface, created in step 7
# resource "aws_eip" "eip-terra" {
#   vpc                       = true
#   network_interface         = aws_network_interface.nic-terra.id
#   associate_with_private_ip = "10.1.0.5"
#   depends_on                = [aws_instance.instance-terra]
# }


#Create Ubuntu server and install apache2 by calling module
module "pavan-aws-instance" {
  source = "./modules/webserver"
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "AWSLogin"
  subnet_id = element(module.pavan-subnet.pub_subnet_details.*.id, 0)
  #network_interface_id = aws_network_interface.nic-terra.id
}

output "server_public_dns" {
  value = module.pavan-aws-instance.server_public_dns
}

output "server_public_ip" {
  value = module.pavan-aws-instance.server_public_ip
}

output "server_private_ip" {
  value = module.pavan-aws-instance.server_private_ip
}









