# Microduck 多仓库工作区

本仓库现在同时承担两种角色：

1. **Startup runbook**：复现浏览器仿真、PPO、MuJoCo、checkpoint、ONNX 和机械逆向；
2. **Workspace orchestrator**：在 GPU 工作站建立一个独立的 `~/Microduck` 容器目录，管理官方仓库、社区仓库、机械资料、数据集、实验、产物和资讯快照。

## 建议的最终目录

```text
~/Microduck/
├── startup/                         # superobk/microduck-startup，本仓库
├── official/
│   ├── microduck/                   # 官方 runtime、策略、实体端代码
│   └── microduck_rl/                # 官方 PPO + mjlab + MuJoCo Warp
├── community/
│   ├── MicroDuckModels/             # 浏览器 MuJoCo + ONNX
│   ├── microduck-replica/            # 结构件、装配图、CAD 逆向
│   └── awesome-microduck/            # 社区导航
├── hardware/
│   ├── mechanical/
│   │   ├── references/              # 指向官方资产和 replica 的符号链接
│   │   ├── measurements/            # 实测尺寸、质量、惯量与公差
│   │   ├── printable/               # 自己修正后的可打印件
│   │   └── validation/              # 试装照片、问题和验收结果
│   ├── electronics/                 # HAT、IMU、供电和接口研究
│   ├── controller-alternatives/     # 主控平替资料与 bring-up
│   └── bom/                         # BOM 与采购快照
├── simulation/
│   ├── envs/microduck_rl -> ../../official/microduck_rl
│   ├── browser/MicroDuckModels -> ../../community/MicroDuckModels
│   ├── policies/official -> ../../official/microduck/policies
│   ├── policies/custom/
│   ├── checkpoints/
│   └── mujoco/
│       ├── models/
│       ├── scenes/
│       ├── exports/
│       └── system-id/
├── datasets/
│   ├── raw/
│   ├── curated/
│   ├── manifests/
│   └── frozen-eval/
├── experiments/
│   ├── runs/
│   ├── worktrees/
│   ├── manifests/
│   └── reports/
├── artifacts/                       # ONNX、视频、CSV、图表；默认不进 Git
├── intelligence/
│   ├── tracked -> ../startup/intelligence
│   ├── local/                       # GPU 机本地定时任务输出
│   └── exports/
└── notes/
    └── handoffs/
```

每个上游保持为独立 Git 仓库；`~/Microduck` 本身不是 monorepo。这样可以分别固定 SHA、查看 dirty state、创建 worktree，并保留各自许可证和历史。

## 第一次建立工作区

从任意目录开始：

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh
```

也可以指定其他磁盘：

```bash
bash scripts/workspace/bootstrap.sh /data/Microduck
```

脚本会：

- 创建上述目录和说明文件；
- 按 `configs/workspace-repos.json` 克隆官方与社区仓库；
- 对第一轮复现仓库 checkout 固定提交；
- 将现有 `startup/work/upstream/*` 链接到独立仓库，保持旧 runbook 全部可用；
- 建立 MuJoCo、策略和机械参考的符号链接；
- 不覆盖已有普通目录，不重置 dirty repository。

完成后：

```bash
cd ~/Microduck/startup
make workspace-status
make preflight
make rl-setup
make rl-test
make smoke
```

## 同步策略

“保持最新”和“保证可复现”被明确分开：

```text
checkout HEAD     固定在已验证 SHA，用于实验复现
origin/main       定期 fetch，用于观察上游变化
intelligence      定时记录 commits/releases/PRs/issues
实验升级          在独立 worktree 中显式进行
```

只抓取远端而不修改当前实验：

```bash
make workspace-sync
```

查看本地状态和远端 HEAD：

```bash
bash scripts/workspace/status.sh ~/Microduck --remote
```

把所有干净仓库重新对齐固定 SHA：

```bash
bash scripts/workspace/sync.sh ~/Microduck --pins
```

该命令不会覆盖有未提交修改的仓库。

## PPO / MuJoCo 工作路径

主训练仓库：

```text
~/Microduck/official/microduck_rl
```

兼容旧手册的路径：

```text
~/Microduck/startup/work/upstream/microduck_rl
```

两者指向同一 checkout。建议从 startup 调用已有封装：

```bash
cd ~/Microduck/startup
make rl-setup
make rl-test
make smoke
make tensorboard
make train
make checkpoint
make export
```

自定义策略、checkpoint 和 scene 分别放在：

```text
simulation/policies/custom/
simulation/checkpoints/
simulation/mujoco/scenes/
```

长期实验不要直接修改固定 checkout；在 `experiments/worktrees/` 创建 worktree。

## 资讯自动化

GitHub Actions 每六小时运行一次：

```text
.github/workflows/intelligence-refresh.yml
```

默认跟踪官方和三个社区仓库。结果写入：

```text
startup/intelligence/snapshots/latest.json
startup/intelligence/history/YYYY/MM/YYYY-MM-DD.json
startup/intelligence/digests/latest.md
```

社交账号没有被臆测写死。编辑 `configs/intelligence-sources.json`，启用一个 RSS/Atom、YouTube Atom、Mastodon RSS、Bluesky feed bridge 或合规 API feed。X/Twitter 建议通过官方 API或自己控制的 RSSHub 实例接入，不使用脆弱的匿名 HTML 抓取。

GPU 工作站也可以安装本地 user timer：

```bash
make intelligence-timer-install
```

本地 timer 输出到 `~/Microduck/intelligence/local`，不会把 startup 仓库弄脏。

## Session handoff

每次长实验结束前执行：

```bash
make handoff
```

生成：

```text
~/Microduck/notes/handoffs/LATEST.md
```

其中包括 GPU、磁盘、仓库 SHA、dirty state、最新 checkpoint/ONNX、资讯状态和下一步建议；不会导出环境变量或凭据。

详细交接要求见 [HANDOFF.md](HANDOFF.md)。
