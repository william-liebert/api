variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "chart_repository_url" {
  description = "URL of the local Gitea-hosted Helm chart repository"
  type        = string
  default     = "http://127.0.0.1:33000/git/wtech-api/charts/development"
}
