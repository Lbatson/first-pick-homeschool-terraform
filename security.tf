# Security Groups

# Internet to ALB
resource "aws_security_group" "fphs_lb" {
    name        = "fphs-alb-${terraform.workspace}"
    description = "Allow access to port 443 only"
    vpc_id      = aws_vpc.fphs.id
    
    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = terraform.workspace
    }
}

# ALB TO ECS
resource "aws_security_group" "fphs_ecs" {
    name        = "fphs-ecs-${terraform.workspace}"
    description = "Allow inbound access from ALB only"
    vpc_id      = aws_vpc.fphs.id

    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        security_groups = [aws_security_group.fphs_lb.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = terraform.workspace
    }
}

# ECS to RDS
resource "aws_security_group" "fphs_rds" {
    name        = "fphs-rds-${terraform.workspace}"
    description = "Allow inbound access from ECS only"
    vpc_id      = aws_vpc.fphs.id

    ingress {
        protocol        = "tcp"
        from_port       = var.rds_port
        to_port         = var.rds_port
        security_groups = [aws_security_group.fphs_ecs.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = terraform.workspace
    }
}
