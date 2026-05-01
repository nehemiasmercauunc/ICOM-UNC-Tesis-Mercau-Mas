include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name    = "tp3-prd-eks"
  cluster_version = "1.35"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  node_group_name     = "default"
  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 2
  node_max_size       = 4

  tags = {
    Environment = "prd"
    Project     = "tp3"
  }
}
