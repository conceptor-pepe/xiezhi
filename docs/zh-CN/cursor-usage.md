# Cursor 使用规范

这份文档用于约束团队在 Cursor 中如何稳定触发 specClawd 工作流。

目标不是“希望 Cursor 记得走流程”，而是让团队在不同任务类型下都用统一入口触发：

- `specClawd:run`
- `specld:run`

## 总原则

所有改动都进入同一条 specClawd 工作流，但按风险分层：

- 新特性：完整流程
- 复杂修改 / 疑难问题：完整流程
- 简单修改：轻量流程

共同要求：

- 不直接让 Cursor 上来就改代码
- 先进入 `specld:run`
- 没有 `verify` 通过，不算完成
- 没有 `review.md`、`test-review.md`、`error-memory.md`，不允许宣称完成

## 前置条件

业务仓库至少应已安装：

- `.cursor/rules/specClawd-spec.mdc`
- `.cursor/commands/specClawd-run.md`
- `.cursor/commands/specld-run.md`
- `.cursor/commands/specClawd-start.md`
- `.cursor/commands/specClawd-continue.md`
- `.cursor/commands/specClawd-approve.md`

推荐通过以下方式安装：

```bash
specClawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor
```

## 场景 1：新增特性

### 适用

- 新接口
- 新表结构
- 新模块能力
- 跨模块需求实现

### 规则

- 必须创建新的 change
- 必须先产出 `change.md`、`spec-delta.md`、`design.md`、`tasks.md`
- 必须等用户确认方案后再编码
- 必须补齐 `review.md`、`test-review.md`、`audit.md`、`error-memory.md`

### 推荐提示词

```text
这是一个新特性，请严格按 specld:run 进入 specClawd 工作流。
先创建 change，并生成 change.md、spec-delta.md、design.md、tasks.md。
在我确认方案前不要开始编码。
```

### 极简提示词

```text
按 specld:run 启动一个新 change，先出方案，确认后再实现。
```

## 场景 2：复杂修改 / 疑难问题

### 适用

- 高风险 bugfix
- 数据一致性问题
- 并发 / 事务 / 幂等问题
- 跨模块逻辑漂移
- 需要读多处代码才能定位的问题

### 规则

- 先检查是否已有 active change
- 没有则创建 change
- 必须先做数据结构、接口契约、模块耦合、风险点分析
- 必须明确 `RISK-*`
- 必须在设计确认后再编码

### 推荐提示词

```text
这是一个复杂修改，请按 specld:run 进入 specClawd 工作流。
如果已有 active change 就继续，没有就创建。
先完成 spec-delta、design、tasks 和风险分析，确认后再改代码。
```

### 极简提示词

```text
按 specld:run 处理这个复杂改动，先做设计和风险分析，不要直接改代码。
```

## 场景 3：简单修改

### 适用

- 小 bugfix
- 单字段补充
- 单点逻辑修正
- 文案或返回字段微调
- 不涉及跨模块的新行为

### 规则

- 仍然进入 specClawd 工作流
- 允许轻量模式
- 可以只拆 1 个 `TASK-*`
- `design.md` 可以简化，但不能跳过
- `review.md`、`test-review.md`、`verify` 不能跳过

### 推荐提示词

```text
这是一个简单修改，也请按 specld:run 进入 specClawd 工作流。
允许走轻量模式：保持最小 change、最小 design、单个 TASK-*，但不要跳过 review、test-review 和 verify。
```

### 极简提示词

```text
按 specld:run 走轻量流程处理这个简单修改，不要跳过 verify。
```

## 不推荐说法

下面这些说法容易让 Cursor 直接跳过流程：

- “直接帮我改一下代码”
- “先修了再说”
- “不用写文档，先实现”
- “先别管 review/test-review”
- “这很简单，直接做完”

这些表达会让 Cursor更倾向于直接编码，而不是先进入 `specld:run`。

## 团队统一约束

推荐在团队内统一这 4 条：

1. 高风险改动必须有 `docs/changes/<date>-<name>/`
2. Cursor 会话默认从 `specld:run` 开始
3. 简单修改允许轻量流程，但不允许跳过 `verify`
4. 没有 `review.md`、`test-review.md`、`error-memory.md`，不允许说“完成”

## 一句话记忆

- 新特性：先方案，后编码
- 复杂修改：先分析风险，后编码
- 简单修改：走轻量流程，但不跳过校验

对 Cursor 的统一入口只有一个：

```text
按 specld:run 进入 specClawd 工作流。
```
