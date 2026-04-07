# 阶段计划模板

这份文档解释 `adapters/shared/workflow-stage-plan.json` 的用途。

它的目标是把“阶段执行规则”进一步变成机器可读取的计划模板，让工具代理工作流时不需要猜每一步该更新哪些文件。

## 真源文件

- `adapters/shared/workflow-stage-plan.json`

## 作用

这个文件用于回答 4 个问题：

1. 当前阶段要更新哪些文件
2. 当前阶段完成后要检查什么
3. 当前阶段是否必须等用户确认
4. 下一阶段是什么

## 当前阶段定义

当前模板包含这些阶段：

- `change-init`
- `spec-brief`
- `implementation`
- `review-pack`
- `verify`
- `commit-summary`
- `archive`

## 每个阶段包含的字段

- `id`：阶段 ID
- `purpose`：阶段目标
- `updates`：本阶段应更新的文件或对象
- `completion_checks`：阶段完成时必须满足的条件
- `confirmation_required`：是否必须等用户确认
- `confirmation_key`：等待确认时的确认点标识
- `next_stage`：下一阶段

## 使用方式

工具代理工作流时，建议按这个顺序使用：

1. 读取 `workflow-state.json`
2. 确认当前阶段
3. 读取 `workflow-stage-plan.json` 中对应阶段定义
4. 根据 `updates` 更新 artifact
5. 根据 `completion_checks` 判断是否允许推进
6. 如果 `confirmation_required=true`，先停下来等用户确认
7. 用户确认后，再进入 `next_stage`

## 它和脚本的关系

- `workflow-stage-plan.json`：描述阶段计划
- `workflow-state.json`：记录当前状态
- `specClawd-start/continue/approve.sh`：推进状态
- `specClawd-verify.sh` / `specClawd-archive.sh`：做硬门禁

也就是说：

- 计划模板回答“该做什么”
- 状态文件回答“当前做到哪了”
- 脚本回答“是否允许继续”

## 当前边界

当前这份 stage plan 还是规则模板，不是完整任务编排器。

它已经适合：

- 给 Cursor / Claude / Krio / Codex 统一高层工作流行为
- 给后续代理执行器提供稳定输入

它还没有直接做：

- 自动生成具体文件内容
- 自动理解业务需求并拆成细粒度 task

这一步需要后续的代理执行器把 stage plan 和 artifact 模板真正绑定起来。
