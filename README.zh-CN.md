# specClawd

[English](README.md) | [简体中文](README.zh-CN.md)

面向 AI 辅助研发的门禁式工程框架。

specClawd 是一个仓库内原生的工程协作框架，用来给 AI 辅助开发加上“可追溯、可校验、可归档”的约束。它把变更文档、系统规格、验证门禁、评审结构、交付总结和归档流程放到同一套工作模型里。

## 为什么需要 specClawd

AI 编码工具很快，但如果没有门禁，漂移会很严重：

- 需求留在对话里，后面找不到
- 代码先落地，契约和设计没对齐
- review 看不到设计意图
- 交付总结因人而异
- 长期规格和线上行为逐渐脱节

specClawd 的目标，就是把这些问题收回到仓库内，用固定 artifact 和脚本门禁来约束。

## 核心流程

1. New Change
2. Spec Brief
3. Implement
4. Verify
5. Commit Summary
6. Archive

## 标准变更产物

- `change.md`
- `spec-delta.md`
- `design.md`
- `tasks.md`
- `review.md`
- `audit.md`
- `test-review.md`
- `commit-summary.md`
- `archive.md`
- `error-memory.md`

这些文件共同解决几件事：

- 设计是否清晰
- 风险是否被识别
- task 是否按最小可提交拆分
- review 和 test-review 是否能追溯到具体 requirement / design / risk
- 本次偏差是否被沉淀进纠错记忆

## 当前支持的适配器

- Cursor：仓库内 command adapter
- GitHub Copilot：仓库内 prompt adapter
- Claude：仓库内 prompt adapter
- Krio：仓库内 prompt adapter
- Codex：全局安装 prompt adapter

无论工具不同，specClawd 都要求同一套流程语义，不允许每个工具各搞一套 artifact。

## 快速开始

初始化一个仓库：

```bash
./install/init.sh --target /path/to/repo --profile backend-brownfield
```

一些常见示例：

```bash
./install/init.sh --target /path/to/repo --profile minimal --tool none
./install/init.sh --target /path/to/repo --profile go-service --tool cursor
./install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
./install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,copilot,claude,krio
```

推荐优先使用高层工作流命令：

- `specClawd:run`
- `specClawd:start`
- `specClawd:continue`
- `specClawd:approve`

也支持简写：

- `specld:run`
- `specld:start`
- `specld:next`
- `specld:approve`

如果你希望工具代理整条流程，优先使用单入口 driver：

```bash
/path/to/repo/scripts/specClawd-run.sh start add-team-credit-flow
```

之后通常只需要：

```bash
/path/to/repo/scripts/specClawd-run.sh approve /path/to/repo/docs/changes/<date>-add-team-credit-flow
/path/to/repo/scripts/specClawd-run.sh next /path/to/repo/docs/changes/<date>-add-team-credit-flow
```

如果你只是单独创建一个新变更，也可以直接用：

```bash
/path/to/repo/scripts/specClawd-new-change.sh add-team-credit-flow
```

在实现前，先准备：

- `spec-delta.md`
- `design.md`
- `tasks.md`

交付前运行：

```bash
/path/to/repo/scripts/specClawd-verify.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```

归档前运行：

```bash
/path/to/repo/scripts/specClawd-archive.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```

## 适合谁

- Brownfield 系统团队
- 正在使用 AI 工具写代码的研发团队
- 需要把需求、设计、评审、测试和归档沉淀到仓库里的团队
- 不满足于“写几个 prompt 约定一下”的团队

## 文档

- `docs/zh-CN/workflow.md`
- `docs/zh-CN/workflow-stage-plan.md`
- `docs/zh-CN/workflow-executor.md`
- `docs/zh-CN/cursor-usage.md`
- `docs/zh-CN/profiles.md`
- `docs/zh-CN/adapters.md`
- `docs/zh-CN/quick-start.md`
- `docs/profiles.md`
- `docs/adapters.md`
- `docs/quick-start.md`
- `docs/release.md`
- `docs/alpha-release.md`

## 当前状态

specClawd `0.1.0-alpha.1` 是第一版公开 alpha 仓库原型。  
它的目标不是“功能全部做完”，而是先证明这套安装方式、流程结构、门禁脚本和多工具适配方向是成立的。
