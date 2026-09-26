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
- Check `docs/adr/` for relevant decisions before changing manifests; add/update an ADR when a Kubernetes change introduces a significant new decision.
- Update the relevant `docs/wiki/` pages in the same change whenever charts, manifests, or Kubernetes-related configuration change. Keep documented behavior, values, ports, and operational caveats aligned with the implementation.
