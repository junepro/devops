terraform {
  required_providers {
    aws ={
      source = "hashicorp/aws"
      version =">=5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-on-aws-for-ec2"
    key = "dev/project1-vpc/terraform.tfstate" #버킷 경로
    region = "ap-northeast-2"
    dynamodb_table = "dev-project-vpc"
  }
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}
