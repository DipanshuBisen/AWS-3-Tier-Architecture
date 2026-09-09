variable "environment" {
  description = "Environment Name"
  type = string
}

variable "helper_subnet_id" {
  description = "Bastion subnet ID for Jenkins Ec2"
  type = string
}

variable "helper_vpc_id" {
  description = "Helper VPC ID for security group"
  type = string
}