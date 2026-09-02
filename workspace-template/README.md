# Microduck Workspace

这个目录是多个独立 Git 仓库、实验数据和硬件资料的共同容器，不是一个需要 `git init` 的 monorepo。

编排仓库位于：

```text
startup/
```

开始工作：

```bash
cd startup
make workspace-status
```

目录约定见 `startup/WORKSPACE.md`，跨 session 状态见 `notes/handoffs/LATEST.md`。
