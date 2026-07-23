variable "environment" {
  description = "Environment Name"
  type = string
}

variable "bastion_subnet_id" {
  description = "Bastion subnet ID for Jenkins Ec2"
  type = string
}