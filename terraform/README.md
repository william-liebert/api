# Argo CD Deployment Module

This Terraform module deploys Argo CD to a local Minikube cluster.

## Requirements

- Terraform 1.0+
- Helm provider for Terraform
- Access to a running Minikube cluster with kubeconfig at `../kubeconfig.minikube`

## Usage

```hcl
module "argocd_deployment" {
  source = "./terraform"

  argocd_version     = "7.0.1"
  argocd_server_port = 30080
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| argocd_version | Version of Argo CD to deploy | string | "7.0.1" | no |
| argocd_server_port | Port number for Argo CD server | number | 30080 | no |
| kubeconfig_path | Path to kubeconfig file | string | "../kubeconfig.minikube" | no |

## Outputs

| Name | Description |
|------|-------------|
| argocd_server_url | URL to access Argo CD server |
| argocd_server_service_name | Name of the Argo CD server service |
| argocd_namespace | Namespace where Argo CD is deployed |