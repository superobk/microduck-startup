# MicroDuck Startup：两天完成仿真、强化学习训练、ONNX 导出与浏览器回灌

这是一套面向第一次复现者的 **MicroDuck 可执行启动仓库**。目标不是两天内制造实体机器鸭，而是完成一条可核验的软件闭环：

```text
官方已训练 ONNX 基线
        ↓
浏览器 MuJoCo + ONNX 仿真
        ↓
官方 microduck_rl 环境与测试
        ↓
PPO smoke test
        ↓
本地 CUDA 训练 checkpoint
        ↓
官方 export.py 导出 61→14 ONNX
        ↓
原生 MuJoCo 部署预演
        ↓
把自己的 ONNX 回灌浏览器模拟器
        ↓
Push / No-Push 单变量 A/B
```

本仓库不重新托管上游代码、模型或 3D 资产；脚本会把固定版本下载到被忽略的 `work/` 目录。这样既保持来源和许可证边界，也保证第一轮实验可以重现。

## 你最终会得到什么

完成主线后，至少应有：

- 能运行的 MicroDuck 浏览器物理模拟器；
- 能解释的 61 维 observation、13 维 command 和 14 维 action；
- 一次通过的 CPU 测试与 `64 env × 5 iteration` smoke test；
- 自己训练出的 `model_*.pt` checkpoint；
- 通过官方 exporter 生成的 `bootcamp_walk.onnx`；
- ONNX 输入输出契约检查结果：`[1, 61] → [1, 14]`；
- 官方策略与自训练策略的原生 MuJoCo 对照；
- 已把自训练 ONNX 替换进 `MicroDuckModels`；
- 一份带 upstream SHA、GPU、参数和 artifact hash 的实验 manifest；
- 可选的 `ENABLE_VELOCITY_PUSHES=True/False` 单变量 A/B 工作区。

## 哪个仓库最重要

**强化学习主线最重要的仓库是 `pollen-robotics/microduck_rl`。**

| 优先级 | 仓库 | 用途 | 两天内的角色 |
|---:|---|---|---|
| 1 | `pollen-robotics/microduck_rl` | MuJoCo Warp、PPO、reward、domain randomization、BAM、backlash、ONNX 导出 | 核心训练仓库 |
| 2 | `pollen-robotics/microduck` | 实体 runtime、官方发布的 ONNX 策略、部署约定 | 官方策略基线与 source of truth |
| 3 | `IronSpiderMan/MicroDuckModels` | 浏览器 MuJoCo WASM + ONNX Runtime Web + UI | 最快理解推理闭环和回灌策略 |
| 4 | `fanhao375/microduck-replica` | 从 MJCF/STL 逆向装配、CAD 和机械参数 | 学完 RL 后理解机器人结构 |
| 5 | `joeynyc/awesome-microduck` | 社区导航、Genesis/Isaac/MCP/策略项目 | 第二阶段选型地图，不是训练代码 |

详细代码地图见 [docs/00-system-and-code-map.md](docs/00-system-and-code-map.md)。

## 在哪里运行

推荐采用单一、可重复的主路径：

```text
macOS 主机
  ├─ 浏览器打开 127.0.0.1:5173 / 6006 / 8080
  ├─ 阅读文档、记录实验、最终 review
  └─ SSH tunnel
          │
          ▼
Ubuntu 24.04 NVIDIA GPU 工作站
  ├─ 克隆全部固定版本 upstream
  ├─ Node/Vite 启动浏览器 simulator
  ├─ CUDA + MuJoCo Warp 训练
  ├─ TensorBoard
  ├─ ONNX 导出与验证
  └─ 原生 MuJoCo inference
```

浏览器模拟器也可以直接在 Mac 上运行，但为了减少目录和版本差异，**第一轮建议全部服务都在 Ubuntu GPU 机启动，Mac 只通过 SSH tunnel 访问**。

针对 4 张 48 GB GPU 的机器：第一轮只用 `CUDA_VISIBLE_DEVICES=0` 跑单卡。先证明单卡闭环正确，再把四卡用于四个独立 seed；不要一开始就把“RL 问题”和“分布式问题”混在一起。

## 硬件与软件要求

### 主线必需

