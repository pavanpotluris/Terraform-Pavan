variable "ami" {
  description = "AMI"
  type = string
}

variable "instance_type" {
  description = "Instance Type"
  type = string
}

variable "availability_zone" {
  description = "availability_zone"
  type = string
}

variable "key_name" {
  description = "key_name"
  type = string
}

variable "subnet_id" {
  description = "subnet_id"
  type = string
}

# variable "network_interface_id" {
#   description = "network_interface_id"
#   type = string
# }