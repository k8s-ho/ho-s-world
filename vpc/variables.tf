variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
}

variable "bastion_private_ip" {
  type = string
}

variable "sg" {
  type = list(string)
}

variable "lb_sg" {
  type = list(string)
}

variable "certificate" {
  type = string
}

variable "lb_attach_ec2_ids" {
  type = list(string)
}
