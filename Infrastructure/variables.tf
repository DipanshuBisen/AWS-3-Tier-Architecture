variable "AWS_region" {
  description = "Default region for provider"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "bastion_vpc_cidr" {
  description = "Bastion VPC CIDR"
  type = string
  default = "192.169.0.0/16"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

variable "public_subnet_cidr_bastion" {
  description = "CIDR for public subnet bastion"
  type = string
  default = "192.169.1.0/24"
}

variable "public_subnets" {
  description = "CIDR block of public subnets"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}


variable "private_subnets" {
  description = "CIDR block for private subnets"
  type        = list(string)
  default     = ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "allowed_ssh_cidr_block" {
  description = "List of CIDR block to SSH to bation host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_name" {
  description = "Name of Database"
  type        = string
  default     = "javaapp"
}

variable "db_username" {
  description = "Master user name for DB"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for DB"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Insatnce class for DB"
  type        = string
  default     = "db.t3.micro"
}

variable "storage_type" {
  description = "Storage type for DB"
  type        = string
  default     = "gp2"
}

variable "instance_type" {
  description = "Insatnace type for ASG"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}