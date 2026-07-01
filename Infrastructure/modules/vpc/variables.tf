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

<<<<<<< HEAD
variable "private_subnets" {
  description = "CIDR block for private subnets"
  type = list(string)
}

variable "azs" {
  description = "List of Availability Zones"
  type = list(string)
}

=======
>>>>>>> f21089abc854c59c73d3e637c130c90bc32d5b81