- Ubuntu 22.04/24.04 x86_64，或受上游支持的 Linux ARM64；
- NVIDIA GPU 与可用驱动；
- Git、curl、Python 3、Node.js 20+；推荐 Node.js 22+；
- 能访问 GitHub、Python/PyTorch package index；
- 建议至少 16 GB RAM 和 30 GB 可用磁盘；训练规模越大需求越高。

### 不需要

- 不需要实体 MicroDuck；
- 不需要 OpenAI API key；
- 不需要手工下载 Hugging Face 模型；
- 不需要 Docker 才能完成第一轮；
- 不需要先理解 PPO 的所有数学推导。

官方九个 ONNX 行为模型随 `pollen-robotics/microduck` 的 `policies/` 目录一起克隆；浏览器仓库也自带对应策略。训练产生的 PyTorch checkpoint 不在本仓库分发，需要你自己训练得到。

## 固定版本

第一轮复现使用 `configs/upstreams.env` 中 2026-08-31 调研快照：

| 仓库 | 分支来源 | 固定提交 |
|---|---|---|
| `pollen-robotics/microduck_rl` | `develop` | `d424a0c899f6b33cbd3daeb279913134349c0b63` |
| `pollen-robotics/microduck` | `main` | `590b986bd8c0d50ae02cb3ea2f59c463b6828168` |
| `IronSpiderMan/MicroDuckModels` | `main` | `f336dc0a984e8c7bf46e350cb541de54fe1bf9f8` |
| `fanhao375/microduck-replica` | `master` | `652f7ba86f56e7243b91b36c229977d882e36bc6` |
| `joeynyc/awesome-microduck` | `main` | `9ef86882a1ea913c771c3169b533c020a3a1b286` |

在第一轮完整跑通前，不要改成浮动 `main/develop`。

---

# 从零开始：逐步执行

以下命令在 **Ubuntu GPU 工作站**执行。每一步都包含观察点；不要一次粘贴全部命令后离开。

## 0. 克隆本启动仓库

```bash
cd ~
git clone https://github.com/superobk/microduck-startup.git
cd microduck-startup
```

创建本地实验配置：

```bash
cp configs/experiment.env.example configs/experiment.env
```

第一轮先保持默认值：

```bash
sed -n '1,120p' configs/experiment.env
```

默认含义：

```text
TASK_ID       = Mjlab-Velocity-Flat-MicroDuck
GPU           = 0
smoke         = 64 env × 5 iterations
正式教学运行 = 4096 env × 1000 iterations
seed          = 42
logger        = tensorboard
```

## 1. 主机预检

```bash
bash scripts/00_preflight_host.sh
```

观察：

1. Ubuntu、架构、内存和磁盘是否符合预期；
2. `nvidia-smi` 是否列出 GPU；
3. `github.com` 是否能解析；
4. Node、npm、uv 尚未安装可以接受，后续步骤会处理。

通过标准：训练机至少有 `git`、`curl`、`python3` 和可见 NVIDIA GPU。

## 2. 下载五个固定版本 upstream

```bash
bash scripts/01_clone_upstreams.sh
```

下载位置：

```text
work/upstream/microduck_rl
work/upstream/microduck
work/upstream/MicroDuckModels
work/upstream/microduck-replica
work/upstream/awesome-microduck
```

验证：

```bash
cat work/state/upstream-versions.tsv
```

每个实际 SHA 必须与 `configs/upstreams.env` 一致。然后确认官方模型已经随 runtime checkout 下载：

```bash
bash scripts/20_check_official_models.sh
```

它会列出九个官方 ONNX 的大小与 SHA-256；不需要另行下载模型。

## 3. 安装并构建浏览器模拟器

确认 Node：

```bash
node --version
npm --version
```

然后执行：

```bash
bash scripts/02_setup_browser.sh
```

观察：

- `npm ci` 必须成功；
- `npm run build` 必须生成 `work/upstream/MicroDuckModels/dist/`；
- 此时还没有进行强化学习训练，只是在运行已训练好的 ONNX。

## 4. 启动浏览器模拟器

在 GPU 机终端 A：

```bash
bash scripts/03_run_browser.sh
```

在 Mac 终端建立隧道：

