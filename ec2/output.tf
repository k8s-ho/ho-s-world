output "server_ip"{
  value = aws_instance.server.private_ip
}

output "server_ec2_ids" {
  value = aws_instance.server[*].id
}
