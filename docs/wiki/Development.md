# Development

## Human-readable guide

### Prerequisites

For API-only work, install the .NET 8 SDK and Git. The full local environment
also requires Docker, Minikube, kubectl, and Terraform.

### Build and run the API

From the repository root:

```bash
dotnet restore
dotnet build
dotnet run --project src/WTech.API
```

Run the app with the Development environment to use the Swagger UI.

### Tests and validation

There are currently no test projects in the repository. `dotnet test` is the
standard command, but currently has no project tests to execute. The repository
documents these useful checks:

```bash
dotnet build
dotnet test
terraform fmt -check -recursive
```

Run Terraform commands within the intended root, for example:

```bash
terraform -chdir=terraform/local init
terraform -chdir=terraform/local validate
terraform -chdir=terraform/local plan
```

Do not apply cloud or local infrastructure just to validate an API-only change.

### C# conventions

The root `.editorconfig` defines formatting, naming, and analyzer defaults.
ADR 0002 documents the repository-wide C# style decision. For substantial
technical decisions, consult `docs/adr/` and add an ADR when no existing record
covers the decision.

## AI-parsable reference

```yaml
prerequisites:
  api_only:
    - .NET 8 SDK
    - Git
  full_local_environment:
    - Docker
    - Minikube
    - kubectl
    - Terraform
commands:
  restore: dotnet restore
  build: dotnet build
  run: dotnet run --project src/WTech.API
  test: dotnet test
  terraform_format_check: terraform fmt -check -recursive
test_status:
  test_projects: 0
style:
  config: .editorconfig
  decision_record: docs/adr/0002-adopt-csharp-editorconfig.md
adr_policy:
  directory: docs/adr/
  review_before_substantial_changes: true
```
