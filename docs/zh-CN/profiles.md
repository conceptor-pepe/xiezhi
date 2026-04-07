# Profiles 说明

specClawd 通过不同 profile 提供不同的安装覆盖范围。

## `minimal`

适合：

- 第一次试用 specClawd 的团队
- 只想先引入脚本和 artifact 结构，不想马上接工具适配器的仓库

包含：

- 核心模板
- `docs/specs/README.md`
- `docs/changes/README.md`
- 核心 workflow 规则
- scripts

默认不包含：

- Cursor adapter
- GitHub Copilot prompt
- Claude prompt
- Krio prompt

## `go-service`

适合：

- Go 服务仓库
- 想保留较强工程约束，但不想默认带 GitHub Copilot 的团队

包含：

- 完整模板集
- 核心 workflow 规则
- Cursor command adapter
- Claude prompt adapter
- Krio prompt adapter
- scripts

## `backend-brownfield`

适合：

- Brownfield 后端仓库
- 想要最完整 repository-local 工作流的团队

包含：

- 完整模板集
- 核心 workflow 规则
- Cursor command adapter
- GitHub Copilot prompt
- Claude prompt adapter
- Krio prompt adapter
- scripts

## 推荐

如果你不确定怎么选：

- 想低成本试用：`minimal`
- 典型 Go 服务团队：`go-service`
- 想要最完整门禁和适配器：`backend-brownfield`

## `--tool` 说明

选择 profile 后，还可以用 `--tool` 进一步控制 repository-local adapter 安装范围：

- `all`：安装该 profile 中的全部适配器
- `none`：不安装 repository-local adapter
- `cursor`：只安装 Cursor
- `copilot`：只安装 GitHub Copilot
- `claude`：只安装 Claude
- `krio`：只安装 Krio
- 也支持逗号组合，例如 `cursor,copilot`、`cursor,claude`、`claude,krio`

当前状态：

- Claude 和 Krio 已接入 `go-service` 与 `backend-brownfield`
- GitHub Copilot 仍只在 `backend-brownfield` 中提供
