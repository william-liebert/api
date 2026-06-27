variable "argocd_version" {
  description = "Version of Argo CD to deploy"
  type        = string
  default     = "7.0.1"
}

variable "argocd_server_port" {
  description = "Port number for Argo CD server"
  type        = number
  default     = 30080
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "../kubeconfig.minikube"
}