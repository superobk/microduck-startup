# HANDOFF · macOS 控制端与 GPU 计算端

## 当前职责

`superobk/microduck-startup` 负责：

- 建立两端一致但独立的 `~/Microduck`；
- 固定官方/社区仓库版本；
- PPO/MuJoCo 安装、smoke、训练、导出、replay；
- 结构件、系统辨识和主控替代研究目录；
- GitHub/RSS 资讯；
- Hugging Face model bundle 和 duplicate Space；
- 跨 session 状态报告。

## 下一台机器的第一条命令

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
nano configs/machine.env
make sync-doctor
```

GPU 继续：

```bash
make preflight
make models-check
make rl-setup
make rl-test
make smoke
```

Mac 继续：

```bash
make sync-refresh
make sync-pull
make tunnel
```

## 同步不变量

```text
代码/配置/文档           GitHub
活动 PPO 数据和日志       GPU 本地
正式 ONNX/replay/preview Hugging Face + artifacts/published
临时 handoff             白名单 rsync
worktree/.git/.venv      不跨机器复制
```

一个 branch 同时只有一个写入者。`main` 只做 fast-forward 集成。

## RL 不变量

```text
61D actor observation
13D command
14D action
固定 joint order
0.005 s × 4 = 50 Hz
官方 exporter 包含 observation normalizer
PPO rollout 是 fresh on-policy data
rollout.npz 是固定评测，不是 PPO replay buffer
```

## 一天流水线

```bash
cp configs/one-day.env.example configs/one-day.env
nano configs/one-day.env
make one-day
```

恢复指定阶段：

```bash
bash scripts/one_day/run.sh replay --run-id RUN_ID
bash scripts/one_day/run.sh package --run-id RUN_ID
bash scripts/one_day/run.sh publish-model --run-id RUN_ID
bash scripts/one_day/run.sh publish-space --run-id RUN_ID
```

## HF 发布顺序

```text
本地 bundle
→ 个人 model repo
→ 个人 duplicate Space
→ build/keyboard/gamepad/mobile 验证
→ Community PR/Discussion
```

不要假定自己可以直接写
`pollen-robotics/microduck-simulator/main`。

## 每次结束前

```bash
cd ~/Microduck/startup
make manifest
make handoff
make workspace-status
```

GPU 还应把已选择的 run 放入：

```text
~/Microduck/artifacts/published/<RUN_ID>/
```

Handoff 人工补充：

```text
Active repository/branch:
Active worktree:
Run ID:
Checkpoint:
ONNX:
HF model repo:
HF duplicate Space:
Current blocker:
Next exact command:
Pass condition:
```
