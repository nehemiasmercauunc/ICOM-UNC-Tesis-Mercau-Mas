locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  environment    = local.account_vars.locals.environment
  aws_region     = local.account_vars.locals.aws_region
  state_bucket   = local.account_vars.locals.state_bucket
  aws_account_id = local.account_vars.locals.aws_account_id

  aws_profile          = get_env("AWS_PROFILE", "default")
  aws_credentials_file = "${get_env("HOME", "/root")}/.aws/credentials"
}

remote_state {
  backend = "s3"

  config = {
    bucket       = local.state_bucket
    key          = "lab4/${path_relative_to_include()}/terraform.tfstate"
    region       = local.aws_region
    encrypt      = true
    use_lockfile = true
  }
}

terraform {
  extra_arguments "aws_sts_regional_endpoints" {
    commands = [
      "init",
      "validate",
      "plan",
      "apply",
      "destroy",
      "refresh",
      "import",
      "output",
      "state",
      "force-unlock",
    ]
    env_vars = {
      # Provider AWS 5.x ya no acepta sts_regional_endpoints; el SDK lee esto (no son credenciales).
      AWS_STS_REGIONAL_ENDPOINTS = "regional"
    }
  }
}

generate "provider" {
  path      = "provider.auto.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "aws" {
  region  = "${local.aws_region}"
  allowed_account_ids = ["${local.aws_account_id}"]

  profile                  = "${local.aws_profile}"
  shared_credentials_files = ["${local.aws_credentials_file}"]
  shared_config_files      = []

  default_tags {
    tags = {
      Environment = "${local.environment}"
      ManagedBy   = "Terragrunt"
      Lab         = "lab4"
    }
  }
}
EOF
}
