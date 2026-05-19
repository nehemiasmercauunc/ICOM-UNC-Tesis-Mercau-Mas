include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/ecr"
}

inputs = {
  repository_names = [
    "b4c0c6w7/tesis/tp1-frontend",
    "b4c0c6w7/tesis/tp1-backend"
  ]

  image_tag_mutability    = "MUTABLE"
  scan_on_push            = true
  create_lifecycle_policy = true
  force_delete            = false

  tags = {
    Environment = "dev"
    Project     = "tp4"
  }
}
