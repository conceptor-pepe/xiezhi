# Speclawd 0.1.0-alpha.1

Speclawd `0.1.0-alpha.1` is the first public alpha release.

Speclawd is a gate-driven engineering framework for AI-assisted software development. This alpha is not about completeness. It is about shipping a coherent, installable, reviewable prototype that demonstrates the product direction.

## Highlights

- Installable profiles:
  - `minimal`
  - `go-service`
  - `backend-brownfield`
- Repository initialization with optional tool selection
- Repository-local adapters for Cursor, GitHub Copilot, Claude, and Krio
- Global-install adapter prototype for Codex
- Workflow scripts for:
  - change creation
  - verify
  - archive pre-check
  - PR gate checks
- Repository self-check and release preflight
- Example repository snapshot

## Included In This Alpha

- workflow templates
- core rules
- profiles
- adapters
- scripts
- install flow
- example snapshot
- release and launch documentation

## Not Included Yet

- production-grade adapter coverage for every tool
- polished website or docs portal
- multiple full example applications
- a stable 1.0 installation surface

## Try It

```bash
./install/init.sh --target /path/to/repo --profile minimal --tool none
./install/init.sh --target /path/to/repo --profile go-service --tool cursor
./install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
./install/init.sh --target /path/to/repo --profile backend-brownfield
```

## Notes

This alpha is meant to validate:

- the installation model
- the profile structure
- the workflow artifact model
- the adapter direction

Feedback should focus on install flow, profile boundaries, and whether the workflow is understandable in a fresh repository.