```bash
ssh \
  -L 5173:127.0.0.1:5173 \
  -L 6006:127.0.0.1:6006 \
  -L 8080:127.0.0.1:8080 \
  USER@GPU_HOST
```

或使用脚本：

```bash
bash scripts/18_ssh_tunnel.sh USER@GPU_HOST
```

Mac 浏览器打开：

```text
http://127.0.0.1:5173
```

操作检查：

| 行为 | 按键 |
|---|---|
| 前后与转向 | 方向键或 WASD |
| 左/右踢球 | Q / E |
| 交替踢球 | F |
| 坐下/站起 | R |
| ground pick | G |
| 切换相机 | C |
| 腿/轮式切换 | M |
| 重置 | Space |

必须观察并记录：

- 站立时是否稳定；
- 行走与转向是否响应 command；
- 跌倒后是否进入恢复状态；
- 恢复成功后是否自动交还给 walking policy；
- 坐立、踢球、翻滚属于不同 ONNX policy，策略切换状态机本身是手写代码。

Day 1 浏览器详细阅读顺序见 [docs/02-day1-browser-simulator.md](docs/02-day1-browser-simulator.md)。

## 5. 安装官方 RL 环境

在 GPU 机终端 B：

```bash
bash scripts/04_setup_rl.sh
```

这个脚本会：

1. 安装 `uv`；
2. 在固定的 `microduck_rl` checkout 中执行 `uv sync`；
3. 按项目约束解析 Python 3.12；
4. 打印 Torch、CUDA build 和 GPU；
5. 在 `torch.cuda.is_available()` 为 False 时停止。

通过标准：

```text
CUDA available: True
GPU count: 1 或更多
```

ARM64/DGX Spark/GB10 首次安装时，脚本会自动使用较长的 `UV_HTTP_TIMEOUT`。

## 6. 列出任务并运行测试

```bash
bash scripts/05_rl_tests.sh
```

观察：

- `uv run list-envs` 中出现 MicroDuck 任务；
- `tests/` 全部通过；
- 这些测试锁定 joint mapping、reward sign、NaN guard 等关键不变量。

常见任务：

```text
Mjlab-Velocity-Flat-MicroDuck       行走与速度命令
Mjlab-Velocity-Rough-MicroDuck      粗糙地形
Mjlab-VelStand-Flat-MicroDuck       行走 + 跌倒恢复
Mjlab-StandUp-Flat-MicroDuck        起身
Mjlab-SitStand-Flat-MicroDuck       坐立切换
Mjlab-GroundPick-Flat-MicroDuck     嘴触地再站起
Mjlab-BallKick-Flat-MicroDuck       踢球
Mjlab-Roulade-Flat-MicroDuck        前滚翻
```

第一轮只训练 `Mjlab-Velocity-Flat-MicroDuck`。

## 7. 先运行官方 ONNX 基线

原生 MuJoCo viewer 需要 Ubuntu 图形会话。你已有 Ubuntu GNOME/XRDP 环境时，可以直接执行：

```bash
bash scripts/11_infer_official.sh
```

脚本使用：

```text
work/upstream/microduck/policies/alpha_walking.onnx
```

观察终端打印：

- ONNX input shape；
- ONNX output shape；
- actuator 数量；
- command 与实际运动；
- CSV 会写入 `work/artifacts/official_walk.csv`。

若当前 SSH 会话没有 OpenGL/桌面，先完成训练和导出；之后在 GNOME/XRDP 会话运行这一步。浏览器模拟器不受此限制。

## 8. 必做：64 env × 5 iteration smoke test

```bash
bash scripts/06_rl_smoke.sh
```

不要期待它学会走路。它的目标是证明：

- 环境能编译；
- 64 个并行环境能 step；
- observation 为 61D；
- action 为 14D；
- reward、termination、reset 都能计算；
- 没有 NaN/Inf；
- PPO runner 可以完成 iteration。

通过后再继续。官方项目把这一步视为长训练前的强制检查。

## 9. 启动 TensorBoard

GPU 机终端 C：

```bash
bash scripts/19_tensorboard.sh
```

Mac 浏览器打开：

```text
http://127.0.0.1:6006
```

不要只看 total reward。至少同时看：

- mean reward；
- episode length；
- velocity tracking；
- upright/pose；
- termination/fall；
- policy entropy；
- KL；
- value loss；
- learning rate。

