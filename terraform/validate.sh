#!/bin/bash

# Validate Terraform configuration for Argo CD deployment
echo "Validating Terraform configuration..."

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed"
    exit 1
fi

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo "Error: Helm is not installed"
    exit 1
fi

# Validate Terraform configuration
terraform validate

echo "Terraform configuration is valid!"