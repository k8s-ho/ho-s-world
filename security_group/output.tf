output "bastion_sg"{
	value = aws_security_group.allow_bastion.id
}

output "private_sg"{
	value = aws_security_group.private_ec2.id
}
