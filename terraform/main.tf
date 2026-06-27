provider "kubernetes" {
  config_path = "../kubeconfig.minikube"
}

provider "helm" {
  kubernetes = {
    config_path = "../kubeconfig.minikube"
  }
}

module "argocd" {
  source = "./modules/argocd"
}

module "gitea" {
  source = "./modules/gitea"
}

module "prometheus" {
  source = "./modules/prometheus"
}