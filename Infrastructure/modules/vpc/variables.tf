variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
}

variable "environment" {
  description = "Environment Name"
  type = strings
}

variable "public_subnets" {
  description = "CIDR block for public subnets"
  type = list(string)
}

