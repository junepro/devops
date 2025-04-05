module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  depends_on = [module.vpc]
  name = "${var.env}-vm"
  ami  = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  user_data = file("${path.module}/app1-install.sh")
  for_each = toset(["0","1"])
  subnet_id = element(module.vpc.private_subnets,tonumber(each.key))
  vpc_security_group_ids = [module.private_sg.security_group_id]
  tags = local.common_tags
}