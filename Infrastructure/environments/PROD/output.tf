output "vpc_id" {
  description = "vpc id for TGW creation"
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "List of subnet ids for TGW creation"
  value = module.vpc.private_subnet_ids
}

output "vpc_cidr" {
  description = "CIDR for vpc"
  value = module.vpc.vpc_cidr_block
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value = module.vpc.public_route_table_ids
}