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
  # ------------------------------------------------------------------------------------------------
  # EKS 클러스터 API 엔드포인트 액세스 설정 (모듈 v19.x 이상에서 직접 인자로 사용)
  # ------------------------------------------------------------------------------------------------
  cluster_endpoint_public_access  = true  # Private에서 Public으로 변경
  #endpoint_private_access = true  # (권장) Private Access도 유지 (Public and Private 모드)
  # 완전히 Public만 원하면 false로 설정

  # public_access_cidrs를 반드시 지정해야 합니다!
  # 이곳에 kubectl을 실행할 PC의 퍼블릭 IP 주소 또는 허용할 IP 범위(CIDR)를 입력합니다.
  # 예: ["1.2.3.4/32"], 또는 회사 VPN 대역 등
  cluster_endpoint_public_access_cidrs     = ["1.233.102.123/32"]

  # 기존 manage_aws_auth_configmap, aws_auth_users 대신 access_entries 사용
  access_entries = {
    june = {
      principal_arn        = "arn:aws:iam::093490087589:user/june"
      access_policies_arns = ["eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"]
    }
    eks_admin_user = {
      # userarn은 IAM User ARN이어야 합니다.
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.admin_user.name}"
      access_policies_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"] # 필요에 따라 추가 정책 ARN 지정
    }
    # IAM Role에 대한 접근 권한을 부여하는 경우
     eks_admin_role = {
       principal_arn = aws_iam_role.eks_admin_role.arn # IAM Role ARN
       access_policies_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"] # 필요에 따라 추가 정책 ARN 지정
     }
  }

  eks_managed_node_groups = {
    eks-module = {
      desired_size = var.desired_size
      max_size     = var.max_size
      min_size     = var.min_size

      instance_types = [var.instance_type]
      capacity_type  = "ON_DEMAND" # 또는 "SPOT"
      disk_size      = 8
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

# AWS Caller Identity (현재 AWS 계정 ID를 가져오기 위해)
data "aws_caller_identity" "current" {}

# AWS Availability Zones (사용 가능한 AZ 목록을 가져오기 위해)
data "aws_availability_zones" "available" {
  state = "available"
}