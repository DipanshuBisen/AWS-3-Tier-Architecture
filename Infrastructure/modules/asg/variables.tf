variable "environment" {
  description = "Environment name "
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "instance_type" {
  description = "give instance type for temlpate"
  type = string
}

variable "key_name" {
  description = "SSH key pain name"
  type = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type = list(string)
}

variable "min_size" {
  description = "Min size of ASG"
  type = number
}

variable "max_size" {
  description = "Max size of ASG"
  type = number
}

variable "desired_capacity" {
  description = "Desired capacity of ASG"
  type = number
}