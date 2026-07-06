#Auto Scaling Group module

#template creation
resource "aws_launch_template" "main" {
  name_prefix = "${var.environment}-lt"
  image_id = "ami-0c02fb55956c7d316" #Amazon linux 2
  instance_type = var.environment
  key_name = var.key_name

  vpc_security_group_ids = var.vpc_security_group_ids

  user_data = base64encode(<<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y java-11-amazon-corretto
                            yum install -y tomcat
                            systemctl enable tomcat
                            systemctl start tomcat
                            EOF                
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-web-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


#ASG creation
resource "aws_autoscaling_group" "main" {
  name = "${var.environment}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns = var.target_group_arns
  health_check_type = "ELB"
  health_check_grace_period = 300

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "${var.environment}-web-instance"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = var.environment
    propagate_at_launch = true
  }
}