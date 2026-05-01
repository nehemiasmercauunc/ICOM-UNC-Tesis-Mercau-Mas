variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes minor para EKS; conviene alinear con el calendario de soporte estandar en la doc de AWS."
  type        = string
  default     = "1.35"
}

variable "vpc_id" {
  description = "VPC identifier where EKS is deployed."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet identifiers for EKS."
  type        = list(string)
}

variable "node_group_name" {
  description = "Managed node group name."
  type        = string
  default     = "default"
}

variable "node_instance_types" {
  description = "Instance types for managed node group."
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_size" {
  description = "Desired nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_disk_size" {
  description = "Root volume size (GiB) per node; mínimo razonable para AMI EKS."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
