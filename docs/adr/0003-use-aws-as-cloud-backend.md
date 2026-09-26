# ADR 0003: Use AWS as the cloud backend

- Status: Accepted
- Date: 2026-09-26

## Context

The API needs a cloud platform for hosted deployments, while the repository also supports local development with Minikube. The Terraform configuration under `terraform/aws/` provisions an Amazon EKS cluster and its IAM roles, establishing AWS as the cloud deployment target.

## Decision

Use Amazon Web Services (AWS) as the cloud backend for the API. Use Amazon Elastic Kubernetes Service (EKS) as the managed Kubernetes platform, provisioned with Terraform. This decision concerns the cloud provider and hosting platform; it does not select a Terraform remote-state backend.

Keep the existing local Minikube workflow available for development.

## Consequences

- Cloud infrastructure and deployment configuration will use AWS services and AWS-specific Terraform resources.
- EKS provides the managed Kubernetes control plane for cloud deployments.
- AWS-specific configuration reduces portability to other cloud providers; any future move would require replacing or adapting infrastructure.
- AWS infrastructure incurs provider charges and requires AWS account, access-control, and regional configuration.
- Local development remains available without requiring AWS infrastructure.
