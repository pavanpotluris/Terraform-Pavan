variable "cidr_prefix" {
  description = "cidr block for the vpc"
  type = string
}

variable "public_subnets" {
  description = "public subnets"
  type = string
}

variable "private_subnets" {
  description = "private subnets"
  type = string
}

variable "availability_zones" {
  description = "availability zones"
  type = string
}