
# AWS Provider Name
terraform {
  required_providers {
    aws = {
         source  = "hashicorp/aws"
         version = "6.40.0"
    }
  }
}

# AWS Default Regions

provider "aws" {
   region = "ap-south-1"
}



