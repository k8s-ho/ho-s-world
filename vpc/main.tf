resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_vpc-default-sg"
  }
}

resource "aws_network_interface" "pub_interface" {
  subnet_id       = aws_subnet.public_sub_1.id
  private_ips     = [var.bastion_private_ip]
  security_groups = var.sg
  tags = {
    Name = "primary_network_interface"
  }
}  

resource "aws_subnet" "public_sub_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_1
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_1"
  }
}

resource "aws_subnet" "public_sub_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_2
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_2"
  }
}

resource "aws_subnet" "public_sub_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_3
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub_3"
  }
}

resource "aws_subnet" "private_sub_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "private_sub_1"
  }
}

resource "aws_subnet" "private_sub_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "private_sub_2"
  }
}

resource "aws_subnet" "private_sub_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_3
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private_sub_3"
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
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  tags = {
    Name = "private_route"
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
