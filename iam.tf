resource "aws_iam_service_linked_role" "ecs_service" {
    aws_service_name = "ecs.amazonaws.com"
}

// ECS task definition role
resource "aws_iam_role" "fphs_ecs" {
    name               = "fphs-ecs-role-${terraform.workspace}"
    description        = "ECS task definition role"
    assume_role_policy = templatefile("${path.module}/templates/assume_role_policy.json.tmpl", {
        service = "ecs-tasks.amazonaws.com"
    }) 

    tags = {
        Environment = terraform.workspace
    }
}

// Cloudwatch log publishing policy
resource "aws_iam_policy" "fphs_log_publishing" {
    name        = "fphs-log-publishing-${terraform.workspace}"
    description = "Allow publishing logs to CloudWatch"
    policy      = templatefile("${path.module}/templates/log_publishing_policy.json.tmpl", {
        region = var.region
        name   = aws_cloudwatch_log_group.fphs.name
    })
}

// Attach Cloudwatch log publishing policy to ECS role
resource "aws_iam_role_policy_attachment" "fphs_ecs_log_publishing" {
    role       = aws_iam_role.fphs_ecs.name
    policy_arn = aws_iam_policy.fphs_log_publishing.arn
}
