# main.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.cidr_block

  azs             = ["${var.aws_region}a", "${var.aws_region}c"] # 2개의 AZ 사용
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Environment = "dev"
    Project     = "EKS-Demo"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # EKS 모듈 버전을 명시합니다. 최신 안정 버전을 사용하는 것을 권장합니다.

  cluster_name    = var.cluster_name
  cluster_version = "1.31" # 원하는 EKS 클러스터 버전으로 변경하세요 (예: 1.27, 1.28)

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets # EKS는 일반적으로 프라이빗 서브넷에 배포됩니다.
  control_plane_subnet_ids = module.vpc.private_subnets # 컨트롤 플레인도 프라이빗 서브넷에 배포

#  cluster_addons = {
#    coredns                = {}
#    eks-pod-identity-agent = {}
#    kube-proxy             = {}
#    vpc-cni                = {}
#  }

  # EKS 클러스터 액세스 제어
  # kubectl을 사용하여 클러스터에 접근할 수 있도록 IAM 사용자를 추가합니다.
  # 여기서 users는 당신의 IAM 사용자 ARN을 명시해야 합니다.
#  manage_aws_auth_configmap = true
#  aws_auth_users = [
#    {
#      userarn  = "arn:aws:iam::ACCOUNT_ID:user/YOUR_IAM_USERNAME" # YOUR_IAM_USERNAME을 실제 IAM 사용자 이름으로, ACCOUNT_ID를 실제 AWS 계정 ID로 변경
#      username = "YOUR_IAM_USERNAME"
#      groups   = ["system:masters"]
#    }


  eks_managed_node_groups = {
    eks-module = {
      desired_size = var.desired_size
      max_size     = var.max_size
      min_size     = var.min_size

      instance_types = [var.instance_type]
      # capacity_type  = "ON_DEMAND" # 또는 "SPOT"

      # 노드 그룹에 추가적인 레이블이나 태그를 지정할 수 있습니다.
      labels = {
        "node-group-type" = "default"
      }
      tags = {
        "Environment" = "dev"
        "Project"     = "EKS-Demo"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "EKS-Demo"
  }
}

#resource "aws_dynamodb_table" "terraform_state_lock"{
#  name = "terraform-lock"
#  hash_key = "LockID"
#  billing_mode = "PAY_PER_REQUEST"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}
