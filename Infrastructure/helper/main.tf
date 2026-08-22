
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
  vpc_id = data.terraform_remote_state.dev.outputs.vpc_id

  tags = {
    Name = "dev-vpc-main-attachment"
    Environment = "dev"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dr" {
  subnet_ids = [ data.terraform_remote_state.dr.outputs.subnet_ids ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = data.terraform_remote_state.dr.outputs.vpc_id

  tags = {
    Name = "dr-vpc-main-attachment"
    Environment = "dr"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "preprod" {
  subnet_ids = [data.terraform_remote_state.preprod.outputs.subnet_ids]
  transit_gateway_id = aws_ec2_transit_gateway.main
  vpc_id = data.terraform_remote_state.preprod.ouputs.vpc_id

  tags = {
    Name = "preprod-vpc-main-attachment"
    Environment = "preprod"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  subnet_ids = [data.terraform_remote_state.prod.outputs.subnet_ids]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = data.terraform_remote_state.prod.outputs.vpc_id

  tags = {
    Name = "prod-vpc-main-attachment"
    Environment = "prod"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "qa" {
  subnet_ids = [ data.terraform_remote_state.qa.outputs.subnet_ids ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = data.terraform_remote_state.qa.outputs.vpc_id

  tags = {
    Name = "qa-vpc-main-attachment"
    Environment = "qa"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "uat" {
  subnet_ids = [ data.terraform_remote_state.uat.outputs.subnet_ids ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = data.terraform_remote_state.uat.outputs.vpc_id

  tags = {
    Name = "uat-vpc-main-attachment"
    Environment = "uat"
  }
}

#Add Routes fo helper to all ENVs and ENVs to helper
resource "aws_route" "helper_to_dev" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.dev.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "dev_to_helper" {
  route_table_id =  data.terraform_remote_state.dev.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "helper_to_dr" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.dr.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "dr_to_helper" {
  route_table_id =  data.terraform_remote_state.dr.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "helper_to_preprod" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.preprod.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "preprod_to_helper" {
  route_table_id =  data.terraform_remote_state.preprod.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "helper_to_prod" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.prod.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "prod_to_helper" {
  route_table_id =  data.terraform_remote_state.prod.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "helper_to_qa" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.qa.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "qa_to_helper" {
  route_table_id =  data.terraform_remote_state.qa.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "helper_to_uat" {
  route_table_id = module.helper_vpc.helper_public_route_table_id
  destination_cidr_block = data.terraform_remote_state.uat.outputs.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "uat_to_helper" {
  route_table_id =  data.terraform_remote_state.uat.outputs.private_route_table_ids
  destination_cidr_block = var.helper_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

#Jenkins EC2 instance
module "jenkins_ec2" {
  source = "../modules/jenkins_ec2"

  environment = var.environment
  helper_subnet_id =module.helper_vpc.heleper_public_subnet_id
}