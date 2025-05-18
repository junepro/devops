terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws ={
      source = "hashicorp/aws"
      version = ">= 5.31"
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.5.1"
      #version = "~> 2.5"
      version = "~> 2.9"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      #version = "~> 2.1"
      version = "~> 3.3"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
#  backend "s3" {
#    bucket = "aws-eks-tf-test"
#    key    = "dev/eks-cluster/terraform.tfstate"
#    region = "ap-northeast-2"
##    encrypt        = true
#    # For State Locking
#    dynamodb_table = "dev-ekscluster"
#  }
}

provider "aws" {
  region = var.aws_region
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}

#provider "kubernetes" {
#  host = aws_eks_cluster.eks_cluster.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
#  token = data.aws_eks_cluster_auth.cluster.token
#}
#
#data "aws_eks_cluster_auth" "cluster" {
#  name = aws_eks_cluster.eks_cluster.id
#}