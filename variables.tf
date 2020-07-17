variable "domain" {
    default = "firstpickhomeschool.com"
}

variable "log_level" {
    default = "error"
}

variable "region" {
    default = "us-east-2"
}

variable "az_count" {
    default = "2"
}

variable "app_count" {
    default = "1"
}

variable "app_port" {
    default = "8000"
}

variable "fargate_cpu" {
    default = "1024"
}

variable "fargate_memory" {
    default = "2048"
}

variable "rds_instance" {
    default = "db.t2.micro"
}

variable "rds_multi_az" {
    default = false
}

variable "rds_allocated_storage" {
    default = 20
}

variable "rds_storage_type" {
    default = "gp2"
}

variable "ecr_image_count" {
    default = 10
}

variable "elasticache_node_type" {
    default = "cache.t3.micro"
}

variable "elasticache_node_count" {
    default = 1
}
