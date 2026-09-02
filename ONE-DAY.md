# Microduck 一天 PPO 复现入口

GPU 工作站：

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck

cp configs/one-day.env.example configs/one-day.env
nano configs/one-day.env

make sync-doctor
make one-day
```

最快闭环：

```bash
ONE_DAY_PROFILE="walking"
```

第一次短动作：

```bash
ONE_DAY_PROFILE="roulade"
```

输出：

```text
~/Microduck/experiments/runs/one-day/<RUN_ID>/
~/Microduck/artifacts/published/<RUN_ID>/
```

发布：

```bash
make one-day-publish-model
make one-day-publish-space
```

完整解释：

- [一天 PPO 数据、训练、Replay](docs/15-one-day-ppo-e2e.md)
- [Hugging Face Space 集成](docs/16-huggingface-space-integration.md)
- [Mac/GPU 同步 v2](docs/14-macos-gpu-sync-v2.md)
