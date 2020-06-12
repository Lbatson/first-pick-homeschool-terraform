resource "aws_ecr_repository" "fphs" {
    name                 = local.name
    image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "fphs" {
    repository = aws_ecr_repository.fphs.name
    policy = templatefile("${path.module}/templates/ecr_lifecycle_policy.json.tmpl", {
        count = var.ecr_image_count
    })
}
