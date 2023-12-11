provider "aws" {
	region = "ap-northeast-2"
}

module "security_group"{
  source = "./security_group"
  #bastion_public_ip = "0.0.0.0/0"
  bastion_private_ip = "192.168.1.100/32"
  vpc_id = module.vpc.vpc_id
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
  sg = [module.security_group.bastion_sg]
}

module "bastion" {
  source = "./bastion"
  instance_ami = "ami-09eb4311cbaecf89d"
  instance_type = "t3.medium"
  key_name = "k8s-ho"
  interface = module.vpc.ec2_interface # <- include sg
  gw = module.vpc.internet_gw
}

module "server" {
  source = "./ec2"
  instance_ami = "ami-09eb4311cbaecf89d"
  instance_type = "t3.medium"
  key_name = "k8s-ho"
  hostname = "private-1"
  subnet = module.vpc.private_subnet_id_1
  sg = [module.security_group.private_sg]
}
