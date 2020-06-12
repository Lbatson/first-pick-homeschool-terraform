// ECS tasks execution role
resource "aws_iam_role" "fphs_ecs_tasks_execution" {
    name               = "fphs-ecs-tasks-execution-role-${terraform.workspace}"
    description        = "ECS tasks execution role"
    assume_role_policy = templatefile("${path.module}/templates/assume_role_policy.json.tmpl", {
        service = "ecs-tasks.amazonaws.com"
    }) 

    tags = local.common_tags
}

// Attach ECS Task Execution Role policy to role
resource "aws_iam_role_policy_attachment" "fphs_ecs_tasks_execution" {
    role       = aws_iam_role.fphs_ecs_tasks_execution.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// ECS tasks role
resource "aws_iam_role" "fphs_ecs_tasks" {
    name               = "fphs-ecs-tasks-role-${terraform.workspace}"
    description        = "ECS tasks role"
    assume_role_policy = templatefile("${path.module}/templates/assume_role_policy.json.tmpl", {
        service = "ecs-tasks.amazonaws.com"
    }) 

    tags = local.common_tags
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

// Attach Cloudwatch log publishing policy to role
resource "aws_iam_role_policy_attachment" "fphs_ecs_tasks_log_publishing" {
    role       = aws_iam_role.fphs_ecs_tasks.name
    policy_arn = aws_iam_policy.fphs_log_publishing.arn
}
