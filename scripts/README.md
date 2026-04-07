# Scripts

These scripts are the execution layer of Speclawd.

They should remain reusable across repositories and CI environments.

## Core Scripts

- `speclawd-new-change.sh`
- `speclawd-start.sh`
- `speclawd-continue.sh`
- `speclawd-approve.sh`
- `speclawd-executor.sh`
- `speclawd-driver.sh`
- `speclawd-run.sh`
- `speclawd-verify.sh`
- `speclawd-archive.sh`
- `speclawd-check-pr.sh`
- `speclawd-workflow-lib.sh`
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

`speclawd-run.sh` is the preferred single-entry wrapper for stateful workflow driving.
