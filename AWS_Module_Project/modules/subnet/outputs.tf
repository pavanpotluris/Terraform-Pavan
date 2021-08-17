output "pub_subnet_details" {
    value = aws_subnet.public_subnets
}

output "prv_subnet_details" {
    value = aws_subnet.private_subnets
}