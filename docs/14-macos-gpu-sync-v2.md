# 14 · macOS 与 GPU 工作站同步架构 v2

## 结论

原设计的核心——两端都建立 `~/Microduck`、每个上游保持独立 Git
仓库——是正确的；但“模型和报告主要依赖点对点 rsync”以及“macOS 需要
GNU `realpath -m`”并不是最优状态。

优化后的职责分层：

```text
GitHub control plane
  代码、配置、文档、实验分支、资讯快照

GPU compute plane
  PPO on-policy rollout、MuJoCo、checkpoint、原始日志、数据采集

Hugging Face artifact/registry plane
  已筛选 ONNX、checkpoint、preview.mp4、rollout.npz、metrics、manifest

SSH operator plane
  Mac 远程控制 GPU；端口转发；临时 handoff 与 inbox 使用白名单 rsync
```

这比“整个 `~/Microduck` 双向同步”安全，因为 `.git/worktrees`、虚拟环境、
活动训练日志和大型原始数据都包含设备相关状态或正在写入的文件。

## 两端第一次建立

### macOS

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
```

现在路径处理由 Python `Path.resolve(strict=False)` 完成，不再要求 Homebrew
GNU coreutils。仍建议安装新版 Git、rsync、uv 和 Node：

```bash
brew install git rsync uv node
```

编辑本机文件：

```bash
nano ~/Microduck/startup/configs/machine.env
```

示例：

```bash
MICRODUCK_ROLE="mac"
MICRODUCK_HOME="/Users/YOU/Microduck"
MICRODUCK_GPU_SSH="microduck-gpu"
MICRODUCK_GPU_HOME="/home/YOU/Microduck"
```

### Ubuntu GPU 工作站

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
```

本机配置：

```bash
MICRODUCK_ROLE="gpu"
MICRODUCK_HOME="/home/YOU/Microduck"
MICRODUCK_GPU_SSH=""
MICRODUCK_GPU_HOME=""
```

## SSH 联系

Mac 的 `~/.ssh/config`：

```sshconfig
Host microduck-gpu
    HostName GPU_PRIVATE_OR_TAILSCALE_IP
    User YOUR_GPU_USER
    IdentityFile ~/.ssh/id_ed25519_microduck
    IdentitiesOnly yes
    ServerAliveInterval 30
    ServerAliveCountMax 4
    ForwardAgent no
```

检查：

```bash
cd ~/Microduck/startup
make sync-doctor
```

开启浏览器、TensorBoard 和 Viser 隧道：

```bash
make tunnel
```

本地入口：

```text
http://127.0.0.1:5173  browser simulator
http://127.0.0.1:6006  TensorBoard
http://127.0.0.1:8080  Viser
```

GPU 长任务放入 tmux：

```bash
ssh microduck-gpu
tmux new-session -A -s microduck
```

## 日常同步

### 代码

代码始终通过 GitHub：

```bash
cd ~/Microduck/startup
git fetch origin
git switch main
git merge --ff-only origin/main
make workspace-sync
```

不要让 Mac 和 GPU 同时写同一个 branch。推荐：

```text
mac/docs-*
mac/hardware-*
gpu/ppo-*
gpu/sim-*
```

`main` 是集成分支，并且资讯机器人会写入它，所以本地工作应放在 feature
branch。

### GPU → Mac 的白名单文件

```bash
make sync-pull
```

只同步：

```text
notes/handoffs/
notes/shared/
experiments/reports/
experiments/manifests/
artifacts/published/
```

第一次预览：

```bash
bash scripts/sync/pull_from_gpu.sh --dry-run
```

命令故意不使用 `--delete`。

### Mac → GPU

```bash
cp FILE ~/Microduck/artifacts/to-gpu/
make sync-push
```

只进入：

```text
GPU: ~/Microduck/artifacts/inbox-from-mac/
```

GPU 操作员检查 hash 和内容后再移动。

### 不同步

```text
.git/
experiments/worktrees/
official/microduck_rl/logs/
datasets/raw/
.venv/
node_modules/
活动 checkpoint 临时文件
HF cache
```

Worktree 跨机器传递的是 commit/branch，不是 worktree 目录。

## 自动刷新

### macOS launchd

```bash
make macos-agent-install
```

它在登录时及每 6 小时执行：

```text
scripts/sync/refresh_local.sh
```

内容：

1. 安全 fast-forward `startup/main`；
2. fetch 所有官方和社区 remote；
3. 拉取 GPU 的 handoff、报告和 `artifacts/published`。

日志：

```bash
tail -f ~/Library/Logs/Microduck/refresh.stdout.log
tail -f ~/Library/Logs/Microduck/refresh.stderr.log
```

### GPU systemd user timer

GitHub/RSS 资讯：

```bash
make intelligence-timer-install
```

训练不要由这个 timer 自动触发。PPO run 应由明确的 run ID、配置和人工验收启动。

## 产物发布

点对点 rsync 只用于快速交接。正式可复用产物应发布到 Hugging Face model
repo：

```text
policy.onnx
checkpoint.pt
preview.mp4
rollout.npz
metrics.json
training/{env.yaml,agent.yaml}
provenance.json
manifest.json
SHA256SUMS
```

这样 Mac、GPU、其他工作站和 HF Space 都从同一内容寻址、版本化来源读取。

## 冲突处理

1. 停止在两端继续编辑同一 branch；
2. 两端 `git status`；
3. 由 branch owner commit/push；
4. 另一端 `git fetch`，重新建立本地 worktree；
5. 模型冲突不人工 merge：以 run ID + SHA-256 发布为新版本；
6. handoff 中写清 active branch、run ID、checkpoint 和下一条命令。
