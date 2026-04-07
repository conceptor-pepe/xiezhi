# speclawd:start

Start the stateful Speclawd workflow for the current user request.

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

Use `speclawd:continue` after the next confirmation point.
