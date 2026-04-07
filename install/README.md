# Install

## Repository Mode

Initialize a repository with a profile:

```bash
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool claude
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,claude,krio
specClawd/install/init.sh --target /path/to/repo --profile minimal --tool none
```

Default profile:

- `backend-brownfield`

Available profiles:

- `minimal`
- `go-service`
- `backend-brownfield`

Tool install modes:

- `all`
- `none`
- `cursor`
- `copilot`
- `claude`
- `krio`
- comma-separated combinations such as `cursor,copilot`, `cursor,claude`, or `claude,krio`

## Global Adapter Mode

Some tools need global installation instead of repository-local files.

Example:

- Codex prompts can be installed to `$CODEX_HOME/prompts/` or `~/.codex/prompts/`

Use:

```bash
specClawd/adapters/codex/install.sh
```

## Installed Repository Assets

The init script installs:

- `docs/templates/*`
- `docs/specs/README.md`
- `docs/changes/README.md`
- `.cursor/rules/specClawd-spec.mdc`
- `.cursor/commands/specClawd-*.md`
- `.github/prompts/specClawd-*.prompt.md`
- `.claude/prompts/specClawd-*.md`
- `.krio/prompts/specClawd-*.md`
- `scripts/specClawd-*.sh`
- `scripts/specld-*.sh`

See profile differences in `specClawd/docs/profiles.md`.

Adapter usage details:

- `specClawd/docs/adapters.md`
