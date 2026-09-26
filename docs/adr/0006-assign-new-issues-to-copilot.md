# ADR 0006: Assign new issues to Copilot

- Status: Accepted
- Date: 2026-09-26

## Context

New issues may describe bugs or other work that can be addressed with a repository
change. Manually triaging each issue before starting a potential fix adds delay.
GitHub's Copilot cloud agent supports issue assignment through its issue API.

## Decision

Use a GitHub Actions workflow triggered when an issue is opened to assign the
Copilot coding agent to the issue. The agent should make a focused fix and open a
pull request when the issue warrants a code change, explain when no code change is
appropriate, and ask for clarification when needed. Authenticate with the
workflow's built-in `GITHUB_TOKEN`, granting only `issues: write`. Select GPT-6
Luna, currently the lowest-priced supported model by per-token pricing.

## Consequences

- Newly opened issues are automatically sent to Copilot for investigation.
- Repository owners must enable Copilot cloud agent. GitHub may change available
  models and their pricing over time.
- Copilot usage may be incurred for every new issue, and its proposed changes
  require human review before merging.
