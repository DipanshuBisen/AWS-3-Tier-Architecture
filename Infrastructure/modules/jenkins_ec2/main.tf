#EC2 instance for Jenkins

resource "aws_instance" "jenkins_ec2" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    subnet_id = var.bastion_subnet_id

    user_data = base64decode()

    tags = {
      Name = "${var.environment}-jenkins-ec2"
      Environment = var.environment
    }
}