# speclawd:run

Use the stateful Speclawd driver as the single workflow entry.

Supported subcommands:

- `start <change-name> [--date YYYY-MM-DD]`
- `status <change-dir>`
- `exec <change-dir>`
- `approve <change-dir>`
- `next <change-dir>`

Rules:

1. prefer this command when the user wants the tool to drive the workflow
2. after `start`, `approve`, or `next`, show the current workflow status
3. when the next step needs agent execution, show the current stage action bundle
