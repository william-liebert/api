variable "argocd_helm_chart_version" {
  description = "Version of Argo CD Helm chart to deploy"
  type        = string
  default     = "10.0.0"
}

variable "gitea_helm_chart_version" {
  description = "Version of Gitea Helm chart to deploy"
  type        = string
  default     = "7.0.1"
}

variable "prometheus_helm_chart_version" {
  description = "Version of Prometheus Helm chart to deploy"
  type        = string
  default     = "15.0.1"
}