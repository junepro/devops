provider "aws" {
    region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "demo-tf-2025"
    key = "first-steps"
    region = "ap-northeast-2"
  }
}