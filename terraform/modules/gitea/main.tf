
resource "gitea_repository" "wtech-api" {
  username = vars.gitea_admin_username
  name     = "wtech-api"
}