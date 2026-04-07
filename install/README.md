# Install

## Repository Mode

Initialize a repository with a profile:

```bash
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool claude
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,claude,krio
speclawd/install/init.sh --target /path/to/repo --profile minimal --tool none
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
speclawd/adapters/codex/install.sh
```

## Installed Repository Assets

The init script installs:

- `docs/templates/*`
- `docs/specs/README.md`
- `docs/changes/README.md`
- `.cursor/rules/speclawd-spec.mdc`
- `.cursor/commands/speclawd-*.md`
- `.github/prompts/speclawd-*.prompt.md`
- `.claude/prompts/speclawd-*.md`
- `.krio/prompts/speclawd-*.md`
- `scripts/speclawd-*.sh`
- `scripts/specld-*.sh`

See profile differences in `speclawd/docs/profiles.md`.

Adapter usage details:

- `speclawd/docs/adapters.md`
