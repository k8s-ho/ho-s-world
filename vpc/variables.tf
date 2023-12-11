variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr_1" {
  type = string
}

variable "public_subnet_cidr_2" {
  type = string
}

variable "public_subnet_cidr_3" {
  type = string
}

variable "private_subnet_cidr_1" {
  type = string
}

variable "private_subnet_cidr_2" {
  type = string
}

variable "private_subnet_cidr_3" {
  type = string
}

variable "bastion_private_ip" {
  type = string
}

variable "sg" {
  type = list(string)
}
