module "loadbalancer_sg"  {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name = "loadbalancer_sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = ["http-80-tcp"]
  egress_rules = ["all-all"]
  tags = local.common_tags

  #ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_cidr_blocks = [
    {
      from_port = 81
      to_port = 81
      protocol = 6
      description = "allow port 81 from internet"
      cidr_blocks =  "0.0.0.0./0"
    }
  ]

}