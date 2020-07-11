resource "aws_lb" "fphs" {
    name               = local.name
    internal           = false
    load_balancer_type = "application"
    subnets            = aws_subnet.public.*.id
    security_groups    = [aws_security_group.fphs_lb.id]

    access_logs {
        bucket  = aws_s3_bucket.fphs_logs.bucket
        prefix  = "lb"
        enabled = true
    }

    tags = local.common_tags
}

resource "aws_lb_target_group" "fphs" {
    name                          = local.name
    port                          = var.app_port
    protocol                      = "HTTP"
    target_type                   = "ip"
    load_balancing_algorithm_type = "least_outstanding_requests"
    vpc_id                        = aws_vpc.fphs.id

    health_check {
        path    = "/health/"
        matcher = "200"
        enabled = true
    }

    tags = local.common_tags
}

resource "aws_lb_listener" "fphs_app" {
    load_balancer_arn = aws_lb.fphs.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = aws_acm_certificate_validation.fphs.certificate_arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.fphs.arn
    }
}

resource "aws_lb_listener" "fphs_redirect" {
    load_balancer_arn = aws_lb.fphs.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}
