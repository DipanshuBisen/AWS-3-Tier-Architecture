output "rds_insatnace_id" {
  description = "RDS instance id"
  value = aws_db_instance.main.id
}

output "rds_insatnace_endpoint" {
  description = "RDS insatnace endpoint"
  value = aws_db_instance.main.endpoint
}

output "rds_instance_port" {
  description = "RDS instance port"
  value = aws_db_instance.main.port
}