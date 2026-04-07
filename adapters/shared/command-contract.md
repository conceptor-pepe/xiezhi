# Command Contract

All adapters must preserve the same command semantics.

## Required Artifacts

Every adapter workflow must preserve the same change artifact set under `docs/changes/<date>-<name>/`:

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

## Stable IDs

Adapters must preserve these cross-artifact IDs and may not rename or replace them with tool-specific alternatives:

- `REQ-*`: requirements
- `DES-*`: design decisions
- `RISK-*`: risk points
- `TASK-*`: smallest shippable task slices
- `REV-*`: review findings
- `CASE-*`: test cases
- `MEM-*`: reusable lessons

## Commands

## Workflow Commands

### `speclawd:run`

Single-entry workflow driver for stateful execution.

Must:

- route to `start`, `status`, `exec`, `approve`, or `next`
- print the current workflow status after state transitions
- show the current stage action bundle when the next step needs tool execution

Alias:

- `specld:run`

### `speclawd:start`

High-level workflow entry for a new user request.

Must:

- inspect whether an active change already exists
- create a change when needed
- initialize or update `workflow-state.json`
- generate `change.md`, `spec-delta.md`, `design.md`, and `tasks.md`
- stop for user confirmation before implementation

Alias:

- `specld:start`

### `speclawd:continue`

Continue the active workflow from `workflow-state.json`.

Must:

- read the active change state
- advance only one stage at a time
- stop when user confirmation is required
- preserve artifact updates from the current stage

Alias:

- `specld:next`

### `speclawd:approve`

Record user approval for the current waiting stage and move to the next workflow stage.

Must:

- update `workflow-state.json`
- record which stage was approved
- continue the workflow only after the approval is explicit

Alias:

- `specld:approve`

### `speclawd:new-change`

Create a new change directory and scaffold required artifacts.

Must ensure all required artifacts exist before implementation starts.

### `speclawd:spec-brief`

Prepare `spec-delta.md`, `design.md`, and `tasks.md` before implementation.

Must preserve:

- phase 0.5 `Step 1 -> Step 4`
- `design.md` review/test mapping
- `design.md` risk coverage mapping
- `tasks.md` smallest shippable task breakdown
- traceability IDs across `REQ-*`, `DES-*`, `RISK-*`, `TASK-*`, and `CASE-*`

### `speclawd:verify`

Check audit, review, test review, and related docs before delivery.

Must verify:

- audit / build / lint / test status
- repository policy linkage for coding standards, audit, and test review when the repo defines local policy files
- four-view `review.md`: product, architecture, senior engineer, test readiness
- white-box `test-review.md` structure and conclusions
- `Issues Found` linkage to `REV-*` or `TEST-RISK-*`
- cross-artifact traceability
- task quality and risk coverage consistency
- `error-memory.md` existence and `MEM-*` usage

### `speclawd:commit-summary`

Generate the delivery-layer summary for the change.

Must include:

- key design points
- traceability section for `REQ-*`, `DES-*`, `TASK-*`, and `CASE-*`
- validation result line
- test review summary aligned with the actual test-review outcome

### `speclawd:archive`

Update long-term specs and complete archive records.

Must preserve:

- long-term spec sync from `spec-delta.md`
- `archive.md` traceability summary covering `REQ-*`, `DES-*`, `TASK-*`, `REV-*`, `CASE-*`, and `MEM-*`
- `error-memory.md` lesson capture
- consistency with `review.md`, `test-review.md`, and `commit-summary.md`

## Adapter Rule

Adapters may change transport or file format, but they must not change workflow meaning.

## New Adapter Rule

When adding support for a new tool such as Claude or Krio:

1. Reuse these exact command semantics.
2. Reuse the same artifact names and stable IDs.
3. Do not weaken review, test-review, archive, or error-memory expectations.
4. Prefer adapting transport and invocation only; do not fork workflow meaning by tool.

## Repository Policy Rule

Repositories may define project-specific policy files for:

- coding standards
- audit gates
- test review expectations

Adapters and scripts must preserve the artifact semantics, but they must not hard-code one universal project rule set when the repository provides its own policy files.
