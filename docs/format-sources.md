# Format Sources

Speclawd should not invent artifact formats ad hoc. The repository templates should follow the format sources below.

## Source Of Truth By Artifact

- `design.md`
  - follow the phase 0.5 `Step 1 -> Step 4` structure used by repository design source files
- `commit-summary.md`
  - follow the commit summary rule format used by the repository workflow rules
- `test-review.md`
  - follow the structure:
    - `测试用例设计`
    - `按用例评审结果`
    - `需修复（Critical）`
    - `已修复`
    - `可选优化（Suggestion）`
    - `测试功能结论`
- `review.md`
  - findings first, then checked risks, residual risks, and review decision
- `change.md`
  - use the fixed sections:
    - `背景`
    - `范围`
    - `非目标`
    - `影响面`
    - `风险`
    - `回滚思路`
- `tasks.md`
  - use numbered phases and checkbox tasks
  - each task must be a smallest shippable slice with requirement, design, acceptance, test, and commit boundary

## Template Discipline

- if a repository already has a stronger artifact format, prefer that format over a generic template
- example files must evolve together with templates
- verification scripts must support the canonical artifact formats that templates generate
- traceability IDs should be stable across artifacts: `REQ-*`, `DES-*`, `TASK-*`, `REV-*`, `CASE-*`
