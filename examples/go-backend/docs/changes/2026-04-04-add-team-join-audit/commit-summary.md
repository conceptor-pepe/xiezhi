**Commit 1: 团队加入审计补充** 已完成。

为团队加入流程补齐审计记录，方便后台回溯是谁在什么时间完成了加入操作。  
这次改动的目标是先把团队加入链路留痕补齐，而不是重构主业务流程。

| 文件 | 变更说明 |
|------|----------|
| [business.md](examples/go-backend/docs/specs/team/business.md) | 增加审计要求 |
| [change.md](examples/go-backend/docs/changes/2026-04-04-add-team-join-audit/change.md) | 记录变更背景 |
| [tasks.md](examples/go-backend/docs/changes/2026-04-04-add-team-join-audit/tasks.md) | 跟踪实施步骤 |

**关键设计点**：
- 首版保持同步审计写入，避免引入额外异步链路
- 审计写入要求幂等，避免重复记录

**验证结果**：编译通过 ✅ | 测试通过 ✅ | Lint 清洁 ✅ | 编码规范审计 ✅

**提交信息**：
```text
feat(team): add team join audit trail

- add an audit requirement for successful team joins
- document the related change lifecycle
- keep the first version synchronous and idempotent
```

**测试评审**：2 条用例 | 需修复 0 项 | 已修复 0 项 | 可选优化 1 项
- 全部用例 OK，无需修复
