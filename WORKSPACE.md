# Microduck 多仓库工作区 v2

本仓库同时是：

1. 可重复的 Microduck PPO / MuJoCo startup runbook；
2. macOS 控制端与 Ubuntu GPU 计算端的工作区编排器；
3. GitHub、Hugging Face 与本地重型产物之间的发布控制面；
4. 跨 session handoff 和资讯自动化入口。

## 推荐架构

```text
GitHub
  startup、实验代码、配置、文档、资讯快照
        │
        ├───────────────┐
        ▼               ▼
macOS ~/Microduck     GPU ~/Microduck
控制/Review/浏览器     PPO/MuJoCo/数据/导出
        │               │
        └── SSH/tmux ───┘
                │
                ├── 白名单 rsync：handoff、报告、published bundle
                └── Hugging Face：正式模型、replay、preview、Space
```

两台机器分别 clone，不进行整个目录的双向文件同步。

## 最终目录

```text
~/Microduck/
├── startup/
├── official/
│   ├── microduck/
│   └── microduck_rl/
├── community/
│   ├── MicroDuckModels/
│   ├── microduck-replica/
│   └── awesome-microduck/
├── hardware/
│   ├── mechanical/{references,measurements,printable,validation}/
│   ├── electronics/
│   ├── controller-alternatives/
│   └── bom/
├── simulation/
│   ├── envs/
│   ├── browser/
│   ├── policies/{official,custom}/
│   ├── checkpoints/
│   └── mujoco/{models,scenes,exports,system-id}/
├── datasets/{raw,curated,manifests,frozen-eval}/
├── experiments/{runs,worktrees,manifests,reports}/
├── artifacts/{published,inbox-from-mac,to-gpu}/
├── registry/huggingface/{model-cache,space-staging}/
├── intelligence/{tracked,local,exports}/
├── notes/{handoffs,shared}/
└── sync/state/
```

每个上游仍是独立 Git 仓库；`~/Microduck` 不是 monorepo。

## 初始化

两端都执行：

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
```

Bootstrap 现在原生兼容 macOS 和 Linux，不再要求 GNU `realpath -m`。

随后编辑本机、gitignored 配置：

```text
configs/machine.env
```

macOS：

```bash
MICRODUCK_ROLE="mac"
MICRODUCK_HOME="/Users/YOU/Microduck"
MICRODUCK_GPU_SSH="microduck-gpu"
MICRODUCK_GPU_HOME="/home/YOU/Microduck"
```

GPU：

```bash
MICRODUCK_ROLE="gpu"
MICRODUCK_HOME="/home/YOU/Microduck"
```

检查：

```bash
make sync-doctor
make workspace-status
```

## 同步规则

### GitHub：代码与控制面

```bash
make sync-refresh
make workspace-sync
make workspace-status
```

本地 `main` 只做 fast-forward。实验修改放到 feature branch 和
`experiments/worktrees/`。

### rsync：短期交接

Mac 拉取：

```bash
make sync-pull
```

只处理：

```text
notes/handoffs
notes/shared
experiments/reports
experiments/manifests
artifacts/published
```

Mac 上传：

```bash
make sync-push
```

只进入 GPU 的 `artifacts/inbox-from-mac`。

### Hugging Face：正式发布物

选中的 run 打包成：

```text
policy.onnx
checkpoint.pt
preview.mp4
rollout.npz
metrics.json
resolved config
provenance
manifest
SHA256SUMS
```

随后发布到个人 model repo，并在个人 duplicate Space 验证。见
[docs/16-huggingface-space-integration.md](docs/16-huggingface-space-integration.md)。

## PPO / MuJoCo

主训练仓库：

```text
~/Microduck/official/microduck_rl
```

已有封装：

```bash
make rl-setup
make rl-test
make smoke
make tensorboard
make train
make checkpoint
make export
```

一天完整链：

```bash
cp configs/one-day.env.example configs/one-day.env
make one-day
```

见 [docs/15-one-day-ppo-e2e.md](docs/15-one-day-ppo-e2e.md)。

## 服务联系

Mac：

```bash
make tunnel
```

打开：

```text
5173  browser simulator
6006  TensorBoard
8080  Viser
```

GPU 长命令：

```bash
tmux new-session -A -s microduck
```

## 定时更新

共享资讯由 GitHub Actions 每六小时更新。GPU 本地：

```bash
make intelligence-timer-install
```

Mac 控制端：

```bash
make macos-agent-install
```

macOS launchd 会安全更新 startup、fetch 上游，并拉取白名单交接文件。

## Handoff

每次 GPU session 结束：

```bash
make manifest
make handoff
make workspace-status
```

Mac：

```bash
make sync-pull
cat ~/Microduck/notes/handoffs/LATEST.md
```

更完整的同步设计见
[docs/14-macos-gpu-sync-v2.md](docs/14-macos-gpu-sync-v2.md)。
