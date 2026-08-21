variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "all"
}

variable "helper_vpc_cidr" {
  description = "Bastion VPC CIDR"
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr_helper" {
  description = "CIDR for public subnet bastion"
  type = string
  default = "192.169.1.0/24"
}

variable "azs_helper" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}