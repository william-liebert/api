# AWS EKS Module

# This module creates an EKS cluster in the us-east-1 region
module "eks_cluster" {
  source = "./us-east-1"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = var.subnet_ids
  node_count         = var.node_count
}