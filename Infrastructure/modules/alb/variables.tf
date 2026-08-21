variable "environment" {
  description = "Environment name"
  type = string
}

variable "vpc_id" {
  description = "VPC ID for ALB"
  type = string
}

variable "public_subnets" {
  description = "List of public subnet"
  type = list(string)
}

