# Release Notes: 0.1.0-alpha.1

Speclawd `0.1.0-alpha.1` is the first public alpha release.

This release introduces Speclawd as a gate-driven engineering framework for AI-assisted software development. The goal of this alpha is not completeness. The goal is to ship a coherent, installable, reviewable prototype that demonstrates the product direction.

## Highlights

- Added installable profiles:
  - `minimal`
  - `go-service`
  - `backend-brownfield`
- Added repository initialization with optional tool selection
- Added repository-local adapters for Cursor, GitHub Copilot, Claude, and Krio
- Added a global-install adapter prototype for Codex
- Added workflow scripts for:
  - change creation
  - verify
  - archive pre-check
  - PR gate checks
- Added repository self-check and release preflight scripts
- Added example repository snapshot

## Included In This Alpha

- workflow templates
- core rules
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

## Recommended Next Step

Try one of the following:

```bash
./install/init.sh --target /path/to/repo --profile minimal --tool none
./install/init.sh --target /path/to/repo --profile go-service --tool cursor
./install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
./install/init.sh --target /path/to/repo --profile backend-brownfield
```
