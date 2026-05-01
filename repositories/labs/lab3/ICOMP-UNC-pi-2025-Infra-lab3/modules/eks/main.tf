module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access = true

  # Quien aplica Terraform queda como admin del clúster (access entry); sin esto kubectl falla aunque get-token funcione.
  enable_cluster_creator_admin_permissions = true

  # Costos: el módulo por defecto habilita logs (api/audit/authenticator) y cifrado de secrets con KMS.
  cluster_enabled_log_types   = []
  create_cloudwatch_log_group = false
  cluster_encryption_config   = {}

  eks_managed_node_groups = {
    (var.node_group_name) = {
      instance_types = var.node_instance_types
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
    }
  }

  tags = var.tags
}
