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
    default = "2"
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

variable "rds_multi_az" {
    default = true 
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
