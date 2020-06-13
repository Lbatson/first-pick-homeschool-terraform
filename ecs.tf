# ECS Cluster
resource "aws_ecs_cluster" "fphs" {
    name               = local.name
    capacity_providers = ["FARGATE"]

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

    tags = local.common_tags
}

# ECS task definition using Fargate and template file
resource "aws_ecs_task_definition" "fphs" {
    family                   = local.name
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    task_role_arn            = aws_iam_role.fphs_ecs_tasks.arn
    execution_role_arn       = aws_iam_role.fphs_ecs_tasks_execution.arn
    # ECS task definition configuration file
    container_definitions    = templatefile("${path.module}/templates/container.json.tmpl", {
        name                 = "fphs-${terraform.workspace}"
        image                = "${aws_ecr_repository.fphs.repository_url}:latest"
        cpu                  = var.fargate_cpu
        memory               = var.fargate_memory
        port                 = var.app_port
        log                  = aws_cloudwatch_log_group.fphs.name
        region               = var.region
        db_host              = aws_db_instance.master.address
        db_port              = local.secrets["db"]["port"]
        db_name              = local.secrets["db"]["name"]
        db_username          = local.secrets["db"]["username"]
        db_password          = local.secrets["db"]["password"]
        django_debug         = local.secrets["django"]["debug"]
        django_secret_key    = local.secrets["django"]["secret_key"]
        django_allowed_hosts = local.secrets["django"]["allowed_hosts"]
        django_db_engine     = local.secrets["django"]["db_engine"]
        django_email_backend = local.secrets["django"]["email_backend"]
    })

    tags = local.common_tags
}

# ECS service: Application
resource "aws_ecs_service" "fphs" {
    name            = local.name
    cluster         = aws_ecs_cluster.fphs.arn
    task_definition = aws_ecs_task_definition.fphs.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        assign_public_ip = true
        security_groups  = [aws_security_group.fphs_ecs.id]
        subnets          = aws_subnet.public.*.id
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.fphs.arn
        container_name   = "fphs-${terraform.workspace}"
        container_port   = var.app_port
    }

    # Allow external changes without Terraform plan difference
    lifecycle {
        ignore_changes = [desired_count]
    }

    depends_on = [
        aws_lb_listener.fphs_app,
        aws_lb_listener.fphs_redirect
    ]

    tags = local.common_tags
}
