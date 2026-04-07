# 工作流执行器接口

这份文档解释 `workflow-actions.json` 和 `speclawd-executor.sh` 的作用。

## 真源文件

- `adapters/shared/workflow-actions.json`

## 执行器脚本

- `scripts/speclawd-executor.sh`
- `scripts/specld-exec.sh`
- `scripts/speclawd-driver.sh`
- `scripts/speclawd-run.sh`
- `scripts/specld-run.sh`

## 作用

执行器不直接替工具写业务内容，但会给出当前阶段的标准动作清单。

它回答的是：

- 当前阶段应该更新哪些文件
- 当前阶段建议的 agent action 是什么
- 当前阶段完成条件是什么
- 如果需要确认，应该给用户展示什么确认提示
- 确认后下一阶段是什么

## 使用方式

```bash
scripts/speclawd-executor.sh <change-dir>
```

或：

```bash
scripts/specld-exec.sh <change-dir>
```

输出是 JSON，适合给 Cursor、Claude、Krio、Codex 这类工具继续消费。

## 它和其他文件的关系

- `workflow-state.json`：记录当前在哪个阶段
- `workflow-stage-plan.json`：定义阶段结构
- `workflow-actions.json`：定义当前阶段该执行哪些动作
- `speclawd-executor.sh`：把当前状态和动作模板拼装成可执行上下文

## 当前边界

当前执行器已经可以：

- 读取当前 change 的状态
- 根据当前阶段输出标准动作清单

参考 driver 还可以：

- `start`：启动工作流并立即输出当前阶段动作
- `status`：查看当前状态
- `exec`：查看当前阶段动作
- `approve`：确认当前等待点并打印下一阶段状态
- `next`：推进到下一阶段并打印下一阶段动作

示例：

```bash
scripts/speclawd-run.sh start order-refund-audit --date 2026-04-05
scripts/speclawd-run.sh approve docs/changes/2026-04-05-order-refund-audit
scripts/speclawd-run.sh next docs/changes/2026-04-05-order-refund-audit
```

等价地，也可以直接用 driver：

```bash
scripts/speclawd-driver.sh start order-refund-audit --date 2026-04-05
scripts/speclawd-driver.sh approve docs/changes/2026-04-05-order-refund-audit
scripts/speclawd-driver.sh next docs/changes/2026-04-05-order-refund-audit
```

当前执行器还没有直接做：

- 自动修改 artifact 内容
- 自动调用 LLM 生成每一阶段内容

对于 `test-review.md` 的结果判定，也要明确边界：

- `pass`：代码实现与已有证据下未发现阻塞性问题
- `risk`：缺少真实环境、联调、迁移回放、压测或外部依赖验证
- `fail`：已发现明确缺陷或阻塞风险

但这已经足够作为多工具代理层的统一输入。
