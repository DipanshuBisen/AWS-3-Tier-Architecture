variable "AWS_region" {
  description = "Default region for provider"
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
  default = "192.168.0.0/16"
}

variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}

variable "public_subnets" {
  description = "CIDR block of public subnets"
  type = list(string)
  default = [ "192.168.1.0/24", "192.168.2.0/24" ]
}