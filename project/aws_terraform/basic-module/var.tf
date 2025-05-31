# variables.tf
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2" # 원하는 리전으로 변경하세요 (예: us-east-1, ap-northeast-2)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "instance_type" {
  description = "EC2 Instance type for EKS worker nodes"
  type        = string
  default     = "t2.micro" # 적절한 인스턴스 타입으로 변경하세요
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 0
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "cidr_block" {
  description = "VPC CIDR Block"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
  # 이 부분은 실제 VPC의 서브넷 ID로 대체해야 합니다.
  # 예를 들어, data "aws_subnets"를 사용하여 동적으로 가져올 수도 있습니다.
  # 또는 직접 VPC와 서브넷을 Terraform으로 생성하고 그 출력을 사용할 수도 있습니다.
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
  # 이 부분은 실제 VPC의 서브넷 ID로 대체해야 합니다.
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "env" {
  description = ""
  type = string
  default = "dev"
}

#variable "vpc_id" {
#  description = "VPC ID where the EKS cluster will be deployed"
#  type        = string
#  default     = module.vpc.vpc_id # 실제 VPC ID로 변경하세요!
#}