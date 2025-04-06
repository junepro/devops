module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = trimsuffix(data.aws_route53_zone.mydomain.name,".")
  zone_id      = "Z2ES7B9AZ6SHAE"

  validation_method = "DNS"

  subject_alternative_names = [
    "*.my-domain.com"
  ]
  wait_for_validation = true

}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  # Module Upgrade Change-2
  #value       = module.acm.this_acm_certificate_arn
  value       = module.acm.acm_certificate_arn
}
