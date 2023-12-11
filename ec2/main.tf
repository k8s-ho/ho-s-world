resource "aws_instance" "server" {
	ami				= var.instance_ami
	instance_type   = var.instance_type
	key_name = var.key_name
	subnet_id = var.subnet
  associate_public_ip_address = false
  vpc_security_group_ids = var.sg

	user_data = <<-EOT
		#!/bin/bash
		sudo apt update && sudo apt install unzip
		sudo apt install net-tools && apt install -y jq

		echo "sudo su -" >> /home/ubuntu/.bashrc
		sudo hostnamectl --static set-hostname ${var.hostname}

		EOT
  
	tags = {
	  Name = var.hostname
	}
}
