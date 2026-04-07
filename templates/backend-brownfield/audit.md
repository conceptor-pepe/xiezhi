# Audit: <change-name>

## Scope

- change scope: `<module / feature / package>`
- modified go files:
  - `<path/to/file1.go>`
  - `<path/to/file2.go>`
- non-go verification targets:
  - `<api / migration / config / docs>`

## Policy Sources

- audit policy: `docs/specClawd/policies/audit-policy.md`
- coding standards policy: `docs/specClawd/policies/coding-standards.md`
- test review policy: `docs/specClawd/policies/test-review-policy.md`
- repo-specific overrides used in this change: `<none / path / note>`

## Validation Summary

| Check | Command / Evidence | Result | Notes |
|-------|--------------------|--------|-------|
| build | `<go build ./...>` | `<pass/fail/not-run>` | `<blocking error or none>` |
| lint | `<golangci-lint run ./...>` | `<pass/fail/not-run>` | `<blocking error or none>` |
| test | `<go test ./...>` | `<pass/fail/not-run>` | `<failed package / none>` |
| targeted verification | `<manual test / script / replay>` | `<pass/fail/not-run>` | `<key evidence>` |

- build: `<pass/fail/not-run>`
- lint: `<pass/fail/not-run>`
- test: `<pass/fail/not-run>`

## Go Audit Execution

- primary audit tool / script: `python3 ~/.cursor/skills/go-audit/scripts/audit.py <modified-go-files>`
- baseline source: `~/.cursor/rules/go-audit.mdc` + `~/.cursor/skills/go-audit/SKILL.md`
- project policy source: `docs/specClawd/policies/audit-policy.md`
- scope rationale: `<why these files / why this directory / why this replay>`
- result: `<pass/fail/not-run>`
- summary: `<e.g. 编码规范审计 ✅ (11/11) / failed on rule 6 and rule 11>`

## Audit Rule Checklist

| Rule ID | Source | Requirement | Status | Evidence / Violations | Follow-up |
|---------|--------|-------------|--------|------------------------|-----------|
| `AUDIT-RULE-001` | `go-audit.py` | Public functions must have Go doc comments | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-002` | `go-audit.py` | Function length must stay within 50 lines | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-003` | `go-audit.py` | Function parameter count must stay within 5 | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-004` | `go-audit.py` | Nesting depth must stay within 2 levels | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-005` | `go-audit.py` | Ignored errors must have justification | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-006` | `go-audit.py` | Error branches must log with enough context | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-007` | `go-audit.py` | No `reflect` usage unless explicitly justified | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-008` | `go-audit.py` | Blocking/public call chains must propagate `context.Context` | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-009` | `go-audit.py` | Interfaces must stay minimal | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-010` | `go-audit.py` | int64 JSON fields must preserve frontend precision | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-011` | `go-audit.py` | Critical write paths must emit success logs | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |
| `AUDIT-RULE-EXTRA-*` | `audit-policy.md` | `<project-specific extra rule if needed>` | `<pass/fail/n-a>` | `<comment / file:line>` | `<none / action>` |

## Test Functionality Review Gate

- review source: `test-review.md`
- gate status: `<pass/fail/not-run>`
- intent anchor: `<new feature / bugfix / refactor / config change>`
- key covered cases: `<CASE-001, CASE-002>`
- unresolved test risks: `<none / TEST-RISK-001>`

## Additional Verification

| Check | Result | Evidence | Blocker |
|-------|--------|----------|---------|
| `<migration replay / api smoke / docs sync>` | `<pass/fail/not-run>` | `<command / inspection / log>` | `<none / issue>` |
| `<manual scenario / rollback / idempotency>` | `<pass/fail/not-run>` | `<command / inspection / log>` | `<none / issue>` |

## Blocking Issues

- `<none or blocker with owner>`

## Current Conclusion

- delivery status: `<ready / risk / blocked>`
- audit gate: `<pass/fail>`
- release recommendation: `<safe to continue / fix blockers first>`
- summary: `<high-signal conclusion>`
