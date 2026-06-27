variable "argocd_helm_chart_version" {
  description = "Version of Argo CD Helm chart to deploy"
  type        = string
}

variable "gitea_helm_chart_version" {
  description = "Version of Gitea Helm chart to deploy"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "prometheus_helm_chart_version" {
  description = "Version of Prometheus Helm chart to deploy"
  type        = string
}