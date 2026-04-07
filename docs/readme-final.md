# Speclawd

Gate-driven engineering for AI-assisted software development.

Speclawd is a repository-native engineering framework that helps teams bring discipline to AI-assisted development. It combines change artifacts, system specs, verification gates, review structure, delivery summaries, and archive steps into one operating model.

## Why Speclawd

AI coding tools are fast, but speed without gates creates drift:

- requirements stay trapped in chat history
- code lands before contracts are aligned
- reviews miss intent because change context is fragmented
- delivery summaries vary by author and tool
- long-term system truth falls behind shipped behavior

Speclawd fixes this with a gate-driven repository workflow:

- `changes/` for the current change
- `specs/` for long-term truth
- required gates before implementation, delivery, and archive
- explicit verify, test-review, and commit-summary artifacts
- adapters for multiple AI tools without changing workflow meaning

## Core Lifecycle

1. New Change
2. Spec Brief
3. Implement
4. Verify
5. Commit Summary
6. Archive

## Install

Initialize a repository with a profile:

```bash
./install/init.sh --target /path/to/repo --profile backend-brownfield
```

Examples:

```bash
./install/init.sh --target /path/to/repo --profile minimal --tool none
./install/init.sh --target /path/to/repo --profile go-service --tool cursor
./install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
```

## Profiles

- `minimal`: lowest-friction adoption
- `go-service`: practical default for Go service repositories
- `backend-brownfield`: fullest repository-local setup

## Standard Change Artifacts

- `change.md`
- `spec-delta.md`
- `design.md`
- `tasks.md`
- `review.md`
- `audit.md`
- `test-review.md`
- `commit-summary.md`
- `archive.md`
- `error-memory.md`

## What This Alpha Includes

- installable profiles
- core workflow rules
- templates for change-driven work
- Cursor, GitHub Copilot, Claude, and Krio repository-local adapters
- Codex global-install adapter prototype
- shell scripts for workflow execution and validation
- a repository self-check and release preflight flow
- an example repository snapshot

## Who It Is For

Speclawd is built for:

- brownfield systems
- engineering teams using AI coding tools
- repositories that need auditable change history
- teams that want more than prompts and conventions

## Documentation

- `docs/profiles.md`
- `docs/adapters.md`
- `docs/quick-start.md`
- `docs/release.md`
- `docs/alpha-release.md`

## Status

Speclawd `0.1.0-alpha.1` is the first public alpha repository prototype. It is intended to prove the installation model, workflow structure, and adapter direction before broader stabilization.
