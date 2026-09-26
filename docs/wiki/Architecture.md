# Architecture

## Human-readable guide

### Components

- **API:** `src/WTech.API` is a .NET 8 ASP.NET Core minimal API. It currently
  exposes a sample weather forecast endpoint.
- **Container:** `src/WTech.API/Dockerfile` publishes the app in a multi-stage
  .NET SDK/runtime image.
- **Local Kubernetes platform:** Minikube is provisioned with Terraform roots
  under `terraform/local/` and `terraform/infra/`. The platform charts include
  Ministack, Gitea, Gitea Actions, Argo CD, and Prometheus.
- **Local application delivery:** `terraform/cicd/` provisions a Gitea
  repository, and `terraform/wtech-api/` installs the `charts/development`
  chart from Gitea.
- **Cloud infrastructure:** `terraform/aws/` is a separate AWS/EKS direction.
  It is not part of `run.sh`'s local bootstrap.

### Deployment modes and maturity

The repository supports a local Minikube-oriented development setup and
contains Terraform for AWS EKS. They are separate paths: local setup does not
need AWS credentials, while AWS provisioning requires AWS configuration and
may incur cloud charges.

Do not interpret the presence of a workflow, chart, or Terraform resource as
proof that an end-to-end deployment is ready. The repository's own
`TODO_LOCAL_CICD.md` identifies known gaps, including an application chart with
no API Deployment or Service, no automatically registered Gitea Actions runner,
and placeholder deployment and verification steps.

### Architecture decisions

Review `docs/adr/` before changing architecture. Current accepted decisions
include using ADRs, a repository-wide C# `.editorconfig`, and AWS/EKS as the
cloud target while retaining Minikube for local development.

## AI-parsable reference

```yaml
components:
  api:
    path: src/WTech.API/
    framework: ASP.NET Core
    target_framework: net8.0
    entry_point: src/WTech.API/Program.cs
  container:
    path: src/WTech.API/Dockerfile
  local_platform:
    cluster: Minikube
    terraform_roots:
      - terraform/local/
      - terraform/infra/
      - terraform/cicd/
      - terraform/wtech-api/
    services:
      - Ministack
      - Gitea
      - Gitea Actions
      - Argo CD
      - Prometheus
  cloud_platform:
    provider: AWS
    kubernetes: EKS
    terraform_root: terraform/aws/
deployment_status:
  local_bootstrap: implemented_with_known_gaps
  aws_infrastructure: separate_configuration_with_environment_inputs
  application_chart_api_workload: absent
  gitea_actions_runner_registration: not_automated
  eks_deployment_workflow: placeholder
```

### AI-parsable boundaries

| Boundary | Rule |
| --- | --- |
| Local vs. cloud | Do not make the default local workflow depend on AWS resources. |
| Credentials | Never commit real credentials, generated secrets, or kubeconfig files. |
| Terraform | Keep each root's state and inputs scoped to its working directory. |
| Kubernetes | Check `docs/adr/` before introducing significant deployment decisions. |
