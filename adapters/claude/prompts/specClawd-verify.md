# specClawd Verify

Verify whether the current change is ready for delivery.

Check:

- audit, build, lint, and test status
- `REQ-*`, `DES-*`, `RISK-*`, `TASK-*`, `REV-*`, `CASE-*`, and `MEM-*` traceability
- four-view `review.md`: product, architecture, senior engineer, test readiness
- white-box `test-review.md` structure and case evidence
- `Issues Found` linkage to `REV-*` or `TEST-RISK-*`
- task quality and risk coverage consistency
- required documentation sync for delivery and archive

Write any corrections back into the change artifacts before concluding whether the change can move to commit summary.
