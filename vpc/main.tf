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
    Name = "public_sub_${count.index}"
  }
}

resource "aws_subnet" "private_sub" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "ap-northeast-2${element(["a", "b", "c"], count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_sub_${count.index}"
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

resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_sg
  subnets            = [for subnet in aws_subnet.public_sub : subnet.id]

  enable_deletion_protection = false
/*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "my-lb"
    enabled = true
  }
*/
  tags = {
    Name = "private_ec2_lb"
  }
}

resource "aws_lb_target_group" "my-loadbalancer" {
  name     = "private-ec2-lb"
  port     = 7777
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_target_group_attachment" "my-loadbalancer-attach" {
  count            = length(var.lb_attach_ec2_ids)
  target_group_arn = aws_lb_target_group.my-loadbalancer.arn
  target_id        = var.lb_attach_ec2_ids[count.index]
  port             = 7777
}

resource "aws_lb_listener" "my-listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my-loadbalancer.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "my-listener-https" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.my-loadbalancer.arn
    type             = "forward"
  }
  certificate_arn = var.certificate
}
