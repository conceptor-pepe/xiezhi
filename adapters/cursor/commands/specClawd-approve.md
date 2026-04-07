# specClawd:approve

Record user approval for the current waiting workflow stage and continue.

Requirements:

- update `workflow-state.json`
- record the approved stage
- continue only after explicit user approval
- write the next stage outputs back into the change artifacts
