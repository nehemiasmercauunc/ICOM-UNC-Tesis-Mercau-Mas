output "repository_arns" {
  description = "Map of repository names to ARNs."
  value = {
    for name, repo in module.repositories : name => repo.repository_arn
  }
}

output "repository_urls" {
  description = "Map of repository names to repository URLs."
  value = {
    for name, repo in module.repositories : name => repo.repository_url
  }
}

output "repository_names" {
  description = "Repository names managed by this module."
  value       = keys(module.repositories)
}
