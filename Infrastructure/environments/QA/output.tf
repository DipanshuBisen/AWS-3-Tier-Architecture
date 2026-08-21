output "vpc_id" {
  description = "vpc id for TGW creation"
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "List of subnet ids for TGW creation"
  value = module.vpc.private_subnet_ids
}

