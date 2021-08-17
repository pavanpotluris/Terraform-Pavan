terraform {
    required_version = ">=0.12"
    required_providers {
      aws = {
          version = ">= 2.7.0"
          source = "hashicorp/aws"
      }
    }
}

resource "aws_route_table" "pub-rt-terra" {
  vpc_id = var.vpc_id
  route = [
    {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
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

#Create Private Route Table
resource "aws_route_table" "prv-rt-terra" {
  vpc_id = var.vpc_id

  route = []

  tags = {
    Name = "prv-rt-terra"
  }
}