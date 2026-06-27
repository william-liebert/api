terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.6.0"
    }
  }
}

provider "kubernetes" {
  config_path = vars.kubeconfig_path
}

provider "helm" {
  kubernetes = {
    config_path = vars.kubeconfig_path
  }
}

provider "gitea" {
  url      = "http://localhost:3000"
  username = vars.gitea_admin_username
  password = vars.gitea_admin_password
}
