# 15 · 一天完成 PPO 数据采集、训练、测试与 Replay

## 目标边界

一天流程验证的是完整工程链：

```text
固定上游版本
→ CUDA/mjlab/MuJoCo 环境
→ 64×5 smoke
→ PPO 自动采集 fresh on-policy rollout 并更新
→ checkpoint
→ 官方 exporter 生成 ONNX
→ headless evaluation replay
→ rollout.npz + preview.mp4 + metrics.json
→ Hub-ready bundle
```

PPO 的训练数据由当前策略在线生成并在 RSL-RL 内部消费；它不是先生成一个
CSV replay buffer 再反复训练。脚本额外保存的 `rollout.npz` 是训练后的固定评测
replay，用于复核和发布，不回灌给 PPO。

一天能完整跑通流程，不代表任意新动作都会在固定 iteration 数内收敛。新动作的
reward、初始状态和 curriculum 仍可能需要多轮实验。

## 机器

主流程在 Ubuntu NVIDIA GPU 工作站执行。Mac 负责：

- 阅读代码和报告；
- SSH/tmux 控制；
- 通过隧道查看 TensorBoard；
- 拉取已发布 bundle；
- Review HF duplicate Space。

## 0. 工作区

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
make sync-doctor
```

## 1. 选择 Profile

```bash
cp configs/one-day.env.example configs/one-day.env
nano configs/one-day.env
```

最快验证完整链：

```bash
ONE_DAY_PROFILE="walking"
```

第一次复刻短动作：

```bash
ONE_DAY_PROFILE="roulade"
```

内置 profile：

| Profile | Task | HF 现有 slot | 起始预算 |
|---|---|---|---:|
| `walking` | `Mjlab-Velocity-Flat-MicroDuck` | `walk` | 1000 iters |
| `sitstand` | `Mjlab-SitStand-Flat-MicroDuck` | `sitstand` | 2500 |
| `roulade` | `Mjlab-Roulade-Flat-MicroDuck` | `roll` | 4000 |
| `ball-kick` | `Mjlab-BallKick-Flat-MicroDuck` | `kickR` | 3000 |
| `roller-crouch` | `Mjlab-RollerCrouch-Flat-MicroDuck` | `crouch` | 3000 |
| `ground-pick` | `Mjlab-GroundPick-Flat-MicroDuck` | 无 | 3000 |

这些是启动预算，不是收敛保证。

4×4090 工作站的第一次执行仍用：

```bash
ONE_DAY_GPU="0"
```

先证明单卡闭环。其余卡随后用于独立 seed，而不是把同步分布式故障混入第一轮。

## 2. 一条命令

```bash
cd ~/Microduck/startup
make one-day
```

等价于：

```bash
bash scripts/one_day/run.sh all
```

阶段：

```text
setup
smoke
train
export
replay
package
```

如果配置了 HF repo，还会继续发布。

## 3. 分阶段执行

```bash
bash scripts/one_day/run.sh setup
bash scripts/one_day/run.sh smoke
bash scripts/one_day/run.sh train
bash scripts/one_day/run.sh export
bash scripts/one_day/run.sh replay
bash scripts/one_day/run.sh package
```

脚本把最新 run ID 写入：

```text
~/Microduck/experiments/runs/one-day/LATEST_RUN_ID
```

恢复指定 run：

```bash
bash scripts/one_day/run.sh replay --run-id walking-YYYYMMDDTHHMMSSZ
```

## 4. 一天时间表

```text
08:30–09:15  bootstrap、uv sync、CUDA 检查、tests
09:15–09:30  官方/当前策略 baseline 与 profile 检查
09:30–09:45  64 env × 5 iteration smoke
09:45–14:00  PPO 训练，TensorBoard 观察
14:00–15:00  checkpoint 选择与 headless replay
15:00–15:30  官方 export.py → 61D→14D ONNX
15:30–16:00  固定 replay + MP4 + metrics
16:00–17:00  duplicate Space build/test
17:00–18:00  发布 model repo、manifest、handoff
```

训练时间取决于 profile、GPU 和是否已经有缓存；不要以时间替代验收。

## 5. TensorBoard

GPU 另一终端：

```bash
cd ~/Microduck/startup
make tensorboard
```

Mac：

```bash
make tunnel
```

打开：

```text
http://127.0.0.1:6006
```

至少观察：

```text
mean reward
episode length
主要 task reward
termination/fall
entropy
KL
value loss
learning rate
```

总 reward 上升而动作视频错误，仍判定失败。

## 6. Replay 采集内容

`scripts/one_day/replay_checkpoint.py` 使用 task 的 play config、一个环境和本地
checkpoint，保存：

```text
observations  [N,61]
actions       [N,14]
commands      [N,13]
rewards       [N]
dones         [N]
step_index    [N]
preview.mp4
metrics.json
```

它通过 mjlab 的 `VideoRecorder` 在 headless EGL 环境录制 env 0，并使用与
`play` 相同的 actor-only checkpoint 加载方式。

检查：

```bash
RUN_ID="$(cat ~/Microduck/experiments/runs/one-day/LATEST_RUN_ID)"
RUN=~/Microduck/experiments/runs/one-day/$RUN_ID

cat "$RUN/replay/metrics.json"

cd "$RUN/replay"
python3 - <<'PY'
import numpy as np
x = np.load("rollout.npz")
for k in x.files:
    print(k, x[k].shape, x[k].dtype)
assert x["observations"].shape[1] == 61
assert x["actions"].shape[1] == 14
PY
```

## 7. Bundle

结果：

```text
~/Microduck/artifacts/published/<RUN_ID>/
├── README.md
├── policy.onnx
├── checkpoint.pt
├── preview.mp4
├── rollout.npz
├── metrics.json
├── training/
│   ├── env.yaml
│   ├── agent.yaml
│   └── upstreams.env
├── provenance.json
├── manifest.json
└── SHA256SUMS
```

验证：

```bash
cd ~/Microduck/artifacts/published/<RUN_ID>
sha256sum -c SHA256SUMS
```

macOS 使用：

```bash
shasum -a 256 -c SHA256SUMS
```

## 8. 验收

- [ ] 固定 upstream SHA；
- [ ] Torch CUDA 为 True；
- [ ] tests 通过；
- [ ] smoke 到 iteration 5 且无 NaN；
- [ ] 长训练 run name 与 run ID 对应；
- [ ] 选择的不是 smoke checkpoint；
- [ ] ONNX 为 `[1,61] → [1,14]`；
- [ ] replay observation/action shape 正确；
- [ ] `preview.mp4` 中动作符合目标；
- [ ] metric 与视频一致；
- [ ] bundle hash 全部通过；
- [ ] HF duplicate Space 本地 `npm ci && npm run build` 通过。

## 9. 新动作开发

真正新增一个当前 Space 没有的动作时：

1. 从最接近的 task 复制配置；
2. 保持 61D observation / 14D action；
3. 在独立 worktree 修改 reward、reset、termination、curriculum；
4. 写 config/reward 不变量测试；
5. smoke；
6. 训练；
7. replay；
8. 先发布 model repo；
9. 再新增 Space 的 policy slot、trigger、command encoding、duration、exit/fallback 和 HUD。

不要仅把一个 ONNX 文件复制到 Space 后就认为新动作已集成。
