variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the cluster and node group"
  type        = list(string)
}

variable "node_count" {
  description = "The number of nodes in the node group"
  type        = number
}