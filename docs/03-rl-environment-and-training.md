# 03 · 官方 RL 环境与训练

## 为什么使用原生安装而不是先上 Docker

第一轮的目标是减少变量。原生 `uv sync` 与上游 CI/HF Jobs 更接近，CUDA、Torch、Warp 出错时日志也更直接。Docker 可以在跑通后固化，不应成为第一天额外的故障层。

## 安装

```bash
bash scripts/04_setup_rl.sh
```

上游固定版本要求 Python `>=3.12,<3.13`，并锁定 mjlab、Warp、Torch 和 BAM 相关依赖。不要在 `.venv` 外手工 `pip install` 修补后又不记录；如果必须临时修补，应立即写入 manifest 和实验日志。

## CUDA 验证的优先级

以此为准：

```python
import torch
print(torch.cuda.is_available())
print(torch.cuda.device_count())
```

`nvidia-smi` 正常只说明驱动可见，不代表 Torch wheel、CUDA runtime 与 Warp 路径已正确解析。

## 任务配置如何组成环境

以 walking 为例：

```text
microduck_velocity_env_cfg.py
  ├─ robot model
  ├─ actuator
  ├─ action manager
  ├─ command generator
  ├─ observations/noise
  ├─ rewards
  ├─ events/reset
  ├─ domain randomization
  ├─ termination
  ├─ curricula
  └─ RSL-RL PPO runner config
```

Custom reward/event 实现在 `tasks/mdp.py`。

## Sim2real 重点

### BAM actuator

不是理想 PD，而是更接近 XL330 的电压、反电动势和摩擦模型。

### Domain randomization

walking 配置包括或可包括：

```text
trunk/head CoM
mass/inertia
joint friction
armature
battery voltage/sag
command delay
IMU orientation
encoder bias
velocity pushes
```

不要一开始把所有 range 放大。DR 过强会让策略只学“永久紧张的保命 gait”。

### Backlash

`-Backlash-` variants 在 14 个 servo joints 串联被动回差 hinge，并让 encoder observation 读取回差后的输出侧视角。

## PPO 数据规模

默认 runner 每个 env 每 iteration 收集 24 steps。若使用 4096 env：

```text
4096 × 24 = 98,304 transitions / iteration
```

1000 iterations 约收集 9,830 万 transition。实际 wall time 取决于 GPU、CPU、环境配置与当前 upstream。

## 为什么先 smoke

```bash
bash scripts/06_rl_smoke.sh
```

`64 env × 5 iteration` 用很低成本暴露：

```text
config error
joint selector error
shape mismatch
reward exception
NaN
CUDA/Warp interop
reset/termination error
```

smoke 的 gait 没有评价意义。

## 正式教学训练

```bash
bash scripts/07_train_walking.sh
```

第一轮只允许调 `TRAIN_ENVS` 解决 OOM：

```text
4096 → 2048 → 1024 → 512
```

不要同时改：

```text
reward weights
network sizes
PPO hyperparameters
terrain
DR ranges
action scale
```

## 4×48 GB GPU 的正确起步方式

第一轮：

```text
GPU 0：主线 walking
GPU 1–3：空闲
```

主线通过后，优先使用 4 张卡跑四个独立 seed，而不是立即做一个多节点/多进程分布式 run。独立 seed 更容易比较、失败隔离和复现。

示意：

```bash
CUDA_VISIBLE_DEVICES=0 ... --agent.seed 42 --agent.run-name seed42
CUDA_VISIBLE_DEVICES=1 ... --agent.seed 43 --agent.run-name seed43
CUDA_VISIBLE_DEVICES=2 ... --agent.seed 44 --agent.run-name seed44
CUDA_VISIBLE_DEVICES=3 ... --agent.seed 45 --agent.run-name seed45
```

每个任务仍使用单 GPU。先确认磁盘日志路径和总 CPU/RAM 能支撑四份环境。

## 看训练曲线的方法

### 必看

```text
Mean reward
Episode length
main task tracking terms
termination/fall metrics
entropy
KL
value loss
learning rate
```

### Reward sign 检查

上游同时存在两种 penalty 函数风格：

```text
函数返回 ≥0 的 cost       → 通常配负 weight
函数自身返回 ≤0 的 penalty → 通常配正 weight
```

若双重取负，策略会主动“刷违规”。每次 run 都检查 penalty 的 weighted episode reward 是否保持非正。

### Reward hacking

RL 只优化文字定义的 reward：

```text
用头撑地代替站立
提前到达目标后持续领 jackpot
停着不动规避动作成本
在错误姿势里刷正奖励
```

任何看似“reward 很高但视频不对”的情况，都先量化 rollout，不要立即增加更多小 penalty。

## Checkpoint

```bash
bash scripts/08_find_checkpoint.sh
```

脚本从 `logs/rsl_rl/**/model_*.pt` 中按修改时间选择最新文件。导出前核对它属于正确 run，而不是 smoke run。

更稳妥的做法：把目标 checkpoint 的绝对路径显式传给 export 脚本。
