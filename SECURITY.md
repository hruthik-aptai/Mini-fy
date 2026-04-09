# Security Policy

Mini-fy is a public template repository for OpenClaw workspaces. Because of that, the biggest security rule is simple:

**Do not use this public repo as a place to store secrets or private assistant state.**

## Never Commit

- API keys
- OAuth tokens
- passwords
- local SSH details that should remain private
- `~/.openclaw/openclaw.json`
- auth profiles
- credentials
- session transcripts
- personal memory logs

## Safe Usage Pattern

The recommended pattern is:

1. use this repo as a public baseline
2. keep a private fork or private workspace for real memory and local secrets
3. sync portable improvements back to the public repo only after removing sensitive details

## If You Find A Security Issue

Please do not open a public issue that contains:

- secrets
- reproducible attack details against a live deployment
- personal workspace contents

Instead, report the issue privately to the maintainer and include:

- what is affected
- how it can be reproduced safely
- what the impact is
- any suggested mitigation

## Scope Note

Mini-fy is documentation and workspace scaffolding. Many real security boundaries are enforced by OpenClaw itself, your provider configuration, your sandbox settings, and your machine environment. Review those layers as part of any serious deployment.
