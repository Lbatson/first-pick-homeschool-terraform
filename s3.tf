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