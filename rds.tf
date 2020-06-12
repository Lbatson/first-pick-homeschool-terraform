# RDS subnet group
resource "aws_db_subnet_group" "fphs" {
    name       = local.name
    subnet_ids = aws_subnet.private.*.id

    tags = local.common_tags
}

# RDS (Postgres)
resource "aws_db_instance" "master" {
    identifier                  = local.name
    name                        = local.secrets["db"]["name"]
    username                    = local.secrets["db"]["username"]
    password                    = local.secrets["db"]["password"]
    port                        = local.secrets["db"]["port"]
    engine                      = local.secrets["db"]["engine"]
    engine_version              = local.secrets["db"]["engine_version"]
    instance_class              = var.rds_instance
    multi_az                    = var.rds_multi_az
    allocated_storage           = var.rds_allocated_storage
    storage_type                = var.rds_storage_type
    storage_encrypted           = false
    publicly_accessible         = false
    vpc_security_group_ids      = [aws_security_group.fphs_rds.id]
    db_subnet_group_name        = aws_db_subnet_group.fphs.name
    allow_major_version_upgrade = false
    auto_minor_version_upgrade  = true
    apply_immediately           = true
    copy_tags_to_snapshot       = true
    skip_final_snapshot         = false
    final_snapshot_identifier   = "fphs-${terraform.workspace}-final"
    maintenance_window          = "sun:02:00-sun:04:00"
    backup_window               = "04:00-06:00"
    backup_retention_period     = 30

    tags = local.common_tags
}
