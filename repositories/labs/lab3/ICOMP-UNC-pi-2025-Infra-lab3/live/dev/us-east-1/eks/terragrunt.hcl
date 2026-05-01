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
  cluster_name    = "tp3-dev-eks"
  cluster_version = "1.35"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  node_group_name     = "default"
  node_instance_types = ["t3.small"]
  node_desired_size   = 1
  node_min_size       = 1
  node_max_size       = 1
  node_disk_size      = 20

  tags = {
    Environment = "dev"
    Project     = "tp3"
  }
}
