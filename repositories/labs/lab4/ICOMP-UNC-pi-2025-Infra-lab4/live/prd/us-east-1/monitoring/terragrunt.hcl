include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/monitoring"
}

locals {
  cluster_name = "tp4-prd-eks"
}

# El provider Helm se autentica contra EKS via data sources de AWS,
# evitando dependencia de estado Terragrunt del módulo eks.
generate "helm_provider" {
  path      = "helm_provider.auto.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
data "aws_eks_cluster" "this" {
  name = "${local.cluster_name}"
}

data "aws_eks_cluster_auth" "this" {
  name = "${local.cluster_name}"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
EOF
}

inputs = {
  cluster_name           = local.cluster_name
  grafana_admin_password = "changeme-prd"
  namespace              = "monitoring"

  tags = {
    Environment = "prd"
    Project     = "tp4"
  }
}
