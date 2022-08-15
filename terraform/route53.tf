data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "loboandzorra" {
  provider          = aws.acm_provider
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}


resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.loboandzorra.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.loboandzorra.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.loboandzorra.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.public.id
  ttl             = 60
}


resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.loboandzorra.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.public.id
  name    = var.domain_name

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.my_cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}