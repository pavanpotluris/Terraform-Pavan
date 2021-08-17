# Configure the AWS Provider
# Below is to use AWS provider
provider "aws" {
  #profile = "terraform-access"
  region = lookup(local.map_region, local.workspace_name)
}

module "vpc" {
    source = "./modules/vpc"
    infra_env = lookup(local.map_environment, local.workspace_name)
    vpc_cidr  = lookup(local.map_cidr_prefix, local.workspace_name)
}

locals {
    str1 = "Pavan"
    str2 = "Potluri"

    n1 = 0
    n2 = 1

    listex = ["Reyaan", "Krishna", "Lallu"]

    map_environment = {
      default = "dev"
      prod = "prod"
    }

    map_cidr_prefix = {
      default = "100.0.0.0/16"
      prod = "200.0.0.0/16"
    }

    map_region = {
      default = "us-east-2"
      prod = "us-east-1"
    }

    workspace_name = terraform.workspace
}


