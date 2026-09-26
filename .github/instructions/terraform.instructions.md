---
applyTo: "terraform/**/*.tf"
---

# Terraform guidance

- Treat each directory under `terraform/` that defines a configuration as an independent working root. Run Terraform from the intended root; never initialize or plan from the top-level `terraform/` directory. `terraform/aws/us-east-1/` is composed by the `terraform/aws/` root.
- Before changing a root, inspect its variables, provider requirements, modules, and any state/backend configuration. Do not assume roots share state, inputs, providers, or deployment targets.
- Keep inputs typed and described. Mark sensitive values as sensitive, pass credentials through local untracked variable files or supported environment variables, and never commit secrets or state files.
- Preserve provider version constraints and update the relevant root's dependency lock file when provider selections change. Do not commit generated `.terraform/` working directories.
- Format with `terraform fmt -recursive`. After initializing the changed root, validate it with `terraform -chdir=<root> validate`; run a plan only with the appropriate environment and credentials available.
- Review plan output before provisioning. Do not run `apply` or `destroy` unless explicitly requested; AWS resources can incur charges.
- Review relevant records in `docs/adr/` before substantial infrastructure decisions, and update the relevant `docs/wiki/` pages in the same change when Terraform behavior, inputs, commands, or operational risks change.
