# ADR 0005: Use `pull_request_target` for Dependabot approval

- Status: Accepted
- Date: 2026-09-26

## Context

The Dependabot automation needs write permissions to approve eligible dependency
updates and enable auto-merge. A `pull_request` workflow may receive a
read-only token for pull requests created by Dependabot.

## Decision

Run the workflow on `pull_request_target`, restrict its job to Dependabot pull
requests in this repository, and grant only the contents and pull-request write
permissions it needs. The workflow must not check out or execute pull-request
code. It approves and enables squash auto-merge only for patch and minor
updates. Repository Actions settings must allow workflows to create and approve
pull requests.

## Consequences

- Eligible Dependabot updates can be approved and queued for auto-merge using
  the repository token.
- The workflow operates in a privileged context, so the Dependabot author
  condition and prohibition on running pull-request code are security
  requirements.
- Repository administrators must enable the Actions setting that allows
  workflows to create and approve pull requests.
