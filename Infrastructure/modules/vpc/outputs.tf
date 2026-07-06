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