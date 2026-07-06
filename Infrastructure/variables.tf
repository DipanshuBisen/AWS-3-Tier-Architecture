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


variable "private_subnets" {
  description = "CIDR block for private subnets"
  type = list(string)
  default = [ "192.168.3.0/24", "192.168.4.0/24" ]
}

variable "azs" {
  description = "List of Availability Zones"
  type = list(string)
  default = [ "ap-south-1a", "ap-south-1b" ]
}

variable "allowed_ssh_cidr_block" {
  description = "List of CIDR block to SSH to bation host"
  type = list(string)
  default = [ "0.0.0.0/0" ]
}

variable "db_name" {
  description = "Name of Database"
  type = string
  default = "javaapp"
}

variable "db_username" {
  description = "Master user name for DB"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Password for DB"
  type = string
  sensitive = true
}

variable "instance_class" {
  description = "Insatnce class for DB"
  type = string
  default = "db.t3.micro"
}

variable "storage_type" {
  description = "Storage type for DB"
  type = string
  default = "gp2"
}