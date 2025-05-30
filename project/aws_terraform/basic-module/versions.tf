# versions.tf
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # AWS Provider 버전을 명시합니다. 최신 안정 버전을 사용하는 것을 권장합니다.
    }
  }
  backend "s3" {
    bucket         = "eks-module-demo" # 실제 S3 버킷 이름으로 변경
    key            = "terraform/terraform.tfstate" # 상태 파일이 저장될 S3 내 경로 및 파일명
    region         = "ap-northeast-2"                   # S3 버킷이 있는 AWS Region
    encrypt        = true                               # 상태 파일 암호화 활성화
    dynamodb_table = "terraform_state_lock"        # 실제 DynamoDB 테이블 이름으로 변경
  }
}

provider "aws" {
  region = var.aws_region
}