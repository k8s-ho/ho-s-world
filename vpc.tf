resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "public_sub_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_1"
  }
}

resource "aws_subnet" "public_sub_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_2"
  }
}

resource "aws_subnet" "public_sub_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_3"
  }
}


resource "aws_subnet" "private_sub_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "private_sub_1"
  }
}

resource "aws_subnet" "private_sub_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.11.0/24"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "private_sub_2"
  }
}

resource "aws_subnet" "private_sub_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.12.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private_sub_3"
  }
}

resource "aws_security_group" "allow_bastion" {
  name        = "allow_bastion"
  description = "Allow bastion inbound traffic my ip"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.236.247.2/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "pub_interface" {
  subnet_id       = aws_subnet.public_sub_1.id
  private_ips     = ["192.168.1.100"]
  security_groups = [aws_security_group.allow_bastion.id]
  tags = {
    Name = "primary_network_interface"
  }
}  


resource "aws_internet_gateway" "bastion_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "bastion_gw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion_gw.id
  }
  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "public_routing_1" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_routing_2" {
  subnet_id      = aws_subnet.public_sub_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_routing_3" {
  subnet_id      = aws_subnet.public_sub_3.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_routing_1" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_routing_2" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_routing_3" {
  subnet_id      = aws_subnet.private_sub_3.id
  route_table_id = aws_route_table.private_route.id
}

