# Repository Setup Checklist

Use this after creating the standalone `speclawd` repository on GitHub.

## README

- replace root `README.md` with `docs/standalone-readme.md`
- verify links and relative paths still work from the repository root

## Repository Metadata

- set short description:
  `Gate-driven engineering for AI-assisted software development.`
- add topics from `docs/repo-description.md`
- choose a social preview image later if needed

## CI

- enable Actions
- verify `.github/workflows/ci.yml` runs on push and pull request
- confirm CI executes `./scripts/check.sh` from the repository root

## Release

- verify `VERSION`
- verify `CHANGELOG.md`
- run `scripts/release-preflight.sh`
- create tag `0.1.0-alpha.1`
- paste `docs/release-body-0.1.0-alpha.1.md` into the GitHub release body

## Post-Release

- collect feedback on:
  - install flow
  - profile choice clarity
  - adapter expectations
  - example usefulness
