locals {
  owners = var.business_division
  env = var.env
  name = "${var.business_division}-${var.env}"
  common_tags = {
    owners = local.owners
    env = local.env
  }
}