## 10. 开始第一条教学训练

```bash
bash scripts/07_train_walking.sh
```

默认：

```text
GPU 0
4096 parallel envs
1000 PPO iterations
seed 42
tensorboard logger
```

显存不足时，只改 `configs/experiment.env` 中：

```text
TRAIN_ENVS=2048
```

仍不足再依次降为 `1024`、`512`。第一轮不要同时改 reward、PPO、network 和 domain randomization。

训练期间观察：

1. 早期机器人可能抖动、跌倒或原地找平衡；
2. total reward 上升不代表已学会 command tracking；
3. episode length 和主要任务 reward 必须一起改善；
4. penalty 项不应出现“违反越严重、奖励越高”的符号错误；
5. 每次 curriculum 边界若指标突然下降，说明阶段推进可能过快。

## 11. 找到最新 checkpoint

训练至少到第一次保存点后：

```bash
bash scripts/08_find_checkpoint.sh
cat work/state/latest_checkpoint.txt
```

输出应是类似：

```text
.../microduck_rl/logs/rsl_rl/velocity/<run>/model_*.pt
```

## 12. 使用官方 exporter 导出 ONNX

```bash
bash scripts/09_export_onnx.sh
```

也可以显式传入 checkpoint：

```bash
bash scripts/09_export_onnx.sh /absolute/path/to/model_*.pt
```

脚本会调用上游官方：

```text
microduck_rl/scripts/export.py
```

并自动执行：

```text
scripts/10_verify_onnx.py
```

必须看到：

```text
PASS: ONNX contract is 61 -> 14
```

不要自己直接写 `torch.onnx.export` 替代官方 exporter；官方路径会把 observation normalizer 一起导入图中并附加 metadata。

输出：

```text
work/artifacts/bootcamp_walk.onnx
work/state/latest_onnx.txt
```

## 13. 原生 MuJoCo 运行自己的 ONNX

```bash
bash scripts/12_infer_custom.sh
```

或：

```bash
bash scripts/12_infer_custom.sh /absolute/path/to/custom.onnx
```

与官方基线比较：

- 能否保持直立；
- 零命令是否静止；
- 前进/转向响应；
- gait 是否左右对称；
- head 是否持续下垂；
- action 是否高频抖动；
- 外部扰动后是否能恢复；
- CSV 是否出现 NaN/Inf。

## 14. 把自己的 ONNX 回灌浏览器

先停止 Vite，再执行：

```bash
bash scripts/13_install_policy_browser.sh
```

它会：

1. 把 ONNX 复制为 `MicroDuckModels/public/policies/bootcamp_walk.onnx`；
2. 修改 `src/game/constants.js` 的 walking policy 指向；
3. 重新执行生产构建。

重新启动：

```bash
bash scripts/03_run_browser.sh
```

浏览器硬刷新后观察自己的策略。新文件名能避免浏览器继续使用旧 ONNX cache。

恢复官方浏览器源码：

```bash
git -C work/upstream/MicroDuckModels restore src/game/constants.js
```

## 15. 记录完整实验 manifest

```bash
bash scripts/15_record_manifest.sh
```

结果位于：

```text
work/manifests/<UTC timestamp>/
```

其中包括：

- upstream commits；
- task、seed、env 数、iteration 数；
- GPU/driver 信息；
- Python package freeze；
- artifact SHA-256；
- 每个 checkout 的 dirty diff 状态。

凭据、token 和密码不得写入 `configs/experiment.env` 或 manifest。

---

# 可选：Push / No-Push 单变量 A/B

创建独立 worktree：

```bash
bash scripts/14_create_no_push_worktree.sh
```

它只改：

```python
ENABLE_VELOCITY_PUSHES = True
```

为：

```python
ENABLE_VELOCITY_PUSHES = False
```

先检查 diff，确认没有第二个变量。然后在 no-push worktree 中执行相同 smoke 和 training 参数。

实验假设：

> 开启 velocity pushes 可能降低早期 gait 的平滑度和收敛速度，但提高受扰后的恢复能力；关闭 pushes 的策略可能更平稳，却更容易在冲击后跌倒。

