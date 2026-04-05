# Review: 2026-04-04-add-team-join-audit

## Findings

### Finding 1

- severity: low
- location: team join flow
- issue: duplicate write risk if retries are not idempotent
- resolution: require a stable join event key for audit writes

## Risks Checked

- [x] successful join writes one audit record
- [x] retry path is expected to reuse the same event key

## Residual Risks

- a future asynchronous version would need stronger delivery guarantees

## Open Questions

- should audit writes be asynchronous in a future revision?

## Review Decision

- keep audit creation synchronous in the first version
