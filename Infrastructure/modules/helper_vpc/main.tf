
# VPC for helper 
resource "aws_vpc" "helper" {
  cidr_block = var.public_subnet_cidr_helper
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.environment}-vpc-helper"
    Environment = var.environment
  }
}


#Internet gateway for helper
resource "aws_internet_gateway" "helper" {
  vpc_id = var.vpc_cidr_bation.id

  tags = {
    Name = "${var.environment}-igw-helper"
    Environment = var.environment
  }
}

#Public subnet for helper
resource "aws_subnet" "public_helper" {
  vpc_id = aws_vpc.helper.id
  cidr_block = var.public_subnet_cidr_helper
  availability_zone = var.azs_helper

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-helper"
  }
}

#Route table for public helper subnet
resource "aws_route_table" "helper" {
  vpc_id = aws_vpc.helper.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.helper.id
  }

  tags = {
    Name = "${var.environment}-public-helper-rt"
    Environment = var.environment
  }
}

#Bastion Host creation (Ec2 Instance)
resource "aws_instance" "bastion" {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_helper.id
  associate_public_ip_address = true
  vpc_security_group_ids = module.security.bastion_security_group_id

  tags = {
    Name = "${var.environment}-bastion-ec2"
    Environment = var.environment
  }
}

