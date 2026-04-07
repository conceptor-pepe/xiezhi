# Launch Plan

## Objective

Move Speclawd from an internal prototype inside the backend repository to a standalone public alpha repository.

## Phase 1: Repository Extraction

- create a separate `speclawd` repository
- run `speclawd/scripts/extract-standalone.sh --target <new-repo-dir>`
- verify relative paths in scripts and docs
- run repository checks in the new root
- verify GitHub Actions runs `./scripts/check.sh` successfully in the standalone repository

## Phase 2: Public Narrative

- finalize README headline and opening paragraphs
- finalize repository short description
- finalize alpha release notes
- choose initial GitHub topics

## Phase 3: First Public Release

- tag `0.1.0-alpha.1`
- publish release notes
- publish usage examples for:
  - `minimal`
  - `go-service`
  - `backend-brownfield`

## Phase 4: Post-Launch Stabilization

- collect feedback on installation flow
- improve adapter coverage
- improve example repositories
- refine profile boundaries

## Risks

- the product can still appear too abstract without stronger examples
- adapter expectations may exceed current implementation maturity
- installation UX is functional but not yet polished

## Recommendation

Do not wait for perfection before the first alpha.

The current state is strong enough for a “working prototype” release as long as the README and release notes are clear about scope.
