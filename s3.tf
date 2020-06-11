data "aws_elb_service_account" "fphs" {}

resource "aws_s3_bucket" "fphs_logs" {
    bucket = "fphs-logs-${terraform.workspace}"
    acl    = "private"

    tags = {
        Environment = terraform.workspace
    }
}

resource "aws_s3_bucket_policy" "lb_logs" {
    bucket = aws_s3_bucket.fphs_logs.id
    policy = templatefile("${path.module}/templates/lb_s3_log_policy.json.tmpl", {
        bucket    = "fphs-logs-${terraform.workspace}"
        prefix    = "lb"
        principal = data.aws_elb_service_account.fphs.arn
    })
}