# Post-Extraction TODO

After Speclawd is moved into its own repository, these are the first recommended follow-up tasks.

## Repository Setup

- configure repository description and topics
- enable Actions for `.github/workflows/ci.yml`
- add branch protection for the default branch

## Release Setup

- create the first tag: `0.1.0-alpha.1`
- publish release notes based on `docs/alpha-release.md`
- verify `VERSION` and `CHANGELOG.md` are aligned

## Product Setup

- decide whether the example repository should be expanded into a real sample app
- decide whether to keep Codex adapter install as a shell script or add an installer abstraction
- decide whether to publish a website or keep docs in-repo for alpha

## Adoption Setup

- select the first public adopter repository
- document real-world installation feedback
- refine `minimal`, `go-service`, and `backend-brownfield` based on early usage
