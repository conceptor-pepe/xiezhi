# Adapters 说明

specClawd 的适配器分两类：

- repository-local：适配器文件落在业务仓库内，由工具直接读取
- global-install：适配器文件安装到用户目录，由工具全局读取

无论接哪个工具，流程语义都必须一致，不能因为工具不同就改 artifact 结构或门禁标准。

## 统一约束

所有适配器都必须复用：

- `docs/changes/<date>-<name>/` 目录结构
- 固定 artifact 集合
- 稳定 ID：
  - `REQ-*`
  - `DES-*`
  - `RISK-*`
  - `TASK-*`
  - `REV-*`
  - `CASE-*`
  - `MEM-*`
- 四视角 `review.md`
- 白盒 `test-review.md`
- `archive.md` 追溯摘要
- `error-memory.md` 纠错记忆

共享契约见：

- `adapters/shared/command-contract.md`
- `adapters/shared/adapter-checklist.md`
- `adapters/shared/workflow-protocol.md`

## 高层工作流命令

为了避免用户记脚本名，推荐优先使用高层命令：

- `specClawd:run`
- `specClawd:start`
- `specClawd:continue`
- `specClawd:approve`

简写别名：

- `specld:run`
- `specld:start`
- `specld:next`
- `specld:approve`

其中：

- `specClawd:run / specld:run` 是推荐的单入口 driver
- `start / continue / approve` 是 driver 内部阶段控制命令，也可以由高级用户直接使用

这些命令的目标是：

- 用户表达目标
- 工具自动创建或继续 change
- 自动推进到下一阶段
- 在关键节点停下来等用户确认

阶段执行规则见：

- `docs/zh-CN/workflow.md`
- `docs/zh-CN/cursor-usage.md`

底层命令仍然保留，但更偏向工作流内部能力：

- `specClawd:new-change`
- `specClawd:spec-brief`
- `specClawd:verify`
- `specClawd:commit-summary`
- `specClawd:archive`

如果你希望在命令行里直接推进工作流，也可以使用对应脚本：

- `scripts/specClawd-run.sh`
- `scripts/specClawd-start.sh`
- `scripts/specClawd-continue.sh`
- `scripts/specClawd-approve.sh`
- 简写：
  - `scripts/specld-run.sh`
  - `scripts/specld-start.sh`
  - `scripts/specld-next.sh`
  - `scripts/specld-approve.sh`

## Repository-Local Adapters

### Cursor

安装位置：

- `.cursor/rules/specClawd-spec.mdc`
- `.cursor/commands/specClawd-*.md`

### GitHub Copilot

安装位置：

- `.github/prompts/specClawd-*.prompt.md`

### Claude

安装位置：

- `.claude/prompts/specClawd-*.md`

### Krio

安装位置：

- `.krio/prompts/specClawd-*.md`

这些 repository-local adapter 的特点是：

- prompt 或 command 文件跟着仓库走
- 团队成员拉代码后就能看到同一套约束
- 更适合仓库内强约束协作

## Global-Install Adapter

### Codex

Codex 当前仍是全局安装模式。

安装方式：

```bash
specClawd/adapters/codex/install.sh
```

默认安装位置：

- `$CODEX_HOME/prompts/`
- 或 `~/.codex/prompts/`

## 安装示例

```bash
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
specClawd/install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,copilot,claude,krio
```
