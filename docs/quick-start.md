# Quick Start

## 1. Initialize A Repository

```bash
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield
```

If you want a lighter setup, use:

```bash
specClawd/install/init.sh --target /path/to/repo --profile minimal
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool claude
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,claude,krio
```

## 2. Start The Workflow

```bash
/path/to/repo/scripts/specClawd-run.sh start add-team-credit-flow
```

If you only want to create the change scaffold, you can still use:

```bash
/path/to/repo/scripts/specClawd-new-change.sh add-team-credit-flow
```

## 3. Prepare The Brief

Use your adapter command:

- `specClawd:run`
- `specClawd:start`
- `specClawd:continue`
- `specClawd:approve`
- or aliases: `specld:run`, `specld:start`, `specld:next`, `specld:approve`

Prefer `specClawd:run / specld:run` as the single workflow entry, then let the tool decide whether it should `start`, `approve`, `next`, or `exec`.

Adapter locations and install modes:

- see `docs/adapters.md`

Then fill:

- `spec-delta.md`
- `design.md`
- `tasks.md`
- `review.md`
- `test-review.md`
- `error-memory.md`

## 4. Verify Before Delivery

```bash
/path/to/repo/scripts/specClawd-verify.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```

## 5. Archive

```bash
/path/to/repo/scripts/specClawd-archive.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```
