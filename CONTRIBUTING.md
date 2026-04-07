# Contributing

Thanks for contributing to specClawd.

## Scope

Good contributions for the current alpha include:

- install flow improvements
- profile clarity improvements
- adapter coverage improvements
- example repository improvements
- documentation fixes
- non-breaking script fixes

Avoid large workflow redesigns without discussion first.

## Recommended Workflow

1. Open an issue before large changes.
2. Keep changes focused and reviewable.
3. Run:

```bash
./scripts/check.sh
./scripts/release-preflight.sh
```

4. Update docs when behavior changes.
5. Keep profile changes explicit and documented.

## Pull Requests

PRs should explain:

- what changed
- why it changed
- which profile or adapter is affected
- how it was validated

## Change Discipline

specClawd is itself a workflow product. Contributions should keep these qualities:

- explicit structure
- clear gates
- predictable installation
- understandable examples

## Early Alpha Note

This project is still in alpha. Maintainability and clarity matter more than feature volume.
