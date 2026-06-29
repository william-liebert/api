output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority" {
  description = "Certificate authority of the EKS cluster"
  value       = module.eks_cluster.cluster_certificate_authority
}

output "node_group_name" {
  description = "Name of the EKS node group"
  value       = module.eks_cluster.node_group_name
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL of the EKS cluster"
  value       = module.eks_cluster.cluster_oidc_issuer
}