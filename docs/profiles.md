# Profiles

Speclawd profiles package different installation footprints for different adoption levels.

## `minimal`

Best for:

- teams trying Speclawd for the first time
- repositories that want scripts and artifact structure before tool adapters

Includes:

- core templates
- `docs/specs/README.md`
- `docs/changes/README.md`
- core workflow rule
- scripts

Does not include:

- Cursor adapters
- GitHub Copilot prompts

## `go-service`

Best for:

- Go service repositories
- teams using Cursor but not necessarily repository-local Copilot prompts

Includes:

- full template set
- core workflow rule
- Cursor command adapters
- Claude prompt adapters
- Krio prompt adapters
- scripts

## `backend-brownfield`

Best for:

- brownfield backend repositories
- teams that want the most complete repository-local setup

Includes:

- full template set
- core workflow rule
- Cursor command adapters
- GitHub Copilot prompts
- Claude prompt adapters
- Krio prompt adapters
- scripts

## Recommendation

If you are unsure:

- start with `minimal` for low-friction adoption
- use `go-service` for a typical Go backend team
- use `backend-brownfield` when you want the strongest repository-local workflow setup

## Tool Selection

After choosing a profile, you can further control repository-local adapters with `--tool`:

- `all`: install all repository-local adapters in the profile
- `none`: install no repository-local adapters
- `cursor`: install only Cursor repository-local adapters
- `copilot`: install only GitHub Copilot repository-local adapters
- `claude`: install only Claude prompt adapters
- `krio`: install only Krio prompt adapters
- comma-separated combinations such as `cursor,copilot`, `cursor,claude`, or `claude,krio`

Current note:

- Claude and Krio prompt adapters are wired into both `go-service` and `backend-brownfield`
- GitHub Copilot prompts remain installed only in `backend-brownfield`
