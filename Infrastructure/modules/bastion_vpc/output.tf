output "public_subnet_id" {
  description = "Public subnet id of bastion hots"
  value = aws_subnet.public_bastion.id
}

output "bastion_vpc_id" {
  description = "Bastion VPC ID"
  value = aws_vpc.bastion.id
}

output "bastion_public_route_table_id" {
  description = "Route table ID of bastion public"
  value = aws_route_table.bastion.id
}