variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
}

variable "environment" {
  description = "Environment Name"
  type = string
}

variable "public_subnets" {
  description = "CIDR block for public subnets"
  type = list(string)
}

variable "private_subnets" {
  description = "CIDR block for private subnets"
  type = list(string)
}

variable "azs" {
  description = "List of Availability Zones"
  type = list(string)
}

