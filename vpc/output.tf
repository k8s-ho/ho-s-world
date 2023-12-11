output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_id_1" {
  value = aws_subnet.public_sub_1.id
}
output "public_subnet_id_2" {
  value = aws_subnet.public_sub_2.id
}
output "public_subnet_id_3" {
  value = aws_subnet.public_sub_3.id
}

output "private_subnet_id_1" {
  value = aws_subnet.private_sub_1.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_sub_2.id
}

output "private_subnet_id_3" {
  value = aws_subnet.private_sub_3.id
}

output "internet_gw" {
  value = aws_internet_gateway.bastion_gw.id
}

output "ec2_interface" {
  value = aws_network_interface.pub_interface.id
}
