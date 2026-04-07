# Scripts

These scripts are the execution layer of specClawd.

They should remain reusable across repositories and CI environments.

## Core Scripts

- `specClawd-new-change.sh`
- `specClawd-start.sh`
- `specClawd-continue.sh`
- `specClawd-approve.sh`
- `specClawd-executor.sh`
- `specClawd-driver.sh`
- `specClawd-run.sh`
- `specClawd-verify.sh`
- `specClawd-archive.sh`
- `specClawd-check-pr.sh`
- `specClawd-workflow-lib.sh`
- `specld-start.sh`
- `specld-next.sh`
- `specld-approve.sh`
- `specld-exec.sh`
- `specld-run.sh`
- `check.sh`
- `release-preflight.sh`
- `extract-standalone.sh`

## Rule

Scripts enforce workflow mechanics. They should avoid embedding product-specific business logic.

`specClawd-run.sh` is the preferred single-entry wrapper for stateful workflow driving.
