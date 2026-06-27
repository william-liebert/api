variable "argocd_helm_chart_version" {
  description = "Version of Argo CD Helm chart to deploy"
  type        = string
}

variable "gitea_helm_chart_version" {
  description = "Version of Gitea Helm chart to deploy"
  type        = string
}

variable "gitea_admin_password" {
  description = "Admin password for Gitea"
  type        = string
}

variable "gitea_admin_username" {
  description = "Admin username for Gitea"
  type        = string
}

variable "prometheus_helm_chart_version" {
  description = "Version of Prometheus Helm chart to deploy"
  type        = string
}