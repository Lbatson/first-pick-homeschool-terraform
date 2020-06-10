# Specify provider and access details
provider "aws" {
    version = "~> 2.65"
    profile = "fphs"
    region  = var.region
}
