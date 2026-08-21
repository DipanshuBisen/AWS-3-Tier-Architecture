output "Jenkins_Public_IP" {
    description = "Jenkins public ec2 instance ip"
    value = aws_instance.jenkins_ec2.public_ip
}

output "jenkins_URL" {
  description = "Jenkins public URL"
  value = "http://${aws_instance.jenkins_ec2.public_ip}:8080"
}

output "jenkins_username" {
  description = "Jenkins Username"
  value = "admin"
}

output "jenkins_port" {
  description = "Jenkins port"
  value = 8080
}