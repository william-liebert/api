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
      version = "0.7.0"
    }
  }
}
