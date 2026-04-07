# Review: <change-name>

## Policy Sources

- coding standards policy: `docs/speclawd/policies/coding-standards.md`
- audit policy: `docs/speclawd/policies/audit-policy.md`
- test review policy: `docs/speclawd/policies/test-review-policy.md`
- repo-specific review focus used in this change: `<none / path / note>`

## Findings

### Finding 1

- severity: <critical/high/medium/low>
- finding id: `REV-001`
- related task ids: `TASK-001`
- related requirement ids: `REQ-001`
- related risk ids: `RISK-001`
- location: <file:line>
- issue: <description>
- resolution: <fix or rationale>

## 产品经理审计记录

> 对应旧标题：`Product Review`

- requirement coverage: `<implemented / partial / missing>`
- scope fit: `<matches change.md scope or not>`
- user-visible behavior: `<expected outcome>`
- gaps: `<missing or none>`

## 架构师审计记录

> 对应旧标题：`Architecture Review`

### 架构 Gate 结论

- module boundary: `<reasonable / needs change>`
- coupling decision: `<acceptable risk / issue>`
- data consistency: `<transaction / idempotency / rollback conclusion>`
- observability: `<logs / metrics / alerts>`
- release architecture verdict: `<accept / accept-with-risk / reject>`

### 架构检查矩阵

| Gate ID | Checkpoint | What Was Reviewed | Result | Evidence | Related IDs | Follow-up |
|---------|------------|-------------------|--------|----------|-------------|-----------|
| `ARCH-001` | Module boundary depth | `<whether complexity stays behind a stable boundary>` | `<pass/risk/fail>` | `<file / call chain / design note>` | `<DES-*/RISK-*>` | `<none / action>` |
| `ARCH-002` | Call-chain correctness | `<handler -> service -> repo -> integration signatures and semantics>` | `<pass/risk/fail>` | `<file / call chain / design note>` | `<DES-*/RISK-*>` | `<none / action>` |
| `ARCH-003` | Data consistency | `<transaction, rollback, idempotency, duplicate-write risk>` | `<pass/risk/fail>` | `<file / branch / query>` | `<DES-*/RISK-*>` | `<none / action>` |
| `ARCH-004` | Contract compatibility | `<DTO, API, migration, backward compatibility>` | `<pass/risk/fail>` | `<file / schema / api>` | `<REQ-*/RISK-*>` | `<none / action>` |
| `ARCH-005` | Operational safety | `<logs, metrics, alertability, replayability, migration safety>` | `<pass/risk/fail>` | `<file / command / dashboard clue>` | `<RISK-*>` | `<none / action>` |

### 架构关键判断

- shallow module risk: `<none / where abstraction is too thin>`
- coupling hotspot: `<none / which module couples too much>`
- async / cache / queue impact: `<none / specific risk>`
- migration / script safety: `<none / specific risk>`

## 资深程序员审计记录

> 对应旧标题：`Senior Engineer Review`

### 代码 Gate 结论

- code path correctness: `<summary>`
- edge cases checked: `<summary>`
- failure handling: `<summary>`
- maintainability: `<summary>`
- release code verdict: `<accept / accept-with-risk / reject>`

### 代码检查矩阵

| Gate ID | Checkpoint | What Was Reviewed | Result | Evidence | Related IDs | Follow-up |
|---------|------------|-------------------|--------|----------|-------------|-----------|
| `CODE-REVIEW-001` | Main path correctness | `<happy path and required behavior>` | `<pass/risk/fail>` | `<file / branch / command>` | `<REQ-*/TASK-*>` | `<none / action>` |
| `CODE-REVIEW-002` | Error path handling | `<all non-happy branches and operator visibility>` | `<pass/risk/fail>` | `<file / branch / log>` | `<RISK-*/REV-*>` | `<none / action>` |
| `CODE-REVIEW-003` | Boundary and invalid inputs | `<zero values, empty values, duplicate calls, permissions, nils>` | `<pass/risk/fail>` | `<file / branch / test case>` | `<REQ-*/RISK-*>` | `<none / action>` |
| `CODE-REVIEW-004` | Local code quality | `<function split, naming, comments, reuse, readability>` | `<pass/risk/fail>` | `<file / function>` | `<TASK-*>` | `<none / action>` |
| `CODE-REVIEW-005` | Logging and observability | `<error logs, success logs, trace fields, silent failure risk>` | `<pass/risk/fail>` | `<file / branch / log>` | `<RISK-*>` | `<none / action>` |

### 代码关键判断

- silent failure risk: `<none / where>`
- hidden branching risk: `<none / where>`
- duplication / drift risk: `<none / where>`
- maintainability debt: `<none / where>`

## 测试专家审计记录

> 对应旧标题：`Test Review Readiness`
> 这里记录测试准备度与风险入口；详细白盒评审见 `test-review.md`。

- unit / integration coverage sufficiency: `<summary>`
- white-box weak spots: `<summary>`
- regressions to watch: `<summary>`

## Risks Checked

- [ ] <risk check 1>
- [ ] <risk check 2>

## Residual Risks

- <remaining risk>

## Open Questions

- <question>

## Review Decision

- <decision>
