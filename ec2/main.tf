resource "aws_instance" "server" {
  ami  = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet
  associate_public_ip_address = false
  vpc_security_group_ids = var.sg

  user_data = <<-EOT
  #!/bin/bash
  sudo apt update -y && sudo apt install unzip -y
  sudo apt install python3-pip -y
  sudo apt install net-tools && apt install -y jq

  echo "sudo su -" >> /home/ubuntu/.bashrc
  sudo hostnamectl --static set-hostname ${var.hostname}

  echo "[+] Hello this is ${var.hostname} server!!" > index.html
  nohup busybox httpd -f -p 7777 &
  EOT

  tags = {
    Name = var.hostname
  }
}
