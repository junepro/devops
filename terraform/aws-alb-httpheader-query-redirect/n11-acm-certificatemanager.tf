module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "2.14.0"

  domain_name  = trimsuffix("example.com.","." )
  zone_id      = data.aws_route53_zone.mydomain.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.example.com",
  ]

  wait_for_validation = true

  tags = local.common_tags
}