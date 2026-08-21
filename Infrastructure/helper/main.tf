
# AWS Provider Name
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
  }
  backend "s3" {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "helper/terraform.tfstate"
    region = "ap-south-1"
  }
}

# AWS Default Regions
provider "aws" {
  region = var.AWS_region
}





#VPC Creation for helper(Bastion, Packer and Jenkins)
module "helper_vpc" {
  source = "../modules/helper_vpc"

  environment = var.environment
  vpc_cidr_helper = var.helper_vpc_cidr
  public_subnet_cidr_helper = var.public_subnet_cidr_helper
  azs_helper = [var.azs_helper]
}

#accesing vpc id and subnetid for TGW creation from backend
data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "dr" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "dr/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "preprod" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "preprod/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "prod" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "qa" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "qa/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "uat" {
  backend = "s3"

  config = {
    bucket = "dipanshu-7ea935fdf4424ea3"
    key = "uat/terraform.tfstate"
    region = "ap-south-1"
  }
}


#Transit gateway for helper to all environment VPCs

resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for VPCs"

  amazon_side_asn = 64512
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "${var.environment}-transit-gateway"
    Environment = var.environment
  }
}

#VPC attachment to transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "helper" {
  subnet_ids = module.helper_vpc.helper_public_subnet_id
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = module.helper_vpc.helper_vpc_id

  tags = {
    Name= "${var.environment}-vpc_bastion_attachment"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev" {
  subnet_ids = [ data.terraform_remote_state.dev.outputs.subnet_ids ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = e

  tags = {
    Name = "${var.environment}-vpc-main-attachment"
    Environment = var.environment
  }
}

#Add Routes for both VPCs
resource "aws_route" "bastion_to_main" {
  route_table_id = module.bastion_vpc.bastion_public_route_table_id
  destination_cidr_block = var.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "main_to_bastion" {
  route_table_id = [ module.vpc.private_route_table_ids ]
  destination_cidr_block = var.bastion_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

#Jenkins EC2 instance
module "jenkins_ec2" {
  source = "../modules/jenkins_ec2"

  environment = var.environment
  helper_subnet_id =module.helper_vpc.heleper_public_subnet_id
}