# 11 · 独立 Microduck 工作区

完整设计见根目录 [WORKSPACE.md](../WORKSPACE.md)。

推荐入口：

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
make workspace-bootstrap
make workspace-status
```

## 设计原则

1. 外层 `~/Microduck` 是容器目录，不是 monorepo；
2. 官方与社区仓库各自保留 `.git`；
3. 固定 checkout 用于复现，定期 fetch 用于发现更新；
4. 长期修改使用 `experiments/worktrees`；
5. 模型、数据和视频不提交到 startup；
6. 机械参考通过符号链接暴露，不重新复制上游衍生资产；
7. 旧版 startup 脚本继续通过 `startup/work/upstream` 路径工作。

## 日常节奏

```bash
make workspace-sync
make workspace-status
make intelligence-refresh
make handoff
```

升级某个 upstream 时，先建 worktree、跑 tests/smoke/frozen evaluation，再更新固定 SHA；不要因为远端有新提交就自动移动实验基线。
