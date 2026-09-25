---
applyTo: "charts/**/*,**/*.yaml,**/*.yml"
---

# Kubernetes guidance

- Keep manifests declarative and consistent with the repository's existing deployment style.
- Preserve labels, selectors, ports, probes, and naming that already exist in the chart or manifest set.
- Prefer configuration-driven values instead of burying environment assumptions in manifests.
- Avoid embedding secrets or credentials directly in YAML files.
- Keep resource definitions explicit and readable.
- Validate with `kubectl apply --dry-run=client` or chart tooling if available.
