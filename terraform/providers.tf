provider "kubernetes" {
  config_path = "../kubeconfig.minikube"
}

provider "helm" {
  kubernetes = {
    config_path = "../kubeconfig.minikube"
  }
}
