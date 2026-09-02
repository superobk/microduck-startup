# HANDOFF · GPU 工作站继续深化

## 当前仓库职责

`superobk/microduck-startup` 是工作区编排与复现手册，不重新托管上游大模型、STL、MJCF 或完整 Git 历史。它负责：

- 建立 `~/Microduck` 多仓库工作区；
- 固定第一轮上游 SHA；
- PPO/MuJoCo 环境安装、测试、训练、导出与回灌；
- 机械参考链接与结构件验证目录；
- GitHub/RSS 资讯更新；
- 生成下一次 session 可读的 handoff。

## GPU 工作站第一条命令

```bash
git clone https://github.com/superobk/microduck-startup.git ~/Microduck/startup
cd ~/Microduck/startup
bash scripts/workspace/bootstrap.sh ~/Microduck
```

随后严格执行：

```bash
make workspace-status
make preflight
make models-check
make browser-setup
make rl-setup
make rl-test
make smoke
```

Smoke 通过后才进入正式训练。

## 不变量

后续 session 不应无意破坏：

```text
61D actor observation
13D command block
14D policy action
固定 joint order
0.005 s physics × 4 decimation = 50 Hz policy loop
官方 exporter 包含 observation normalizer
固定评测集不用于训练
原始 upstream checkout 不承载长期实验修改
```

## Git 工作方式

- `official/*` 和 `community/*` 是独立仓库；
- 第一轮 checkout 固定 SHA；
- `make workspace-sync` 只 fetch，不 checkout；
- 修改任务时在 `experiments/worktrees/<experiment>` 建 worktree；
- 每个实验保留 config diff、seed、GPU、checkpoint hash、ONNX hash 和视频；
- 不把数据集、模型、视频或凭据提交到 startup。

## 资讯任务尚需一次人工配置

GitHub 源已配置。社交账号身份尚未由用户指定，因此默认 social feed 为 disabled。

配置位置：

```text
configs/intelligence-sources.json
```

推荐为目标账号提供公开 RSS/Atom 或合规 API feed URL，并通过 repository variable 或本地环境变量 `MICRODUCK_SOCIAL_FEED_URL` 注入。不要在公开仓库写 API token。

## 机械与主控研究

参考入口：

```text
hardware/mechanical/references/official-assets
hardware/mechanical/references/microduck-replica
hardware/controller-alternatives
```

任何修改后的 STL/CAD 放入 `hardware/mechanical/printable`，并把实测、试装和失败记录放入 `measurements` 与 `validation`。不要覆盖上游衍生资产。

## 每次结束前

```bash
cd ~/Microduck/startup
make manifest
make handoff
make workspace-status
```

检查：

```text
是否有未提交代码
最新 checkpoint 是否属于正确 run
ONNX 是否为 61→14
数据集 manifest 是否存在
资讯抓取是否有 error
下一步实验是否只改变一个主要变量
```

最后读取并交给下一 session：

```text
~/Microduck/notes/handoffs/LATEST.md
```
