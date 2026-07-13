
# VPC for Bastion host
resource "aws_vpc" "bastion" {
  cidr_block = var.vpc_cidr_bation
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.environment}-vpc-bastion"
    Environment = var.environment
  }
}

#Internet gateway for bastion host
resource "aws_internet_gateway" "bastion" {
  vpc_id = var.vpc_cidr_bation.id

  tags = {
    Name = "${var.environment}-igw-bastion"
    Environment = var.environment
  }
}

#Public subnet for bastion host
resource "aws_subnet" "public_bastion" {
  vpc_id = aws_vpc.bastion.id
  cidr_block = var.public_subnet_cidr_bastion
  availability_zone = var.azs_bastion

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-bastion"
  }
}

#Route table for public bastion subnet
resource "aws_route_table" "bastion" {
  vpc_id = aws_vpc.bastion.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion.id
  }

  tags = {
    Name = "${var.environment}-public-bastion-rt"
    Environment = var.environment
  }
}