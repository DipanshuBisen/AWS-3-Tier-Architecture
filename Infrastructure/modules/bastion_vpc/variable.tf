variable "environment" {
   description = "Environment name "
   type = string
}

variable "vpc_cidr_bation" {
  description = "VPC CIDR for bastion host"
  type = string
}

variable "public_subnet_cidr_bastion" {
  description = "CIDR for public subnet bastion"
  type = string
}

variable "azs_bastion" {
  description = "Availability Zone for bastion host"
  type = string
}