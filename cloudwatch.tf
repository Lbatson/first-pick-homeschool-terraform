# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "fphs" {
    name              = "fphs-${terraform.workspace}"
    retention_in_days = 30

    tags = {
        Environment = terraform.workspace
    }
}

resource "aws_cloudwatch_log_stream" "fphs" {
    name           = "fphs-${terraform.workspace}"
    log_group_name = aws_cloudwatch_log_group.fphs.name
}
