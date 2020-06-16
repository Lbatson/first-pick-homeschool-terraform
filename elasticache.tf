resource "aws_elasticache_subnet_group" "fphs" {
    name       = local.name
    subnet_ids = aws_subnet.private.*.id
}

resource "aws_elasticache_cluster" "fphs" {
    cluster_id           = local.name
    engine               = local.secrets["cache"]["engine"]
    engine_version       = local.secrets["cache"]["engine_version"]
    parameter_group_name = local.secrets["cache"]["parameter_group_name"]
    node_type            = var.elasticache_node_type
    num_cache_nodes      = var.elasticache_node_count
    port                 = local.secrets["cache"]["port"]
    subnet_group_name    = aws_elasticache_subnet_group.fphs.name
    security_group_ids   = [aws_security_group.fphs_elasticache.id]

    tags = local.common_tags
}
