# Local CI/CD implementation guideline

This document is the high-level implementation guide for agents extending the
repository's local CI/CD environment. It describes the desired outcome,
implementation boundaries, dependency order, and completion criteria. It is
not a list of unchecked chores and should not be interpreted as permission to
make unrelated application or cloud-infrastructure changes.

## Desired outcome

Provide one reproducible local command that:

1. Creates a disposable Kubernetes environment with Minikube and Docker.
2. Emulates the AWS-facing services needed by the application workflow locally
   without requiring an AWS account.
3. Installs the platform services used by the repository: Gitea, Gitea
   Actions, Argo CD, monitoring, and the application.
4. Runs CI for the repository and publishes an image to a local registry.
5. Deploys the image to Kubernetes with Helm or Argo CD.
6. Verifies the deployment and exposes useful local endpoints.

The implementation should make the local path behave like a small,
self-contained delivery platform while keeping the option to deploy the same
application chart to real AWS EKS later.

## Current baseline

- `src/WTech.API` is the .NET 8 API and
  `src/WTech.API/Dockerfile` builds its image.
- Minikube is the intended local Kubernetes cluster and Docker is the intended
  container runtime.
- `terraform/local` installs the local `ministack` chart.
- `terraform/infra` installs Argo CD, Gitea, Gitea Actions, and Prometheus.
- `terraform/cicd` creates the `developer/wtech-api` repository in Gitea.
- `terraform/wtech-api` installs the `charts/development` Helm release from
  Gitea.
- `.gitea/workflows` contains test, image-build, and deployment workflow
  definitions.
- `terraform/aws` is a separate real-AWS/EKS direction. It is not part of the
  local bootstrap and currently contains environment-specific placeholders.

Agents must inspect the current Terraform modules, chart templates, workflow
files, and `run.sh` before changing them. Existing behavior is a baseline to
understand, not proof that the bootstrap is correct.

## Target architecture

```text
Developer push
      |
      v
Local Gitea repository
      |
      v
Gitea Actions runner ----> local OCI/Docker registry
      |                              |
      |                              v
      +------------------------> Helm chart / image
                                     |
                           Argo CD or Helm deployment
                                     |
                                     v
                              Minikube application
```

The local AWS boundary should be explicit. If AWS APIs are needed, use a
documented local emulator such as LocalStack and configure the application and
workflows to use endpoint overrides. Do not silently replace AWS behavior with
hard-coded mocks, and do not require real AWS credentials for the default
local path.

## Agent implementation phases

Agents should implement the phases in order. Each phase must leave the
repository buildable and must document configuration assumptions in the
relevant Terraform variables, Helm values, or workflow files.

### Phase 1: Establish the local foundation

- Make Minikube startup, Docker image access, kubeconfig selection, and
  teardown deterministic and repeatable.
- Make Terraform roots safe to apply repeatedly and explicit about their
  dependencies.
- Keep all local ports, namespaces, credentials, and image locations
  configuration-driven.
- Ensure failures are surfaced with actionable errors; do not continue after a
  failed prerequisite.

### Phase 2: Add local AWS service emulation

- Identify the AWS services actually used by the application and workflows
  (for example ECR, S3, SQS, or IAM) before adding emulator services.
- Add only the required emulator components and persist data only when the
  local workflow needs persistence.
- Provide endpoint, region, and credential configuration through local
  variables or Kubernetes secrets. Never commit real credentials.
- Add health checks and readiness waits so dependent Terraform and workflows
  do not race service startup.
- Document which emulator behaviors are supported and which still require
  real AWS validation.

### Phase 3: Complete the application chart

- Add the API Deployment, Service, labels, probes, resources, and image
  settings to `charts/development`.
- Keep Argo CD, Grafana, and API service naming/selectors consistent with the
  existing chart and values.
- Make the image repository, tag, pull policy, namespace, and service port
  configurable.
- Validate templates with Helm tooling and apply them with a client-side
  Kubernetes dry run where possible.

### Phase 4: Complete local CI

