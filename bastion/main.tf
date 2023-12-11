resource "aws_instance" "bastion" {
  ami = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_name
	
  network_interface {
    network_interface_id = var.interface
    device_index = 0
  } 

  user_data = <<-EOT
  #!/bin/bash
  sudo apt update && sudo apt install unzip
  sudo apt install net-tools && apt install -y jq

  echo "sudo su -" >> /home/ubuntu/.bashrc
  sudo hostnamectl --static set-hostname "k8s-ho"

  # install aws-cli 
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

  # install kubectl 
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  chmod +x kubectl
  mkdir -p ~/.local/bin
  mv ./kubectl ~/.local/bin/kubectl

  # complete kubectl
  echo 'source <(kubectl completion bash)' >> /etc/profile
  echo 'alias k=kubectl' >> /etc/profile
  echo 'complete -F __start_kubectl k' >> /etc/profile

  # install eksctl
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  mv /tmp/eksctl /usr/local/bin

  # install yh
  wget https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-linux-amd64.zip
  unzip yh-linux-amd64.zip
  mv yh /usr/local/bin/

  # Install krew plugin
  kubectl krew install ctx ns get-all 
  EOT

  tags = {
    Name = "Bastion host"
  }
}
