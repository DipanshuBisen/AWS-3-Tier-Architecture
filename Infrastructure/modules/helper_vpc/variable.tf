variable "environment" {
   description = "Environment name "
   type = string
}

variable "vpc_cidr_helper" {
  description = "VPC CIDR for helper"
  type = string
}

variable "public_subnet_cidr_helper" {
  description = "CIDR for public subnet bastion"
  type = string
}

variable "azs_helper" {
  description = "Availability Zone for bastion host"
  type = string
}