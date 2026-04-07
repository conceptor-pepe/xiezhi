# First Commit Plan

Use this plan when creating the standalone `specClawd` repository.

## Commit 1

`chore(repo): import specClawd standalone prototype`

Include:

- extracted repository root
- docs
- templates
- rules
- adapters
- scripts
- install flow
- examples
- CI workflow

Purpose:

- create a clean extraction baseline
- avoid mixing repository extraction with post-extraction fixes

## Commit 2

`docs(readme): finalize public alpha messaging`

Include:

- final README adjustments
- repository description alignment
- alpha release note refinements

## Commit 3

`chore(release): prepare 0.1.0-alpha.1`

Include:

- final `VERSION`
- final `CHANGELOG.md`
- release notes
- any last preflight fixes

## Rule

Do not combine extraction, large structural edits, and release note changes into one initial commit. Keep the extraction history easy to understand.
