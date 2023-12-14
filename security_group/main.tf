data "http" "public_ip" {
  url = "https://api.ip.pe.kr/"
}

# Bastion EC2 SG
resource "aws_security_group" "allow_bastion"{
    name        = "bastion_sg"
    vpc_id      = var.vpc_id
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", data.http.public_ip.response_body)] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Private EC2 SG
resource "aws_security_group" "private_ec2"{
    name        = "private-sg"
    vpc_id      =  var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_private_ip] # 나중에 삭제ㄱ
  }

  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

# LoadBalancer SG
resource "aws_security_group" "loadbalancer_sg"{
    name        = "loadbalancer-sg"
    vpc_id      =  var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "loadbalancer-sg"
  }
}
