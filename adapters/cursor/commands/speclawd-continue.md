# speclawd:continue

Continue the active Speclawd workflow from `workflow-state.json`.

Requirements:

- read the active change state first
- advance only one stage at a time
- stop when user confirmation is required
- preserve all artifact updates for the current stage

Typical next actions:

- implementation
- review pack
- verify
- commit summary
