# 06 · Push / No-Push 单变量 A/B

## 目的

学习怎样做“可归因”的 RL 实验，而不是为了在两天内证明某个最终结论。

## 变量

A：

```python
ENABLE_VELOCITY_PUSHES = True
```

B：

```python
ENABLE_VELOCITY_PUSHES = False
```

其他全部固定。

## 创建 B worktree

```bash
bash scripts/14_create_no_push_worktree.sh
```

检查：

```bash
git -C work/variants/microduck_rl-no-push diff
```

必须只有目标开关变化。

## 先做 smoke

```bash
cd work/variants/microduck_rl-no-push
uv sync
CUDA_VISIBLE_DEVICES=0 uv run train Mjlab-Velocity-Flat-MicroDuck \
  --env.scene.num-envs 64 \
  --agent.max_iterations 5 \
  --agent.logger tensorboard \
  --agent.run-name nopush_smoke \
  --agent.seed 42
```

## 长训练

与 A 使用完全相同：

```text
upstream commit
task
envs
iterations
seed
GPU model
network
PPO
rewards
commands
terrain
other DR toggles
```

## 假设

```text
Push ON：更强 disturbance exposure，可能慢一些、gait 更紧张，但恢复更好。
Push OFF：训练更容易、gait 可能更平滑，但外部冲击下脆弱。
```

## 评估 battery

每个 checkpoint：

1. zero command 站立；
2. forward 10 s；
3. turn left/right；
4. 10 次相同分布的随机 push；
5. 记录跌倒、恢复和恢复时间；
6. 对 action-rate 和 body tilt 做统计；
7. 看视频中的 gait，不只看 reward。

## 3-seed 扩展

正式比较：

```text
42
43
44
```

4×48 GB GPU 可同时跑：

```text
GPU0 seed42 A
GPU1 seed43 A
GPU2 seed44 A
GPU3 先保留给评估或 B smoke
```

然后再跑 B，或按资源安排 A/B 交错。不要让 A 总在冷机、B 总在高负载条件下运行；记录 GPU 和系统负载。

## 报告格式

```text
Hypothesis
Single changed variable
Pinned commit
Run matrix
Training curves
Evaluation table
Videos
Failure cases
Conclusion with uncertainty
Next experiment
```
