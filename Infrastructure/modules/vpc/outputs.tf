output "vpc_id" {
  description = "ID of VPC"
  value = aws_vpc.main.id
}

output "vpc_name" {
  description = "Name of VPC"
  value = aws_vpc.main.tags["Name"]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR block"
  value = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR block"
  value = aws_subnet.private[*].cidr_block
}

output "internet_gateway_id" {
  description = "Internet Geteway ID"
  value = aws_internet_gateway.main.id
}

output "public_route_table_ids" {
  description = "List of public route table IDs"
  value = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value = aws_route_table.private[*].id
}

output "nat_gateway_ids" {
  description = "List of NAT gaeway IDs"
  value = aws_nat_gateway.main[*].id
}

output "nat_gateway_elastic_ips" {
  description = "List of Elastic IP addresses associated with NAT Gateways"
  value = aws_eip.nat[*].public_ip
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value = aws_vpc.main.cidr_block
}