variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "hostname" {
  type = string
}

variable "sg" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "subnet" {
  type = string
}
