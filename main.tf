provider "aws" {
  region = "ap-northeast-2"
}

locals {
  key_name = "abc" # < Enter your key pair name >
  certificate = "arn:aws:acm:ap-northeast-2:123412341234:certificate/12345678-1234-abcd-abcd-234523452345" # <Enter your ssl certificate arn>
  route53_hostzoneid = "000000000000000000000"  # <Enter your route53_hostzone id>
  route53_record_name = "my-world" # <Enter your route53 record name >
}

module "security_group"{
  source = "./security_group"
  bastion_private_ip = "192.168.1.100/32"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "./vpc"
  vpc_cidr = "192.168.0.0/16"
  bastion_private_ip = "192.168.1.100"
  sg = [module.security_group.bastion_sg]

  # LoadBalancing config
  lb_sg = [module.security_group.lb_sg]
  certificate =  local.certificate
  lb_attach_ec2_ids  = flatten([for instance in module.server : instance.server_ec2_ids])
}

module "bastion" {
  source = "./bastion"
  instance_ami = "ami-09eb4311cbaecf89d"
  instance_type = "t3.medium"
  key_name = local.key_name
  interface = module.vpc.ec2_interface # <- include sg
  gw = module.vpc.internet_gw
}

module "server" {
  source = "./ec2"
  instance_ami = "ami-09eb4311cbaecf89d"
  instance_type = "t3.medium"
  key_name = local.key_name
  count = 2
  hostname = "private-${count.index}"
  subnet = module.vpc.private_subnet_ids[count.index]
  sg = [module.security_group.private_sg]
}

module "route53" {
  source = "./route53"
  hostzone_id = local.route53_hostzoneid
  record_name = local.route53_record_name
  lb_dns_name = module.vpc.lb_dns_name
  lb_zone_id = module.vpc.lb_zone_id
}

resource "null_resource" "copy_ssh_key_bastion" {
  depends_on = [module.bastion] 
  provisioner "local-exec" { # 혹시몰라서 인스턴스 생성 30초 대기 후 명령 진
    command = <<-EOT
      sleep 30
      scp -o StrictHostKeyChecking=no -i ${local.key_name}.pem ${local.key_name}.pem ubuntu@${module.bastion.bastion_ip}:.ssh/id_rsa
    EOT
  }
}
