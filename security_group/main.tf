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
    #cidr_blocks = [var.bastion_public_ip]
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

resource "aws_security_group_rule" "private_ec2" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_ec2.id
  source_security_group_id = aws_security_group.allow_bastion.id
}
