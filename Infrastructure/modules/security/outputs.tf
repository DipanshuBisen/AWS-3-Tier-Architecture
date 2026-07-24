output "db_security_group_id" {
  description = "DB security group ID"
  value = aws_security_group.db.id
}

output "alb_security_group_id" {
  description = "ALB security group Id"
  value = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "APP security group ID"
  value = aws_security_group.app.id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value = aws_security_group.bastion.id
}

output "jenkins_ec2_security_group_id" {
  description = "Jenkins EC2 Security group ID"
  value = aws_security_group.jenkins_ec2.id
}