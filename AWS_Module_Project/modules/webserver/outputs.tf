output "server_public_dns" {
  value = aws_instance.instance-terra.public_dns
}

output "server_public_ip" {
  value = aws_instance.instance-terra.public_ip
}

output "server_private_ip" {
  value = aws_instance.instance-terra.private_ip
}