output "gitea_server_url" {
  description = "URL to access Gitea server"
  value       = "http://127.0.0.1:${var.gitea_server_port}"
}

output "gitea_server_service_name" {
  description = "Name of the Gitea server service"
  value       = "gitea"
}
