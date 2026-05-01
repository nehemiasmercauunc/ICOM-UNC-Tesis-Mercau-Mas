include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  name = "tp3-dev-vpc"
  cidr = "10.10.0.0/16"
  # EKS exige subredes en al menos 2 AZs
  azs = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.10.1.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.2.0/24", "10.10.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "tp3"
  }
}
