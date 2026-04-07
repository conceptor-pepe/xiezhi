# Error Memory: 2026-04-04-add-team-join-audit

> Record deviations, weak spots, and the rule updates added after this change. Every item here should be specific enough to turn into a future gate, template update, or checklist item.

## New Lessons

### Lesson 1

- lesson id: `MEM-001`
- symptom: change artifacts can look complete while still lacking explicit requirement-to-design-to-test traceability
- root cause: earlier templates only required broad sections, not stable cross-artifact references
- affected artifacts: `spec-delta.md`, `design.md`, `tasks.md`, `review.md`, `test-review.md`, `commit-summary.md`
- prevention rule: every change must define and reuse stable traceability IDs for requirements, design, tasks, findings, tests, and memory lessons
- gate update: templates and `speclawd-verify.sh` now require cross-artifact traceability IDs
- status: applied

## Reused Lessons

- `MEM-002`: smallest shippable task boundary is enforced in `tasks.md`

## Follow-Up Actions

- owner: speclawd maintainers
- next action: keep example files aligned with templates so regression checks remain trustworthy
