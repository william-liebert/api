# Operations

## Human-readable guide

### Access and service addresses

`run.sh` prints local access information after its Terraform steps complete.
Those printed addresses are the script's configured expectations, not a
guarantee that every service is healthy or reachable. For example, the
development chart's default NodePorts and the script's printed Gitea endpoint
do not fully match. Check active Kubernetes services and the current chart
values before relying on an address.

Use `kubectl get pods,services --all-namespaces` to inspect resources and
`kubectl describe` or `kubectl logs` on a specific resource to diagnose issues.
Confirm the selected kubeconfig context before running commands that can change
cluster resources.

### Troubleshooting

1. Confirm Docker and Minikube are available and the expected cluster is
   selected.
2. Check pod status and events before re-running Terraform.
3. Inspect the Terraform root's provider inputs and plan.
4. Check `TODO_LOCAL_CICD.md` for known bootstrap limitations. In particular,
   the Argo CD secret is read before the infra root is applied, and the app
   chart's Gitea URL currently uses HTTPS while local Gitea is configured for
   HTTP.
5. Do not rerun `./run.sh` as a harmless retry; it starts by deleting Minikube.

### Security and recovery

The bootstrap script emits local service access details, and the Gitea
Terraform root accepts administrator credentials. Keep credentials in local
secret storage and out of the wiki, source control, and logs. Do not publish
kubeconfig contents, Terraform state, or generated secret values.

The local bootstrap deliberately resets Minikube before setup. Back up anything
needed from the cluster first. The repository does not document an independent
non-destructive cleanup/recovery command.

## AI-parsable reference

```yaml
diagnostics:
  list_resources: kubectl get pods,services --all-namespaces
  inspect_resource: kubectl describe
  view_logs: kubectl logs
  before_changes:
    - confirm kubeconfig context
    - inspect Terraform plan
known_operational_risks:
  - run.sh deletes the current Minikube cluster before bootstrapping.
  - run.sh reads the Argo CD initial password before installing terraform/infra.
  - Gitea chart source protocol differs from the local Gitea protocol.
  - Printed endpoints and chart NodePorts are not fully consistent.
secret_handling:
  wiki: never publish credentials or generated secret values
  source_control: never commit credentials, kubeconfigs, or Terraform state
recovery:
  non_destructive_cleanup_documented: false
```