第一轮单 seed 只能作为教学结果。正式结论至少运行 3 个 seed，并保持 task、commit、GPU、envs、iterations、reward、commands 和 terrain 完全相同。

见 [docs/06-ab-experiment.md](docs/06-ab-experiment.md)。

---

# 可选：机械结构复刻模块

RL 主线完成后：

```bash
bash scripts/16_setup_replica.sh
bash scripts/17_rebuild_replica.sh
```

会重新生成装配图、世界变换后的 STL assembly 和孔特征分析。

这些产物来自仿真 MJCF/STL 的逆向推导，不等于经过制造验证的工程图。不要直接假定打印公差、螺纹、热熔螺母座和走线空间已经解决。

见 [docs/07-mechanical-replica.md](docs/07-mechanical-replica.md)。

---

# 两天建议时间表

## Day 1

```text
09:00  主机预检、固定版本 clone
10:00  npm ci、浏览器 simulator
11:00  阅读 constants.js / game.js，画出 61→14 闭环
13:30  uv sync、Torch/CUDA 验证
15:00  list-envs、tests
16:00  官方 ONNX 原生 MuJoCo 基线
17:00  64×5 smoke test
18:00  Day 1 验收
```

## Day 2

```text
09:00  启动 TensorBoard 和 1000-iteration walking run
11:30  找 checkpoint，观察曲线和 rollout
13:00  官方 export.py 导出 ONNX
13:30  61→14 契约验证
14:00  原生 MuJoCo 对比官方与自训练策略
15:00  回灌浏览器
16:00  创建 no-push A/B worktree
17:00  记录 manifest、复盘和下一轮计划
```

详细训练营见 [docs/01-two-day-runbook.md](docs/01-two-day-runbook.md)。

# 目录结构

```text
microduck-startup/
├── README.md
├── Makefile
├── configs/
│   ├── upstreams.env
│   └── experiment.env.example
├── docs/
│   ├── 00-system-and-code-map.md
│   ├── 01-two-day-runbook.md
│   ├── 02-day1-browser-simulator.md
│   ├── 03-rl-environment-and-training.md
│   ├── 04-export-inference-browser.md
│   ├── 05-observation-and-evaluation.md
│   ├── 06-ab-experiment.md
│   ├── 07-mechanical-replica.md
│   ├── 08-troubleshooting.md
│   └── 09-licenses-and-provenance.md
├── scripts/
├── templates/
└── work/                 # 自动生成、gitignored
    ├── upstream/
    ├── artifacts/
    ├── state/
    ├── manifests/
    └── variants/
```

# 快捷命令

也可以用 Makefile：

```bash
make preflight
make clone
make browser-setup
make browser
make rl-setup
make rl-test
make smoke
make tensorboard
make train
make checkpoint
make export
make infer-official
make infer-custom
make browser-install-policy
make manifest
```

所有脚本都可以直接用 `bash scripts/...` 执行，不依赖 Git 文件的 executable bit。

# 验收清单

- [ ] 五个 upstream SHA 与 `configs/upstreams.env` 一致；
- [ ] 浏览器模拟器构建并运行；
- [ ] 能解释 61D observation 的组成；
- [ ] 能解释 13D command 和 14D action；
- [ ] 能指出 policy 与 hand-written state machine 的边界；
- [ ] `uv sync` 后 Torch CUDA 为 True；
- [ ] CPU tests 通过；
- [ ] 64×5 smoke test 无 NaN；
- [ ] 生成 `model_*.pt`；
- [ ] 官方 exporter 生成 ONNX；
- [ ] ONNX 验证为 61→14；
- [ ] 原生 MuJoCo 能运行自训练 ONNX；
- [ ] 浏览器成功加载自训练 ONNX；
- [ ] manifest 包含版本、参数与 hashes；
- [ ] A/B 实验仅改变一个变量。

# 许可证与边界

本启动仓库的原创文档和脚本采用 Apache-2.0。各上游仓库、ONNX、MJCF、STL、GLB、图片和声音仍遵循各自许可证。尤其 3D 模型及其衍生机械产物可能受 CC BY-SA-NC 条款约束，不应被本仓库的 Apache-2.0 误解为可商用授权。

详见 [docs/09-licenses-and-provenance.md](docs/09-licenses-and-provenance.md)。
