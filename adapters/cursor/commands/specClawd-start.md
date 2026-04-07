# specClawd:start

Start the stateful specClawd workflow for the current user request.

Workflow:

1. inspect whether an active change already exists
2. create a change if none exists
3. initialize or update `workflow-state.json`
4. generate or refresh:
   - `change.md`
   - `spec-delta.md`
   - `design.md`
   - `tasks.md`
5. stop and ask for user confirmation before implementation

Use `specClawd:continue` after the next confirmation point.
