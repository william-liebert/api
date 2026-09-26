# Copilot instructions

## Keep the wiki in sync

- Whenever a change adds, edits, or removes application code, tests, scripts,
  workflows, Terraform, Helm charts, Kubernetes manifests, or configuration,
  update the relevant `docs/wiki/` page(s) in the same change.
- Keep documented behavior, commands, inputs, outputs, deployment status,
  operational risks, and source links accurate to the implementation.
- Update `docs/wiki/Home.md` when the page index, project structure, or
  authoritative source map changes.
- If the change spans multiple topics, update every affected wiki page.
- Do not leave a source change for a later documentation-only follow-up.

## Repository decisions

- Review relevant records under `docs/adr/` before substantial technical
  changes. Add an ADR when a meaningful decision is not already documented.
- Treat repository files and accepted ADRs as authoritative when sources
  conflict; correct the wiki as part of the change.
