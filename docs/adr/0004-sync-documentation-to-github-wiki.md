# ADR 0004: Sync documentation to the GitHub Wiki

- Status: Accepted
- Date: 2026-09-26

## Context

The repository needs a maintainable source for pages published in its GitHub Wiki. Editing wiki pages separately from the repository would split documentation across two locations and make changes harder to review.

## Decision

Maintain wiki page files in `docs/wiki/` and use a GitHub Actions workflow to mirror that directory to the repository's GitHub Wiki on pushes to `main`. The workflow also supports manual dispatch. It uses a repository secret named `WIKI_TOKEN` because the default GitHub Actions token does not provide wiki write access.

## Consequences

- Wiki page changes can be reviewed and versioned alongside the repository.
- The repository's Wiki feature must be enabled and initialized, and `WIKI_TOKEN` must be configured with wiki write access.
- The workflow mirrors the source directory, including deletions; edits made directly in the GitHub Wiki are overwritten or removed on the next sync.
