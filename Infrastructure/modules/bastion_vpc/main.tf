
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

#Bastion Host creation (Ec2 Instance)
resource "aws_instance" "bastion" {
  ami = "mi-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_bastion.id
  associate_public_ip_address = true
  vpc_security_group_ids = module.security.bastion_security_group_id

  tags = {
    Name = "${var.environment}-bastion-ec2"
    Environment = var.environment
  }
}