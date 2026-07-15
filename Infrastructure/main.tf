
# AWS Provider Name
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
  }
}

# AWS Default Regions
provider "aws" {
  region = var.AWS_region
}

#VPC module
module "vpc" {
  source = "./modules/vpc"

  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

#Security module
module "security" {
  source = "./modules/security"

  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id #This will take value from the output of vpc module
  allowed_ssh_cidr_block = var.allowed_ssh_cidr_block
  bastion_vpc_id = module.bastion_vpc.bastion_vpc_id
}

#RDS module
module "rds" {
  source = "./modules/rds"

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security.db_security_group_id]
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  instance_class     = var.instance_class
  storage_type       = var.storage_type
}

#Application load balancer module
module "alb" {
  source = "./modules/alb"

  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

#Auto Scaling group
module "asg" {
  source = "./modules/asg"

  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.security.app_security_group_id]
  target_group_arns      = [module.alb.target_group_arn]
  instance_type          = var.instance_type
  key_name               = var.key_name
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  desired_capacity       = var.asg_desired_capacity
}


#Cloud Watch module
module "monitoring" {
  source = "./modules/monitoring"

  environment     = var.environment
  rds_instance_id = module.rds.rds_insatnace_id
  asg_name        = module.asg.asg_name
}

#Bastion VPC
module "bastion_vpc" {
  source = "./modules/bastion_vpc"

  environment = var.environment
  vpc_cidr_bation = var.bastion_vpc_cidr
  public_subnet_cidr_bastion = var.public_subnet_cidr_bastion
  azs_bastion = [var.azs]
}


#Transit gateway
module "transit_gateway" {
  source = "./modules/tansit_gateway"

  environment = var.environment
  bastion_vpc_cidr = var.bastion_vpc_cidr
  vpc_cidr = var.vpc_cidr
  
}