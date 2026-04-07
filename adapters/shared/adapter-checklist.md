# Adapter Checklist

Use this checklist when adding a new adapter for tools such as Claude or Krio.

## Goal

Keep workflow meaning identical across tools while allowing different transport layers.

## Minimum Commands

The adapter should expose the same command set:

- `speclawd:new-change`
- `speclawd:spec-brief`
- `speclawd:verify`
- `speclawd:commit-summary`
- `speclawd:archive`

## Must Preserve

- artifact location: `docs/changes/<date>-<name>/`
- full artifact set, including `error-memory.md`
- stable IDs: `REQ-*`, `DES-*`, `RISK-*`, `TASK-*`, `REV-*`, `CASE-*`, `MEM-*`
- four-view review semantics
- white-box test-review semantics
- archive traceability summary
- correction-memory loop

## Validation Checklist

- command text matches `adapters/shared/command-contract.md`
- adapter prompts mention `error-memory.md`
- adapter prompts mention risk-driven traceability
- adapter prompts mention four-view review and white-box test review
- repository `scripts/check.sh` still passes after adding the adapter

## Non-Goals

- do not create tool-specific artifact names
- do not replace stable IDs with tool-native labels
- do not weaken gates just because the tool has a smaller prompt surface
