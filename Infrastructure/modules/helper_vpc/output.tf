output "heleper_public_subnet_id" {
  description = "Public subnet id of bastion hots"
  value = aws_subnet.public_helper.id
}

output "helper_vpc_id" {
  description = "Bastion VPC ID"
  value = aws_vpc.helper.id
}

output "helper_public_route_table_id" {
  description = "Route table ID of helper public"
  value = aws_route_table.helper.id
}