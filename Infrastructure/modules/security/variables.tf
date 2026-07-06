variable "environment" {
  description = "Environment Name"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "allowed_ssh_cidr_block" {
  description = "Lisst of CIDR block to SSH to bastion host"
  type = list(string)
  default = [ "0.0.0.0/0" ] #give the specific CIDR at the time of prod deployment
}