variable "gitea_admin_password" {
  description = "Admin password for Gitea"
  type        = string
}

variable "gitea_admin_username" {
  description = "Admin username for Gitea"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}
