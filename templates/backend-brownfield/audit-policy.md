# Audit Policy

> Repository-level policy for validation, audit tools, and release gating.
> Keep this file project-specific. Speclawd verifies that change artifacts reference it, but does not force a single universal checklist.

## Purpose

- define this repository's audit baseline
- explain which checks are mandatory before delivery
- document allowed waivers and who can approve them

## Required Inputs

- primary languages: `<go / python / typescript / mixed>`
- core modules with stricter checks:
  - `<module-a>`
  - `<module-b>`
- high-risk change types:
  - `<schema migration>`
  - `<payment / quota / auth>`

## Mandatory Validation Gates

| Gate ID | Gate | Trigger | Required Command / Evidence | Pass Rule | Waiver Rule |
|--------|------|---------|-----------------------------|-----------|-------------|
| `AUDIT-GATE-001` | `build` | `any backend code change` | `<go build ./...>` | `must pass or be explicitly blocked` | `<who can waive and when>` |
| `AUDIT-GATE-002` | `go audit` | `any Go file change` | `python3 ~/.cursor/skills/go-audit/scripts/audit.py <modified-go-files>` | `must reach 编码规范审计 ✅ (11/11)` | `normally no waiver; only explicit repository exception` |
| `AUDIT-GATE-003` | `tests / replay / smoke` | `behavioral change, migration, or risky refactor` | `<go test / replay / smoke command>` | `must cover the change-specific minimum regression path` | `<who can waive and when>` |

## Coding Audit Rules

| Rule ID | Scope | Requirement | Severity | Allowed Waiver |
|--------|-------|-------------|----------|----------------|
| `AUDIT-RULE-001` | `all public Go APIs` | `public functions must have Go doc comments` | `high` | `none` |
| `AUDIT-RULE-002` | `function bodies` | `single function should stay within 50 lines unless strongly justified` | `medium` | `explicit review note` |
| `AUDIT-RULE-003` | `service / handler` | `error branches must not fail silently; logs must carry enough context` | `critical` | `none` |
| `AUDIT-RULE-004` | `dto / api / response` | `int64 values exposed to frontend must preserve precision` | `critical` | `none` |
| `AUDIT-RULE-EXTRA-*` | `<project-specific>` | `<extra repository rule>` | `<critical/high/medium>` | `<none / explicit marker>` |

## Evidence Requirements

- required artifact fields:
  - `<commands actually run>`
  - `<result and blocking issue>`
  - `<logs / screenshots / replay ids if applicable>`
- forbidden evidence:
  - `<"looks good">`
  - `<unexecuted commands>`

## Test Review Gate Linkage

- `audit.md` must record whether `test-review.md` is complete
- if test review is `risk` or `fail`, audit conclusion cannot be `ready`

## Project Overrides

- `<service X may skip load tests below threshold Y>`
- `<migration changes require replay evidence>`

## Change Control

- owner: `<team / role>`
- last reviewed: `<YYYY-MM-DD>`
