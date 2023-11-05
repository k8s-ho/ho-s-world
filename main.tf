provider "aws" {
	region = "ap-northeast-2"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr = "192.168.0.0/16"
  public_subnet_cidr_1 = "192.168.1.0/24"
  public_subnet_cidr_2 = "192.168.2.0/24"
  public_subnet_cidr_3 = "192.168.3.0/24"
  private_subnet_cidr_1 = "192.168.11.0/24"
  private_subnet_cidr_2 = "192.168.12.0/24"
  private_subnet_cidr_3 = "192.168.13.0/24"
  bastion_private_ip = "192.168.1.100"
}

module "ec2" {
  source = "./ec2"
  instance_ami = "ami-09eb4311cbaecf89d"
  instance_type = "t3.medium"
  key_name = "k8s-ho"
  interface = module.vpc.ec2_interface
  gw = module.vpc.internet_gw
}
