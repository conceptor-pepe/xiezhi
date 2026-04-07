# 快速开始

## 1. 初始化仓库

```bash
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield
```

如果你想要更轻量的安装方式，可以使用：

```bash
speclawd/install/init.sh --target /path/to/repo --profile minimal --tool none
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
speclawd/install/init.sh --target /path/to/repo --profile go-service --tool claude,krio
speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,copilot,claude,krio
```

## 2. 启动工作流

```bash
/path/to/repo/scripts/speclawd-run.sh start add-team-credit-flow
```

如果你只想单独创建 change，也可以直接使用：

```bash
/path/to/repo/scripts/speclawd-new-change.sh add-team-credit-flow
```

## 3. 在实现前先准备方案

使用你的工具适配命令：

- `speclawd:run`
- `speclawd:start`
- `speclawd:continue`
- `speclawd:approve`
- 或简写：`specld:run`、`specld:start`、`specld:next`、`specld:approve`

推荐优先把 `speclawd:run / specld:run` 作为单入口，再由工具根据状态决定是 `start`、`approve`、`next` 还是 `exec`。

适配器安装方式和目录说明见：

- `docs/adapters.md`
- `docs/zh-CN/cursor-usage.md`

然后补齐这些核心文件：

- `spec-delta.md`
- `design.md`
- `tasks.md`
- `review.md`
- `test-review.md`
- `error-memory.md`

## 4. 交付前执行校验

```bash
/path/to/repo/scripts/speclawd-verify.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```

## 5. 归档前执行检查

```bash
/path/to/repo/scripts/speclawd-archive.sh /path/to/repo/docs/changes/<date>-add-team-credit-flow
```
