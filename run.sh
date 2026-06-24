#!/bin/bash

# Run docker compose up for the web API
echo "Starting web API service..."
docker compose up -d

echo "Web API service started successfully."
echo "To check status, run: docker ps"
echo "To view logs, run: docker logs web-api-local"

# Show instructions for applying Kubernetes resources
echo ""
echo "Kubernetes deployment and autoscaling resources have been created in the kubernetes/ directory."
echo "To apply these resources to your Kubernetes cluster:"
echo "1. Make sure you have kubectl installed"
echo "2. Connect to your Kubernetes cluster (minikube, kind, etc.)"
echo "3. Apply the following manifests:"
echo "   kubectl apply -f kubernetes/webapi-deployment.yaml"
echo "   kubectl apply -f kubernetes/webapi-hpa.yaml"
echo "   kubectl apply -f kubernetes/webapi-ingress.yaml"
echo ""
echo "You can verify the deployment with:"
echo "   kubectl get pods -l app=webapi"
echo "   kubectl get hpa"