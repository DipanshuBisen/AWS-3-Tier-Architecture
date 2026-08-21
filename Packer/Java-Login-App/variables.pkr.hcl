variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_name" {
  type = string
}

variable "jar_url" {
  type = string
}

variable "jfrog_username" {
  type      = string
  sensitive = true
}

variable "jfrog_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}