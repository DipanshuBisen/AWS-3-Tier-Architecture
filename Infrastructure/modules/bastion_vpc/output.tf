output "public_subnet_id" {
  description = "Public subnet id of bastion hots"
  value = aws_subnet.public_bastion.id
}

output "bastion_vpc_id" {
  description = "Bastion VPC ID"
  value = aws_vpc.bastion.id
}