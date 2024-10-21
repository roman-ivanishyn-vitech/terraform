resource "aws_route53_zone" "main_zone" {
  name = "mentorship.pp.ua"
}

resource "aws_acm_certificate" "my_cert" {
  domain_name       = "mentorship.pp.ua"
  validation_method = "DNS"

  tags = {
    Name = "mentorship-certificate"
    Env  = var.environment
  }
}

resource "aws_route53_record" "app_record" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name     = "mentorship.pp.ua"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.mentorship_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.mentorship_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
