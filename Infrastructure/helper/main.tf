#VPC Creation for helper(Bastion, Packer and Jenkins)
module "helper_vpc" {
  source = "../modules/helper_vpc"

  environment = var.environment
  vpc_cidr_helper = var.helper_vpc_cidr
  public_subnet_cidr_helper = var.public_subnet_cidr_helper
  azs_helper = [var.azs_helper]
}


#Transit gateway for helper to all environment VPCs
module "transit_gateway" {
  source = "../modules/tansit_gateway"

  environment = var.environment
  bastion_vpc_cidr = var.helper_vpc_cidr
 vpc_cidr = "give it later"
}

#Jenkins EC2 instance
module "jenkins_ec2" {
  source = "../modules/jenkins_ec2"

  environment = var.environment
  helper_subnet_id =module.helper_vpc.heleper_public_subnet_id
}