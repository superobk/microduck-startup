# 01 · 两天训练营 Runbook

本文把主 README 的步骤变成按小时执行的课程。每个时段都包含“操作、观察、产物、停止条件”。

# Day 1：从已训练策略到可训练环境

## 09:00–09:30 · 主机和目录准备

执行：

```bash
cd ~/microduck-startup
cp -n configs/experiment.env.example configs/experiment.env
bash scripts/00_preflight_host.sh
```

观察：

- GPU 数量与显存；
- driver 是否被 `nvidia-smi` 正确读取；
- DNS/GitHub；
- 可用磁盘；
- 当前 Node、Python、uv 状态。

产物：终端预检记录。

停止条件：`nvidia-smi` 不可用或 GitHub 无法访问。不要在网络/GPU 基础未解决时继续安装 RL。

## 09:30–10:15 · 固定版本下载

```bash
bash scripts/01_clone_upstreams.sh
cat work/state/upstream-versions.tsv
```

观察：五个 checkout 都处于 detached HEAD，SHA 与 `configs/upstreams.env` 完全一致。

产物：`work/state/upstream-versions.tsv`。

## 10:15–11:00 · 浏览器模拟器构建

```bash
bash scripts/02_setup_browser.sh
```

观察：

```text
npm ci 成功
Vite build 成功
dist/ 生成
```

错误处理：Node 太旧时升级 Node，不要用 `npm install --force` 绕过 engine/dependency 错误。

## 11:00–12:00 · 浏览器行为基线

终端 A：

```bash
bash scripts/03_run_browser.sh
```

Mac 浏览器通过 5173 tunnel 访问。

依次测试：

```text
walk → turn → stop
sit → stand
left kick → right kick
ground pick
legs → rollers → legs
人工让机器人跌倒 → automatic recovery
```

记录：

```text
浏览器帧率
control Hz（若 HUD 显示）
跌倒检测延迟
起身耗时
起身失败是否 reset
```

产物：`templates/day1-checklist.md` 的副本和一段基线视频。

## 13:00–14:00 · 阅读部署闭环

按顺序打开：

```text
MicroDuckModels/src/game/constants.js
MicroDuckModels/src/game/game.js
```

完成一张自己的图：

```text
keyboard/gamepad
  → command[13]
  → buildObs()[61]
  → ONNX
  → action[14]
  → DEFAULT_POSE + action * scale
  → data.ctrl
  → 4 × mj_step
```

必须回答：

1. 哪些行为是 learned policy？
2. 哪些是 hard-coded state machine？
3. 为什么 policy frequency 是 50 Hz？
4. 为什么换 ONNX 时不能改变 joint order？
5. last_action 为什么是 observation 的一部分？

## 14:00–15:00 · 安装官方 RL 环境

```bash
bash scripts/04_setup_rl.sh
```

观察：

```text
Python >=3.12,<3.13
Torch version
Torch CUDA build
CUDA available=True
GPU count
```

产物：完整 `.venv` 和 `uv.lock` 对应环境。

停止条件：Torch CUDA 为 False。不要先跑训练再排查。

## 15:00–16:00 · 任务注册与 CPU tests

```bash
bash scripts/05_rl_tests.sh
```

选择主 task：

```text
Mjlab-Velocity-Flat-MicroDuck
```

阅读：

```text
microduck_rl/AGENTS.md
microduck_rl/src/mjlab_microduck/tasks/microduck_velocity_env_cfg.py
```

产物：对 reward、DR、commands、termination 的初步注释。

## 16:00–16:45 · 官方 ONNX 原生基线

有桌面/OpenGL 时：

```bash
bash scripts/11_infer_official.sh
```

观察：

- input/output shape；
- 站立；
- command response；
- action；
- CSV 输出。

没有图形会话时，把这一步移到 Day 2 的 GNOME/XRDP session。

## 16:45–17:30 · RL smoke test

```bash
bash scripts/06_rl_smoke.sh
```

只检查工程闭环，不判断 gait。

通过：iteration 5 结束，无 NaN/shape exception。

## 17:30–18:00 · Day 1 验收

必须能口头解释：

```text
61D observation
13D command
14D action
50 Hz loop
BAM actuator
normalizer
policy switching
smoke test 的目的
```

不能解释的部分回到 `docs/00-system-and-code-map.md`。

---

# Day 2：训练、导出、评估和回灌

## 09:00–09:15 · 固定实验参数

查看：

```bash
cat configs/experiment.env
```

保存一个副本：

```bash
cp configs/experiment.env work/state/day2-experiment.env
```

第一轮：

```text
GPU=0
seed=42
envs=4096
iterations=1000
logger=tensorboard
```

## 09:15–09:30 · TensorBoard

终端 C：

```bash
bash scripts/19_tensorboard.sh
```

Mac 浏览器打开 `127.0.0.1:6006`。

## 09:30–12:00 · Walking 教学训练

终端 B：

```bash
bash scripts/07_train_walking.sh
```

每隔固定时间记录：

```text
iteration
mean reward
episode length
main tracking reward
fall/termination
entropy
KL
观察到的 gait
```

使用 `templates/experiment-log.md`。

不要因为 total reward 上升就提前宣布成功。检查主要 task term 是否同步增长。

## 12:00–13:00 · checkpoint 与 rollout 检查

```bash
bash scripts/08_find_checkpoint.sh
cat work/state/latest_checkpoint.txt
```

若尚未生成 checkpoint，继续训练到保存点。

## 13:00–13:30 · 官方 ONNX 导出

```bash
bash scripts/09_export_onnx.sh
```

观察：

```text
Written ...bootcamp_walk.onnx
input [1,61]
output [1,14]
metadata
sha256
PASS
```

## 13:30–14:30 · 官方 vs 自训练原生 MuJoCo

分别执行：

```bash
bash scripts/11_infer_official.sh
bash scripts/12_infer_custom.sh
```

使用相同 command 和相同观察窗口。

记录：

```text
是否站稳
forward response
turn response
fall count
恢复能力
动作抖动
头部偏差
```

## 14:30–15:30 · 回灌浏览器

```bash
bash scripts/13_install_policy_browser.sh
bash scripts/03_run_browser.sh
```

浏览器硬刷新。确认 Network 面板加载的是：

```text
bootcamp_walk.onnx
```

不是旧的 `BEST_alpha_walking.onnx`。

## 15:30–16:15 · 单变量 A/B

```bash
bash scripts/14_create_no_push_worktree.sh
```

检查 diff 只有一行开关变化。先做 no-push smoke，再决定是否长训。

## 16:15–17:00 · 机械模型关联

阅读：

```text
microduck-replica/README.md
microduck_rl/src/mjlab_microduck/robot/microduck_constants.py
microduck_rl/src/mjlab_microduck/robot/microduck/*.xml
```

把以下关系连起来：

```text
质量/惯量 → 物理
关节树 → observation/action order
执行器 → BAM
结构回差 → backlash model
头部质量 → gait/reward/DR
```

## 17:00–17:30 · 生成可追溯 manifest

```bash
bash scripts/15_record_manifest.sh
```

检查没有 credentials/token。

## 17:30–18:00 · 最终验收

通过条件：

```text
官方浏览器 baseline ✓
固定 upstream SHA ✓
Torch CUDA ✓
tests ✓
64×5 smoke ✓
model_*.pt ✓
61→14 ONNX ✓
native MuJoCo custom policy ✓
browser custom policy ✓
manifest ✓
A/B worktree 单变量 ✓
```
