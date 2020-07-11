resource "aws_s3_bucket" "fphs" {
    bucket = local.name
    acl    = "private"

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = ["https://${local.domain}"]
        expose_headers  = ["ETag"]
        max_age_seconds = 3000
    }

    tags   = local.common_tags
}

resource "aws_s3_bucket_policy" "fphs" {
    bucket = aws_s3_bucket.fphs.id
    policy = templatefile("${path.module}/templates/ecs_s3_data_policy.json.tmpl", {
        bucket    = local.name
        principal = aws_iam_role.fphs_ecs_tasks.arn
    })
}

data "aws_elb_service_account" "fphs" {}

resource "aws_s3_bucket" "fphs_logs" {
    bucket = "${local.name}-logs"
    acl    = "private"

    tags = local.common_tags
}

resource "aws_s3_bucket_policy" "lb_logs" {
    bucket = aws_s3_bucket.fphs_logs.id
    policy = templatefile("${path.module}/templates/lb_s3_log_policy.json.tmpl", {
        bucket    = "${local.name}-logs"
        prefix    = "lb"
        principal = data.aws_elb_service_account.fphs.arn
    })
}
