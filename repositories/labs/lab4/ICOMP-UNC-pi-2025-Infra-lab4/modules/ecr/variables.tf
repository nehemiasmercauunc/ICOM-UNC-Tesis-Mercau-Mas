variable "repository_names" {
  description = "List of ECR repository names to create/manage."
  type        = list(string)
}

variable "force_delete" {
  description = "Delete repository even if it contains images."
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "Tag mutability for repositories."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scan on push."
  type        = bool
  default     = true
}

variable "create_lifecycle_policy" {
  description = "Create lifecycle policy for repositories."
  type        = bool
  default     = true
}

variable "lifecycle_policy_json" {
  description = "Lifecycle policy JSON content."
  type        = string
  default     = <<-EOT
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 images",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOT
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
