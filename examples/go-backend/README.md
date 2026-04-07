# Example: Go Backend

This example shows the repository shape after initializing specClawd in a Go backend project.

## Expected Layout

```text
go-backend/
├── docs/
│   ├── changes/
│   ├── specs/
│   └── templates/
├── scripts/
│   ├── specClawd-new-change.sh
│   ├── specClawd-verify.sh
│   ├── specClawd-archive.sh
│   └── specClawd-check-pr.sh
├── .cursor/
│   ├── rules/
│   └── commands/
└── .github/
    └── prompts/
```

## Intended Use

Use this example to understand the target repository shape, not as a full runnable application yet.

## Included Snapshot

This example now includes a small installed snapshot:

- example `.cursor/rules/`
- example `.cursor/commands/`
- example `.github/prompts/`
- example `docs/templates/`
- example `scripts/`
- sample `docs/specs/` and `docs/changes/`
