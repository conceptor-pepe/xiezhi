# Adapters

Speclawd 的适配器分两类：

- repository-local：适配器文件直接落在业务仓库里，由工具在仓库内读取
- global-install：适配器文件安装到用户目录，由工具全局读取

目标不是为每个工具发明不同流程，而是让不同工具共享同一套 `Speclawd` 语义。

## 统一约束

所有适配器都必须遵守：

- `docs/changes/<date>-<name>/` 目录结构
- 固定 artifact 集合
- 稳定 ID：`REQ-*`、`DES-*`、`RISK-*`、`TASK-*`、`REV-*`、`CASE-*`、`MEM-*`
- 四视角 `review.md`
- 白盒 `test-review.md`
- `archive.md` 追溯摘要
- `error-memory.md` 纠错记忆闭环

共享契约见：

- `adapters/shared/command-contract.md`
- `adapters/shared/adapter-checklist.md`
- `adapters/shared/workflow-protocol.md`

## 高层工作流命令

为了避免用户记住底层脚本名，推荐优先使用高层工作流命令：

- `speclawd:run`
- `speclawd:start`
- `speclawd:continue`
- `speclawd:approve`

简写别名：

- `specld:run`
- `specld:start`
- `specld:next`
- `specld:approve`

其中：

- `speclawd:run / specld:run` 是推荐的单入口 driver
- `start / continue / approve` 适合工具内部调度或高级用户显式控制阶段

底层命令仍然存在，但它们更适合作为工作流内部能力，而不是用户主入口：

- `speclawd:new-change`
- `speclawd:spec-brief`
- `speclawd:verify`
- `speclawd:commit-summary`
- `speclawd:archive`

如果你希望在命令行里直接推进工作流，也可以使用对应脚本：

- `scripts/speclawd-run.sh`
- `scripts/speclawd-start.sh`
- `scripts/speclawd-continue.sh`
- `scripts/speclawd-approve.sh`
- 简写：
  - `scripts/specld-run.sh`
  - `scripts/specld-start.sh`
  - `scripts/specld-next.sh`
  - `scripts/specld-approve.sh`

## Repository-Local Adapters

### Cursor

安装后文件位置：

- `.cursor/rules/speclawd-spec.mdc`
- `.cursor/commands/speclawd-*.md`

使用方式：

- 在 Cursor 中执行仓库命令，如 `speclawd:new-change`
- 命令语义由仓库内文件约束

### GitHub Copilot

安装后文件位置：

- `.github/prompts/speclawd-*.prompt.md`

使用方式：

- 在支持仓库 prompt 的 Copilot 工作流中引用这些 prompt
- 保持与 Cursor / Claude / Krio / Codex 相同的流程语义

### Claude

安装后文件位置：

- `.claude/prompts/speclawd-*.md`

使用方式：

- 将这些 prompt 作为 Claude 的仓库内提示入口
- 对应命令语义仍是 `speclawd:new-change`、`speclawd:spec-brief`、`speclawd:verify`、`speclawd:commit-summary`、`speclawd:archive`

### Krio

安装后文件位置：

- `.krio/prompts/speclawd-*.md`

使用方式：

- 将这些 prompt 作为 Krio 的仓库内提示入口
- 语义与其他工具保持一致，不单独发明 artifact 或步骤

## Global-Install Adapter

### Codex

Codex 当前走全局安装模式。

安装脚本：

```bash
speclawd/adapters/codex/install.sh
```

默认安装位置：

- `$CODEX_HOME/prompts/`
- 或 `~/.codex/prompts/`

用途：

- 将 `speclawd-*.md` prompt 安装到 Codex 的全局 prompt 目录

## 选型建议

- 想要最强仓库内约束：用 `backend-brownfield`
- Go 服务仓库且不想默认带 Copilot：用 `go-service`
- 先只试流程和模板：用 `minimal`

## 安装示例

```bash
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,copilot,claude,krio
```
