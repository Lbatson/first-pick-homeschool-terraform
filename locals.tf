data "aws_secretsmanager_secret" "fphs" {
    name = "fphs-${terraform.workspace}"
}

data "aws_secretsmanager_secret_version" "fphs" {
    secret_id  = data.aws_secretsmanager_secret.fphs.id
}

locals {
    name        = "fphs-${terraform.workspace}"
    secrets     = jsondecode(data.aws_secretsmanager_secret_version.fphs.secret_string)
    common_tags = {
        Environment = terraform.workspace
    }
}
