variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string 
}

variable "subnet_ids" {
  description = "LIst of subnet ids for RDS"
  type = list(string)
}

variable "db_name" {
  description = "Database name"
  type = string
}

variable "db_username" {
  description = "Database username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}

variable "security_group_ids" {
  description = "List of security group ids"
  type = list(string)
}

variable "instance_class" {
  description = "give the instance class name "
  type = string
}

variable "storage_type" {
  description = "Give the storage type name "
  type = string
}