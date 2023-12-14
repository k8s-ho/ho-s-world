output "bastion_public_ip" {
  value = module.bastion.bastion_ip
}

output "private_instance_ip" {
  value = module.server[*].server_ip
}

output "application_loadBalance_domain" {
  value = module.route53.domain
}
