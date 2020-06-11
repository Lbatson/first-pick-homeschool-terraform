variable "domain" {
    default = "firstpickhomeschool.com"
}

variable "log_level" {
    default = "error"
}

variable "region" {
    default = "us-east-2"
}

variable "multi_az" {
    default = true 
}

variable "az_count" {
    default = "2"
}

variable "app_count" {
    default = "2"
}

variable "app_image" {
    default = "nginx:latest"
}

variable "app_port" {
    default = "80"
}

variable "fargate_cpu" {
    default = "512"
}

variable "fargate_memory" {
    default = "1024"
}

variable "rds_instance" {
    default = "db.t2.micro"
}

variable "rds_engine" {
    default = "postgres"
}

variable "rds_engine_version" {
    default = "11.7"
}

variable "rds_port" {
    default = "5432"
}

variable "rds_db_name" {
    default = "fphs"
}

variable "rds_allocated_storage" {
    default = 20  
}

variable "rds_storage_type" {
    default = "gp2"
}

variable "rds_username" {
    default = "admin"
}

variable "rds_password" {
    default = "password"
}
