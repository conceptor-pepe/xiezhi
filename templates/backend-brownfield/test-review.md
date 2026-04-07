# 测试专家白盒审计记录: <change-name>

> 本文件用于记录测试专家视角的白盒评审、风险结论、发布建议和问题闭环。

## Policy Sources

- test review policy: `docs/specClawd/policies/test-review-policy.md`
- coding standards policy: `docs/specClawd/policies/coding-standards.md`
- repo-specific test focus used in this change: `<none / path / note>`

## 判定规则

- `pass`：从代码实现和已有证据看，该测试点当前没有发现阻塞性问题。
- `risk`：从代码实现看大概率可行，但仍缺少关键验证证据，例如真实环境、联调、迁移回放、并发压测或外部依赖验证。
- `fail`：已经发现明确缺陷、阻塞风险或与需求/设计不一致的问题。

说明：

- 本文件默认记录的是测试专家视角的白盒评审，不等价于真实环境已经完整验收通过。
- `Evidence` 应优先引用真实命令、测试名、代码路径检查、日志或检查结论，而不是只写“已验证”。

## 测试用例设计

| Case ID | Task IDs | Requirement IDs | Risk IDs | Scenario | Preconditions | Steps | Expected Result | White-Box Focus |
|--------|----------|-----------------|----------|---------------|-------|-----------------|-----------------|
| `CASE-001` | `TASK-001` | `REQ-001` | `RISK-001` | <scenario> | <preconditions> | <steps> | <expected> | <branch / error path / boundary> |

## 按用例评审结果

| Case ID | Result | Evidence | Issues Found |
|---------|--------|----------|--------------|
| `CASE-001` | `<pass/fail/risk>` | `<command / reasoning / inspection>` | `<none or REV-001 / TEST-RISK-001>` |

## 白盒覆盖检查

- branch coverage focus: `<covered / weak>`
- error path focus: `<covered / weak>`
- boundary value focus: `<covered / weak>`
- idempotency / retry focus: `<covered / weak / N/A>`
- transaction / rollback focus: `<covered / weak / N/A>`
- observability focus: `<covered / weak>`

## 需修复（Critical）

- `TEST-RISK-001`: <critical issue, or state none>

## 已修复

- `<already fixed item>`

## 可选优化（Suggestion）

- `<optional follow-up>`

## 测试功能结论

- product conclusion: `<requirement behavior OK or not>`
- architect conclusion: `<critical technical risk remains or not>`
- senior engineer conclusion: `<code path confidence>`
- tester conclusion: `<release recommendation>`
