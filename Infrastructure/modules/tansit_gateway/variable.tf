variable "environment" {
  description = "Environment name "
  type = string
}

variable "bastion_vpc_cidr" {
  description = "Bastion VCP CIDR"
  type = string
}

variable "vpc_cidr" {
  description = "Main VPC CIDR"
  type = string
}