# ADR 0001: Use Architecture Decision Records

- Status: Accepted
- Date: 2026-09-26

## Context

The repository contains application code, infrastructure code, and multiple automation workflows. Important technical decisions have been made in pull requests and chat context, but that context is hard to discover later. Contributors and Copilot agents need a durable, repository-local source of truth for significant decisions and their rationale.

## Decision

Adopt Architecture Decision Records (ADRs) in `docs/adr/` as the standard format for documenting significant technical and process decisions in this repository.

When work introduces a meaningful architectural or implementation-direction decision, contributors and Copilot agents should:

1. Review existing ADRs for relevant prior decisions before proposing or implementing changes.
2. Create a new ADR when no existing ADR captures the decision being made.
3. Reference relevant ADRs in work item context where appropriate.

## Consequences

- Decisions and rationale become easier to discover and reuse.
- Future work can align with established decisions more consistently.
- There is a small ongoing documentation cost to keep ADRs current.
