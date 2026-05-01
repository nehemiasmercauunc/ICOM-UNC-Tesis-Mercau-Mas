output "vpc_id" {
  description = "VPC identifier."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet identifiers."
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet identifiers."
  value       = module.vpc.private_subnets
}
