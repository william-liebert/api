variable "argocd_server_port" {
  description = "Port number for Argo CD server"
  type        = number
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}