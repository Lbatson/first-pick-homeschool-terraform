resource "aws_route53_zone" "fphs" {
    count = terraform.workspace == "production" ? 1 : 0
    name  = "fphs"
}

data "aws_route53_zone" "fphs" {
    name         = "fphs"
    private_zone = false
    depends_on   = [aws_route53_zone.fphs]
}

resource "aws_route53_record" "www" {
    count   = terraform.workspace == "production" ? 1 : 0
    zone_id = data.aws_route53_zone.fphs.zone_id
    name    = "www.${var.domain}"
    type    = "CNAME"
    ttl     = 60
    records = [var.domain]
}

resource "aws_route53_record" "apex" {
    count   = terraform.workspace == "production" ? 1 : 0
    zone_id = data.aws_route53_zone.fphs.zone_id
    name    = var.domain
    type    = "A"

    alias {
        name                   = aws_lb.fphs.dns_name
        zone_id                = aws_lb.fphs.zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "subdomain" {
    count   = terraform.workspace == "production" ? 0 : 1
    zone_id = data.aws_route53_zone.fphs.zone_id
    name    = "${terraform.workspace}.${var.domain}"
    type    = "A"

    alias {
        name                   = aws_lb.fphs.dns_name
        zone_id                = aws_lb.fphs.zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "cert_validation" {
    zone_id = data.aws_route53_zone.fphs.zone_id
    name = lookup(aws_acm_certificate.fphs.domain_validation_options[0], "resource_record_name")
    type = lookup(aws_acm_certificate.fphs.domain_validation_options[0], "resource_record_type")
    ttl = 60
    records = [lookup(aws_acm_certificate.fphs.domain_validation_options[0], "resource_record_value")]
    depends_on = [aws_acm_certificate.fphs]
}
