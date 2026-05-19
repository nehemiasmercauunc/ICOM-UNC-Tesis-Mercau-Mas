locals {
  repositories = toset(var.repository_names)
}

module "repositories" {
  for_each = local.repositories

  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"

  repository_name                 = each.value
  repository_force_delete         = var.force_delete
  repository_image_tag_mutability = var.image_tag_mutability
  repository_image_scan_on_push   = var.scan_on_push

  create_lifecycle_policy     = var.create_lifecycle_policy
  repository_lifecycle_policy = var.lifecycle_policy_json

  tags = var.tags
}
