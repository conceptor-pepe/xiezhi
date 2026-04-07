# Workflow Protocol

This file defines the stateful agent workflow that sits above the low-level `Speclawd` scripts.

## Goal

Users should describe intent, not memorize script names.

Example:

- user: `实现订单退款审计`
- tool:
  1. checks whether an active change exists
  2. creates one if needed
  3. prepares `spec-delta.md`, `design.md`, and `tasks.md`
  4. waits for user confirmation
  5. implements code
  6. prepares `review.md`, `test-review.md`, `audit.md`, and `error-memory.md`
  7. runs verify
  8. writes `commit-summary.md`

## State File

Each change directory may contain `workflow-state.json`.

Recommended fields:

- `change_id`
- `current_stage`
- `stage_status`
- `next_stage`
- `waiting_for_confirmation`
- `pending_confirmation_for`
- `completed_stages`
- `recommended_command`
- `recommended_alias`
- `updated_at`

## Stage Plan

The machine-readable stage template lives in:

- `adapters/shared/workflow-stage-plan.json`
- `adapters/shared/workflow-actions.json`

Use it to determine:

- which artifacts should be updated in the current stage
- what completion checks should be satisfied
- whether explicit user confirmation is required
- what the next stage should be

Use `workflow-actions.json` to determine:

- what the agent should do in the current stage
- what confirmation prompt should be shown
- what the next stage should be after approval

## Stages

Recommended stage sequence:

1. `intent`
2. `change-init`
3. `spec-brief`
4. `design-review`
5. `implementation`
6. `review-pack`
7. `verify`
8. `commit-summary`
9. `archive`

## Confirmation Rules

The workflow should explicitly stop for user confirmation at least at these points:

- after `spec-brief`, before implementation
- after `review-pack`, before verify
- after `verify`, before commit summary or archive

## High-Level Commands

- `speclawd:start` / `specld:start`
- `speclawd:continue` / `specld:next`
- `speclawd:approve` / `specld:approve`

## Low-Level Commands

These remain valid as lower-level building blocks:

- `speclawd:new-change`
- `speclawd:spec-brief`
- `speclawd:verify`
- `speclawd:commit-summary`
- `speclawd:archive`

## Adapter Rule

Adapters may package these commands differently, but should preserve the same staged behavior and confirmation points.
