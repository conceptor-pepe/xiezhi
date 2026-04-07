# Release

## Versioning

Speclawd should use semantic versioning:

- major: breaking workflow or install changes
- minor: new profiles, adapters, commands, or compatible install features
- patch: fixes, documentation improvements, non-breaking script updates

## Release Checklist

1. update `VERSION`
2. update `CHANGELOG.md`
3. verify install flows for supported profiles
4. verify adapter files are complete
5. verify scripts pass shell syntax checks
6. run `speclawd/scripts/release-preflight.sh`
7. tag the release

Recommended supporting documents:

- `docs/release-notes-0.1.0-alpha.1.md`
- `docs/release-body-0.1.0-alpha.1.md`
- `docs/alpha-release.md`
- `docs/first-commit-plan.md`

## Initial Milestones

- `0.1.x`: prototype releases
- `0.2.x`: broader profile and adapter coverage
- `1.0.0`: stable install, profiles, adapters, and docs
