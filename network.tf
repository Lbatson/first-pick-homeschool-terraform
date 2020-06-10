# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "fphs" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Environment = terraform.workspace
    }
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
    count             = var.az_count
    cidr_block        = cidrsubnet(aws_vpc.fphs.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.fphs.id

    tags = {
        Environment = terraform.workspace
    }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
    count             = var.az_count
    cidr_block        = cidrsubnet(aws_vpc.fphs.cidr_block, 8, var.az_count + count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.fphs.id

    tags = {
        Environment = terraform.workspace
    }
}

# IGW for the public subnet
resource "aws_internet_gateway" "fphs" {
    vpc_id = aws_vpc.fphs.id

    tags = {
        Environment = terraform.workspace
    }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_vpc.fphs.main_route_table_id
    gateway_id             = aws_internet_gateway.fphs.id
}
