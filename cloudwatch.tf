# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "fphs" {
    name              = local.name
    retention_in_days = 30

    tags = local.common_tags
}

resource "aws_cloudwatch_log_stream" "fphs" {
    name           = local.name
    log_group_name = aws_cloudwatch_log_group.fphs.name
}
