terraform {
  required_providers {
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.7.0"
    }
  }
}

provider "gitea" {
  base_url = "http://127.0.0.1:3000"
  username = var.gitea_admin_username
  password = var.gitea_admin_password
}
