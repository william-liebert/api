output "argocd_server_url" {
  description = "URL to access Argo CD server"
  value       = "http://127.0.0.1:${var.argocd_server_port}"
}

output "argocd_server_service_name" {
  description = "Name of the Argo CD server service"
  value       = "argocd-server"
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = "argocd"
}