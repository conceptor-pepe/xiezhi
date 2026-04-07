# Speclawd Run

Use the stateful Speclawd driver as the single workflow entry.

Supported subcommands:

- `start <change-name> [--date YYYY-MM-DD]`
- `status <change-dir>`
- `exec <change-dir>`
- `approve <change-dir>`
- `next <change-dir>`

You must:

- prefer this command when the user wants the tool to drive the workflow
- show workflow status after each transition
- surface the current stage action bundle when execution should continue
