# Example: Go Backend

This example shows the repository shape after initializing Speclawd in a Go backend project.

## Expected Layout

```text
go-backend/
├── docs/
│   ├── changes/
│   ├── specs/
│   └── templates/
├── scripts/
│   ├── speclawd-new-change.sh
│   ├── speclawd-verify.sh
│   ├── speclawd-archive.sh
│   └── speclawd-check-pr.sh
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
