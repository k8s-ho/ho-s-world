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
  subnet_id       = aws_subnet.public_sub[0].id
  private_ips     = [var.bastion_private_ip]
  security_groups = var.sg
  tags = {
    Name = "primary_network_interface"
  }
}  

resource "aws_subnet" "public_sub" {
  count = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "ap-northeast-2${element(["a", "b", "c"], count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_sub_${count.index + 1}"
  }
}

resource "aws_subnet" "private_sub" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "ap-northeast-2${element(["a", "b", "c"], count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_sub_${count.index + 1}"
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
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private_route"
  }
}

resource "aws_route_table_association" "public_routing" {
  count           = length(var.public_subnet_cidrs)
  subnet_id       = aws_subnet.public_sub[count.index].id
  route_table_id  = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_routing" {
  count           = length(var.private_subnet_cidrs)
  subnet_id       = aws_subnet.private_sub[count.index].id
  route_table_id  = aws_route_table.private_route.id
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub[0].id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
