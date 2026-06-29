resource "gitea_repository" "wtech-api" {
  username = var.gitea_admin_username
  name     = "wtech-api"
}
