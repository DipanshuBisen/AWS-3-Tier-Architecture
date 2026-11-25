#EC2 instance for Jenkins

#EC2 Instance for the Controller
resource "aws_instance" "jenkins_ec2" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    subnet_id = var.helper_subnet_id
    associate_public_ip_address = true

    user_data = file("${path.module}/user_data.sh")
    
    iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

    vpc_security_group_ids = module.security.jenkins_ec2_security_group_id

    tags = {
      Name = "${var.environment}-jenkins-ec2"
      Environment = var.environment
    }
}

#EC2 instance for the Agent
resource "aws_instance" "jenkins_ec2_agent" {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id = var.helper_subnet_id

  tags = {
    Name = "${var.environment}-jenkins-ec2-agent"
    Environment = var.environment
  }
}

#SSH the EC2 instance and then take password from there

#Now creating iam role and policy so that jenkins can able to access the things inside aws.

#Jenkins IAM role 
resource "aws_iam_role" "jenkins_role" {
    name = "jenkins_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"

            principal = {
                Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
  
}


#Now give the policy
resource "aws_iam_policy" "jenkins_policy" {

  name = "jenkins-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "*"
        ]

        Resource = "*"
      }

    ]
  })
}


#Attach policy to role
resource "aws_iam_role_policy_attachment" "jenkins_attachment" {

  role       = aws_iam_role.jenkins_role.name

  policy_arn = aws_iam_policy.jenkins_policy.arn

}

#attach instance profile
resource "aws_iam_instance_profile" "jenkins_profile" {

  name = "jenkins-instance-profile"

  role = aws_iam_role.jenkins_role.name

}


#Security Group for Jenkins Ec2 instance 
resource "aws_security_group" "jenkins_ec2" {
  name = "${var.environment}-jenkins-ec2-sg"
  description = "Security group for jenkins ec2"
  vpc_id = var.helper_vpc_id

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