- Install and configure a compatible Gitea Actions runner as part of the local
  setup, or provide a documented one-command registration path.
- Make the test workflow restore, build, and test the solution from a clean
  checkout.
- Build the API image and publish it to a local registry or emulator by
  immutable commit SHA.
- Ensure the Kubernetes cluster can pull the resulting image without Docker
  Hub or real AWS access.
- Keep secrets in the local secret mechanism or environment setup, not in
  workflow YAML.

### Phase 5: Complete local CD

- Choose one primary local deployment mechanism: Argo CD or Helm. If both are
  retained, define which is authoritative and why.
- Deploy the exact image tag produced by CI.
- Replace placeholder deployment commands with a real
  `helm upgrade --install` or Argo CD sync path.
- Wait for rollout completion and fail on unhealthy workloads.
- Verify the API endpoint and at least one representative dependency path.

### Phase 6: Preserve the AWS path

- Keep local values, emulator endpoints, and credentials separate from AWS
  values.
- Do not make `terraform/aws` depend on Minikube-only resources.
- Replace placeholder AWS identifiers only when the task explicitly targets
  real AWS provisioning and the required variables are available.
- Reuse the application chart between Minikube and EKS through values rather
  than environment-specific templates.

## Required bootstrap order

The default local command should follow this dependency order:

```text
Docker
  -> Minikube
  -> local registry / AWS emulator
  -> platform services
  -> Gitea repository and runner
  -> CI image
  -> application chart
  -> deployment
  -> health verification
```

The current Terraform roots map approximately as follows:

```text
terraform/local
        |
        v
terraform/infra
        |
        v
terraform/cicd
        |
        v
terraform/wtech-api
```

Agents may reorganize these roots only when the dependency graph becomes
clearer and the existing entry point remains understandable. A bootstrap must
not read a generated secret before installing the service that creates it,
and it must not configure a chart URL or registry endpoint that is unreachable
from the provider or cluster.

## Definition of done

An implementation is complete only when all of the following are true:

- A clean machine with documented prerequisites can run the local bootstrap
  from the repository.
- Re-running the bootstrap is either idempotent or explicitly performs a
  documented reset.
- `terraform fmt -check -recursive` and relevant Terraform validation pass.
- Helm templates render successfully and Kubernetes manifests pass a dry run.
- The CI runner executes the test workflow successfully.
- CI produces an immutable image that the local cluster can pull.
- CD deploys that image and reports rollout failure correctly.
- The API is reachable through the documented local endpoint.
- Logs and status commands identify failures without requiring the agent to
  inspect opaque Terraform state manually.
- The documentation names every required tool, port, secret, endpoint, and
  cleanup command.

## Known baseline defects to resolve

The current repository does not yet satisfy the target architecture. Agents
should treat these as implementation risks, not as completed behavior:

- `run.sh` attempts to read the Argo CD password before `terraform/infra`
  installs Argo CD.
- The application chart has no API Deployment or API Service.
- No Gitea Actions runner is registered automatically.
- Workflows publish to Docker Hub and reference AWS secrets instead of using a
  local registry and emulator by default.
- `deploy.yml` contains placeholder Helm deployment and verification steps.
- `terraform/wtech-api` uses an HTTPS Gitea chart URL while the configured
  local Gitea service is HTTP.
- The configured local endpoints include NodePorts for services whose actual
  readiness and reachability have not been verified.

Resolve these defects in dependency order, adding focused validation for each
behavior. Do not hide a defect by weakening checks or allowing a failed
bootstrap to continue.

## Operational boundaries

- Do not commit passwords, tokens, cloud keys, kubeconfigs, or generated state.
- Do not use real AWS resources in the default local workflow.
- Do not change production or real-AWS Terraform as a side effect of local
  emulation work.
- Prefer small, composable Terraform modules and values-driven Helm charts.
- Keep the bootstrap observable: print the phase being executed, the relevant
  endpoint, and the next diagnostic command when a phase fails.
- Update this guide when the architecture or source-of-truth commands change.
