resource "aws_acm_certificate" "fphs" {
    domain_name       = terraform.workspace == "production" ? var.domain : "${terraform.workspace}.${var.domain}"
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Environment = terraform.workspace
    }
}

resource "aws_acm_certificate_validation" "fphs" {
    certificate_arn         = aws_acm_certificate.fphs.arn
    validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
