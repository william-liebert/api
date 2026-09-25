# TODO_LOCAL_CICD.md

## Local CI/CD Workflow Implementation Checklist

This checklist describes the repository's local path: Docker-backed Minikube, the
Ministack Helm release, and the four Terraform roots applied by `run.sh`.
The `terraform/aws` tree is a separate real-AWS EKS configuration and is not
used by the local bootstrap script.

### 1. Prerequisites and local access
- [ ] Install Docker and start the Docker daemon
- [ ] Install and authenticate the required CLIs: `kubectl`, `helm`, `terraform`,
  `minikube`, and `git`
- [ ] Confirm the local user can access the Docker-backed Minikube driver
- [ ] Confirm local ports are available: `30001` (API), `30002` (ArgoCD),
  `30003` (Grafana), `30005` (Ministack), and `33000` (Gitea)

### 2. Start the local cluster and Ministack
- [x] Start Minikube with the Docker driver (`run.sh`)
- [x] Point the Docker client at Minikube's Docker daemon
  (`eval $(minikube docker-env)`)
- [x] Apply `terraform/local`, which installs the `ministack` Helm chart
- [ ] Verify the Ministack service is ready on NodePort `30005`
- [ ] Do not expect this step to create an EKS cluster: the local Terraform
  root contains only the Ministack release; EKS is defined separately under
  `terraform/aws`

### 3. Install platform services with Helm
- [x] Apply `terraform/infra` after the local cluster exists
- [x] Install ArgoCD (`argo-cd` chart)
- [x] Install Gitea (`gitea` chart) with the configured `developer` account,
  local repository creation enabled, and NodePort `33000`
- [x] Install the Gitea Actions chart after Gitea
- [x] Install Prometheus; the configured NodePort is `30090`
- [ ] Verify Gitea is reachable at `http://127.0.0.1:33000`
- [ ] Verify ArgoCD is reachable at `http://127.0.0.1:30002`
- [ ] Verify Grafana is reachable at `http://127.0.0.1:30003`
- [ ] Verify the ArgoCD initial admin password retrieved by `run.sh` is usable

### 4. Create the Gitea repository and application chart
- [x] Apply `terraform/cicd` after `terraform/infra`; its dependency graph
  creates the Gitea repository before the ArgoCD module
- [x] Create the `developer/wtech-api` repository through the Gitea provider
- [x] Apply `terraform/wtech-api` after the repository exists
- [x] Register the `charts/development` chart as the `development` Helm release
  using the Gitea-hosted chart URL
- [ ] Confirm the chart endpoint is reachable from the Helm provider and that
  the `development` release becomes healthy

### 5. Configure Gitea Actions workflows
- [x] Keep the workflow definitions under `.gitea/workflows`
- [x] Configure the build workflow to build and push a multi-architecture
  Docker image on pushes to `main`
- [x] Configure the test workflow to restore, build, and test the .NET solution
  on pushes to `main`
- [x] Deploy the Gitea Actions chart after Gitea
- [ ] Register and start a Gitea Actions runner; the repository provisions the
  chart and URL values but does not register a runner automatically
- [ ] Add the required repository secrets before relying on workflows:
  `DOCKERHUB_USERNAME`, `DOCKERHUB_PASSWORD`, `AWS_ACCESS_KEY_ID`, and
  `AWS_SECRET_ACCESS_KEY`

### 6. Configure the deployment pipeline
- [x] Keep the deployment workflow in `.gitea/workflows/deploy.yml`
- [x] Build and push the image and configure Helm/AWS credential actions in the
  workflow definition
- [ ] Replace the commented `helm upgrade --install` example with a real
  deployment command and valid cluster context
- [ ] Replace the placeholder verification step with checks for rollout status
  and service health
- [ ] Decide whether local deployment should target Minikube or the separate
  AWS EKS configuration; the current workflow is labelled EKS and is not wired
  to the local cluster

### 7. Bootstrap and integration test
- [x] Run `./run.sh` in this order: reset/start Minikube, apply `local`,
  `infra`, `cicd`, and `wtech-api`
- [x] Configure the `minikube-git` remote and push all local branches to Gitea
- [ ] Confirm the pushed repository is visible in Gitea
- [ ] Push `main` (or update it) to trigger the build and test workflows
- [ ] Monitor the workflow runs and runner logs in Gitea
- [ ] Confirm the image tag produced for the commit is available to the
  deployment target

### 8. Validate the deployed application
- [ ] Verify the API workload is running and ready in the target cluster
- [ ] Verify the API service is reachable on the configured NodePort `30001`;
  the checked-in `charts/development` chart currently defines ArgoCD and
  Grafana services but no API service template
- [ ] Exercise the API endpoint and confirm a successful response
- [ ] Verify the end-to-end path from a `main` push through CI, image publishing,
  Helm deployment, rollout verification, and application response
