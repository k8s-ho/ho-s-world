output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_sub : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_sub : subnet.id]
}

output "internet_gw" {
  value = aws_internet_gateway.bastion_gw.id
}

output "ec2_interface" {
  value = aws_network_interface.pub_interface.id
}

output "lb_dns_name" {
  value = aws_lb.my-lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.my-lb.zone_id
}
