variable "gitea_admin_password" {
  description = "Admin password for Gitea"
  type        = string
  sensitive   = true
}

variable "gitea_admin_username" {
  description = "Admin username for Gitea"
  type        = string
}