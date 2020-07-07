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
        # ECS task settings
        name                 = "fphs-${terraform.workspace}"
        image                = "${aws_ecr_repository.fphs.repository_url}:latest"
        cpu                  = var.fargate_cpu
        memory               = var.fargate_memory
        port                 = var.app_port
        log                  = aws_cloudwatch_log_group.fphs.name
        region               = var.region
        # Django application settings
        django_settings_module       = local.secrets["django"]["settings_module"]
        django_debug                 = local.secrets["django"]["debug"]
        django_secret_key            = local.secrets["django"]["secret_key"]
        django_allowed_hosts         = local.secrets["django"]["allowed_hosts"]
        django_admin_url             = local.secrets["django"]["admin"]["url"]
        django_account_allow_reg     = local.secrets["django"]["admin"]["account_allow_registration"]
        django_db_engine             = local.secrets["django"]["db"]["engine"]
        django_db_host               = aws_db_instance.master.address
        django_db_port               = local.secrets["db"]["port"]
        django_db_name               = local.secrets["db"]["name"]
        django_db_username           = local.secrets["db"]["username"]
        django_db_password           = local.secrets["db"]["password"]
        django_cache_backend         = local.secrets["django"]["cache"]["backend"]
        django_cache_location        = "${aws_elasticache_cluster.fphs.cache_nodes.0.address}:${aws_elasticache_cluster.fphs.cache_nodes.0.port}"
        django_cache_timeout         = local.secrets["django"]["cache"]["timeout"]
        django_cache_options         = local.secrets["django"]["cache"]["options"]
        django_email_backend         = local.secrets["django"]["email"]["backend"]
        django_anymail_options       = local.secrets["django"]["email"]["anymail_options"]
        django_default_from_email    = local.secrets["django"]["email"]["default_from_email"]
        django_server_email          = local.secrets["django"]["email"]["server_email"]
        django_aws_storage_bucket    = aws_s3_bucket.fphs.bucket_domain_name
        django_aws_s3_region_name    = aws_s3_bucket.fphs.region
        django_sentry_dsn            = local.secrets["django"]["logging"]["sentry_dsn"]
        django_sentry_log_level      = local.secrets["django"]["logging"]["sentry_log_level"]
        django_recaptcha_public_key  = local.secrets["django"]["security"]["recaptcha"]["public_key"]
        django_recaptcha_private_key = local.secrets["django"]["security"]["recaptcha"]["private_key"]
        django_compress_enabled      = local.secrets["django"]["performance"]["compress_enabled"]
        django_web_concurrency       = local.secrets["django"]["performance"]["web_concurrency"]
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
