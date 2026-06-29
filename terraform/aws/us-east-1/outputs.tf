output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "Certificate authority of the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority
}

output "node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.main.node_group_name
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL of the EKS cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}