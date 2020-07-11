resource "aws_acm_certificate" "fphs" {
    domain_name       = local.domain
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }

    tags = local.common_tags
}

resource "aws_acm_certificate_validation" "fphs" {
    certificate_arn         = aws_acm_certificate.fphs.arn
    validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
