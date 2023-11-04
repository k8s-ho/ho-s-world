provider "aws" {
	region = "ap-northeast-2"
}

resource "aws_instance" "bastion" {
	ami				= "ami-09eb4311cbaecf89d"
	instance_type   = "t3.medium"

	key_name = "k8s-ho"

    network_interface {
      network_interface_id = aws_network_interface.pub_interface.id
      device_index         = 0
    } 

	tags = {
	  Name = "EKS Bastion host"
	}
	depends_on = [aws_internet_gateway.bastion_gw]

}
