locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  environment  = local.account_vars.locals.environment
  aws_region   = local.account_vars.locals.aws_region
  state_bucket = local.account_vars.locals.state_bucket
  aws_account_id = local.account_vars.locals.aws_account_id
}

remote_state {
  backend = "s3"

  config = {
    bucket       = local.state_bucket
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = local.aws_region
    encrypt      = true
    use_lockfile = true
  }
}

generate "provider" {
  path      = "provider.auto.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "aws" {
  region  = "${local.aws_region}"
  allowed_account_ids = ["${local.aws_account_id}"]

  default_tags {
    tags = {
      Environment = "${local.environment}"
      ManagedBy   = "Terragrunt"
      Lab         = "lab3"
    }
  }
}
EOF
}
