packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "java_login" {

  region = var.aws_region

  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"]
    most_recent = true
  }

  instance_type = "t3.micro"

  ssh_username = "ubuntu"

  ami_name = var.ami_name

  tags = {
    Application = "Java-Login-App"
    ManagedBy   = "Packer"
    Environment = "all"
  }
}

build {

  sources = [
    "source.amazon-ebs.java_login"
  ]

  provisioner "shell" {
    script = "scripts/install-app.sh"

    environment_vars = [
      "JAR_URL=${var.jar_url}",
      "JFROG_USERNAME=${var.jfrog_username}",
      "JFROG_PASSWORD=${var.jfrog_password}"
    ]
  }
}