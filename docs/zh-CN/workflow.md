# 工作流执行规则

这份文档描述 `specClawd` 的高层工作流如何推进，以及每个阶段必须沉淀哪些 artifact。

目标不是让用户记脚本名，而是让工具代理流程。

## 推荐入口

优先使用高层命令：

- `specClawd:run`
- `specClawd:start`
- `specClawd:continue`
- `specClawd:approve`

简写：

- `specld:run`
- `specld:start`
- `specld:next`
- `specld:approve`

其中：

- `specClawd:run / specld:run` 是推荐的单入口 driver
- `start / continue / approve` 适合工具或高级用户按阶段精确控制

## 状态文件

每个 change 目录下会维护：

- `workflow-state.json`

它记录：

- 当前阶段
- 下一阶段
- 是否在等待确认
- 当前等哪一步确认
- 已完成阶段
- 推荐下一条命令

机器可读取的阶段模板见：

- `adapters/shared/workflow-stage-plan.json`
- `docs/zh-CN/workflow-stage-plan.md`
- `adapters/shared/workflow-actions.json`
- `docs/zh-CN/workflow-executor.md`

## 阶段定义

推荐阶段顺序：

1. `intent`
2. `change-init`
3. `spec-brief`
4. `design-review`
5. `implementation`
6. `review-pack`
7. `verify`
8. `commit-summary`
9. `archive`

## 各阶段要求

### 1. `change-init`

目标：

- 创建 change 目录
- 生成标准 artifact
- 初始化 `workflow-state.json`

必须生成：

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
- `workflow-state.json`

### 2. `spec-brief`

目标：

- 在实现前把方案写清楚

必须沉淀：

- `change.md`
- `spec-delta.md`
- `design.md`
- `tasks.md`

必须满足：

- 没有 placeholder
- `REQ-* / DES-* / RISK-* / TASK-* / CASE-*` 关系已建立

完成后：

- 停下来等待用户确认
- 等待点：`design-review`

### 3. `implementation`

目标：

- 按 `TASK-*` 实现代码

要求：

- 不跳过已经确认的设计
- 代码改动和 `tasks.md` 对齐

完成后：

- 进入 `review-pack`

### 4. `review-pack`

目标：

- 补齐 review、test-review、audit、error-memory

必须沉淀：

- `review.md`
- `test-review.md`
- `audit.md`
- `error-memory.md`

要求：

- review 有产品 / 架构 / 资深开发 / 测试准备四视角
- test-review 有白盒测试结论
- 风险点必须映射到 `REV-*` 和 `CASE-*`
- `test-review.md` 中的 `pass` 表示“从代码实现和已有证据看没有发现阻塞性问题”，不等价于真实环境已完整验证通过
- 若缺少迁移回放、联调、压测、外部依赖或真实环境证据，应优先标记为 `risk` 而不是 `pass`

完成后：

- 停下来等待用户确认
- 等待点：`verify`

### 5. `verify`

目标：

- 执行硬门禁校验

执行：

```bash
scripts/specClawd-verify.sh <change-dir>
```

通过后：

- 进入 `commit-summary` 确认点

### 6. `commit-summary`

目标：

- 生成交付总结

必须沉淀：

- `commit-summary.md`

要求：

- 与 `review.md`、`test-review.md`、`audit.md` 一致

完成后：

- 停下来等待用户确认
- 等待点：`archive`

### 7. `archive`

目标：

- 回写长期 specs
- 补齐 `archive.md`
- 执行归档前检查

执行：

```bash
scripts/specClawd-archive.sh <change-dir>
```

通过后：

- 工作流状态应进入 `completed`

## 确认点

必须由用户明确确认的阶段：

- `design-review`
- `verify`
- `commit-summary`
- `archive`

## 当前边界

当前版本已经支持：

- 状态文件
- 高层命令
- 状态推进脚本
- `verify/archive` 阶段自动触发底层脚本

当前版本还没有完全自动完成：

- 由工具自动生成每一阶段的全部内容
- 自动根据用户自然语言理解并补全所有 artifact

也就是说，当前更接近“有状态工作流骨架 + 门禁执行器”，下一步才是“完整代理执行器”。
