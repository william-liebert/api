# AWS EKS Module (us-east-1)

This module creates a pet EKS cluster with associated resources in the us-east-1 region.

## Modules

This module uses the following grouped sub-modules:

- `eks`: Creates EKS cluster and node group resources with ALL values inlined

## Usage

```hcl
module "eks" {
  source = "./us-east-1"
}
```

## Requirements

- Terraform 1.0+
- AWS provider 4.0+

## Variables

This module has no variables as all values are inlined for pet resources.

## Outputs

| Name                      | Description                          |
|---------------------------|--------------------------------------|
| cluster_name              | Name of the EKS cluster              |
| cluster_endpoint          | Endpoint of the EKS cluster          |
| cluster_certificate_authority | Certificate authority of the EKS cluster |
| node_group_name           | Name of the EKS node group           |
| cluster_oidc_issuer       | OIDC issuer URL of the EKS cluster   |
| eks_cluster_role_arn      | ARN of the EKS cluster IAM role      |
| eks_nodes_role_arn        | ARN of the EKS nodes IAM role        |