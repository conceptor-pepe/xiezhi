# specClawd:verify

Verify whether the current change is ready for delivery.

Check:

- `audit.md`
- `review.md`
- `test-review.md`
- `error-memory.md`
- repository policy files under `docs/specClawd/policies/` when the repository uses them
- `audit.md`, `review.md`, and `test-review.md` reference the repository policy sources they applied
- `audit.md` contains validation summary, audit execution evidence, project-defined audit checklist rows, and test-review gate status
- stable traceability IDs across spec, design, tasks, review, test review, archive, and memory
- product / architecture / senior engineer / test readiness conclusions
- white-box coverage conclusions
- required build, test, lint, and doc sync

Write results back to the change artifacts before summarizing status.
