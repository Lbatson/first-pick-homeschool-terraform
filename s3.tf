resource "aws_s3_bucket" "fphs_logs" {
    bucket = "fphs-logs-${terraform.workspace}"
    acl    = "private"

    tags = {
        Environment = terraform.workspace
    }
}