#EC2 instance for Jenkins

resource "aws_instance" "jenkins_ec2" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    subnet_id = var.bastion_subnet_id
    associate_public_ip_address = true

    user_data = base64encode(<<-EOF
                              #!/bin/bash
                              set -eux

                              # Update packages
                              apt-get update -y

                              # Install Java and dependencies
                              apt-get install -y fontconfig openjdk-21-jre curl gnupg

                              # Add Jenkins repository key
                              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
                              gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

                              # Add Jenkins repository
                              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" \
                              > /etc/apt/sources.list.d/jenkins.list

                              # Update package list
                              apt-get update -y

                              # Install Jenkins
                              apt-get install -y jenkins

                              # Enable and start Jenkins
                              systemctl enable jenkins
                              systemctl start jenkins

                              # Wait until Jenkins creates the initial password
                              until [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
                                  sleep 5
                              done

                              # Copy password for Ubuntu user
                              cp /var/lib/jenkins/secrets/initialAdminPassword /home/ubuntu/jenkins-password.txt
                              chown ubuntu:ubuntu /home/ubuntu/jenkins-password.txt
                              chmod 600 /home/ubuntu/jenkins-password.txt

                              EOF
)

    iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

    vpc_security_group_ids = module.security.jenkins_ec2_security_group_id

    tags = {
      Name = "${var.environment}-jenkins-ec2"
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