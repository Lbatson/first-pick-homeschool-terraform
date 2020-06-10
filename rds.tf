# RDS subnet group
resource "aws_db_subnet_group" "fphs" {
    name       = "fphs-${terraform.workspace}"
    subnet_ids = aws_subnet.private.*.id

    tags = {
        Environment = terraform.workspace
    }
}

# RDS (Postgres)
resource "aws_db_instance" "master" {
    identifier                  = "fphs-${terraform.workspace}"
    name                        = var.rds_db_name
    username                    = var.rds_username
    password                    = var.rds_password
    port                        = var.rds_port
    engine                      = var.rds_engine
    engine_version              = var.rds_engine_version
    instance_class              = var.rds_instance
    multi_az                    = var.multi_az
    allocated_storage           = var.rds_allocated_storage
    storage_type                = var.rds_storage_type
    storage_encrypted           = false
    publicly_accessible         = false
    vpc_security_group_ids      = [aws_security_group.fphs_rds.id]
    db_subnet_group_name        = aws_db_subnet_group.fphs.name
    parameter_group_name        = "default.fphs"
    allow_major_version_upgrade = false
    auto_minor_version_upgrade  = true
    apply_immediately           = true
    copy_tags_to_snapshot       = true
    skip_final_snapshot         = false
    final_snapshot_identifier   = "fphs-${terraform.workspace}-final"
    maintenance_window          = "sun:02:00-sun:04:00"
    backup_window               = "04:00-06:00"
    backup_retention_period     = 30

    tags = {
        Environment = terraform.workspace
    }
}
