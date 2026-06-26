# Helm Charts

This directory contains Helm charts for Kubernetes services.

## Available Charts

### gitea
- Gitea Helm chart with NodePort configuration
- HTTP port: 3000 (NodePort: 30000)
- SSH port: 22 (NodePort: 30022)

### grafana-nodeport
- Grafana service exposed via NodePort
- Port: 3000 (NodePort: 30001)

### prometheus-nodeport
- Prometheus service exposed via NodePort
- Port: 9090 (NodePort: 30002)
