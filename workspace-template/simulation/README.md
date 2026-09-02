# Simulation

- `envs/microduck_rl`：官方 PPO/mjlab/MuJoCo Warp 环境；
- `browser/MicroDuckModels`：浏览器 MuJoCo + ONNX；
- `policies/official`：官方发布策略；
- `policies/custom`：自己的 ONNX；
- `checkpoints`：筛选后的 `.pt`；
- `mujoco/models`：不覆盖上游的本地模型变体；
- `mujoco/scenes`：评测场景；
- `mujoco/system-id`：实体数据拟合结果；
- `mujoco/exports`：展开或导出的场景。

训练命令从 `../startup` 的 Makefile 启动，以保持参数与 manifest 一致。
