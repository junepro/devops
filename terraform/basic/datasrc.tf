data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "terraform_remote_state" "first-steps" {
  backend = "s3"

  config = {
    bucket = "demo-tf-2025"
    key = "first-steps"
    region = "ap-northeast-2"
  }
}

locals {
  vpc_id = data.terraform_remote_state.first-steps.outputs.vpc_id
}

output "vpc_id" {
  value = local.vpc_id
}

//data "aws_caller_identity" "current" {}

//data "aws_region" "current" {}