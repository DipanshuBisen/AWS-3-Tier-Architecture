#Security Group module

#ALB security group
resource "aws_security_group" "alb" {
  name = "${var.environment}-alb-sg"
  description = "Security group for application load balancer"
  vpc_id = var.vpc_id

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
    Environment = var.environment
  }

}

#Application Security group
resource "aws_security_group" "app" {
  name = "${var.environment}-app-sg"
  description = "Security group for application server"
  vpc_id = var.vpc_id

  ingress{
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [ aws_security_group.alb.id ]
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.alb.id ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

#Database security group
resource "aws_security_group" "db" {
  name = "${var.environment}-db-sg"
  description = "Security group for databse"
  vpc_id = var.vpc_id

  ingress{
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [ aws_security_group.app.id ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-db-sg"
    Environment = var.environment
  }
}

#Security group for Bastian host
resource "aws_security_group" "bastion" {
  name = "${var.environment}-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id = var.bastion_vpc_id

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_block
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
        Name = "${var.environment}-bastion-sg"
        Environment = var.environment
  }
}


#Security Group for Jenkins Ec2 instance 
resource "aws_security_group" "jenkins_ec2" {
  name = "${var.environment}-jenkins-ec2-sg"
  description = "Security group for jenkins ec2"
  vpc_id = var.bastion_vpc_id

  ingress{
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
        Name = "${var.environment}-jenkins-ec2-sg"
        Environment = var.environment
  }
}