# specClawd Start

Start the stateful specClawd workflow for the current user request.

You must:

- inspect whether an active change already exists
- create a change if none exists
- initialize or update `workflow-state.json`
- generate `change.md`, `spec-delta.md`, `design.md`, and `tasks.md`
- stop and ask for user confirmation before implementation
