output "prometheus_server_url" {
  description = "URL to access Prometheus server"
  value       = "http://127.0.0.1:${var.prometheus_server_port}"
}

output "prometheus_server_service_name" {
  description = "Name of the Prometheus server service"
  value       = "prometheus"
}
