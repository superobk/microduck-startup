# 16 · Hugging Face Model 与 Microduck Simulator Space 集成

## 当前官方 Space

源：

```text
pollen-robotics/microduck-simulator
```

当前结构：

```text
README.md              Docker Space metadata, app_port 8080
Dockerfile             Node 22 build + nginx-unprivileged
app/
├── package.json
├── package-lock.json
├── public/
│   ├── policies/
│   ├── robot/
│   └── assets/
└── src/
    ├── game/
    │   ├── constants.js
    │   └── game.js
    ├── scene/
    └── ui/
```

它在浏览器内运行 MuJoCo WASM 和 ONNX Runtime Web，策略周期 50 Hz，actor
接口为 61D observation → 14D action。

## 发布顺序

```text
1. 本地 bundle
2. 个人 HF model repo
3. 个人 duplicate Space
4. duplicate 中验证行为、构建和移动端
5. 再向官方 Space 提交 Community PR/Discussion
```

除非你的 token 明确具有组织写权限，不要把官方 Space 当成可直接覆盖的发布目标。

## 1. 认证

GPU 工作站：

```bash
uvx --from huggingface_hub hf auth login
uvx --from huggingface_hub hf auth whoami
```

Token 不写入 `configs/*.env`、Git、日志或 handoff。

## 2. 发布 model repo

设置：

```bash
cd ~/Microduck/startup
nano configs/one-day.env
```

示例：

```bash
ONE_DAY_HF_MODEL_REPO="YOUR_HF_USER/microduck-roulade-v1"
```

发布：

```bash
bash scripts/one_day/run.sh publish-model
```

或直接：

```bash
cd ~/Microduck/official/microduck_rl

uv run --with "huggingface_hub>=1.0" \
  python ~/Microduck/startup/scripts/hf/publish_model.py \
  --bundle ~/Microduck/artifacts/published/RUN_ID \
  --repo-id YOUR_HF_USER/microduck-roulade-v1
```

`huggingface_hub` 的 `upload_folder` 会上传 bundle；当前默认 Xet 后端支持
分块、去重和断点后重跑。大文件上传可设置：

```bash
export HF_XET_HIGH_PERFORMANCE=1
```

## 3. 创建个人 duplicate Space

配置：

```bash
ONE_DAY_HF_SPACE_REPO="YOUR_HF_USER/microduck-simulator-roulade-v1"
ONE_DAY_HF_SOURCE_SPACE="pollen-robotics/microduck-simulator"
```

执行：

```bash
bash scripts/one_day/run.sh publish-space
```

脚本会：

1. 查询源 Space 当前 commit SHA；
2. 按该 SHA `snapshot_download`，避免构建期间源文件漂移；
3. 复制 `policy.onnx`；
4. 修改 `app/src/game/constants.js` 中选定 slot；
5. 复制 preview/metrics/manifest；
6. 本地 `npm ci && npm run build`；
7. 使用 `duplicate_space` 创建个人 Space；
8. 上传修改并触发构建。

## 4. Slot 兼容性

| Slot | 现有触发 | Command 语义 | 适合的 task |
|---|---|---|---|
| `walk` | WASD/arrows | `vx,vy,wz` | Velocity |
| `sitstand` | D-pad down/UI | posture flag | SitStand |
| `roll` | R/X | 零命令 + timed return | Roulade |
| `kickL` | Q/LB | 零命令 + kick window | left kick |
| `kickR` | E/RB | 零命令 + kick window | BallKick/right |
| `roller` | roller mode movement | roller velocity | Rollers |
| `crouch` | R/X in roller mode | phase command | RollerCrouch |

同接口不等于同行为协议。替换 slot 前必须确认：

```text
robot variant
command encoding
trigger
policy active duration
termination/exit
fallback policy
ball/terrain scene
```

## 5. 本地只 Stage，不上传

```bash
cd ~/Microduck/official/microduck_rl

uv run --with "huggingface_hub>=1.0" \
  python ~/Microduck/startup/scripts/hf/stage_space.py \
  --source-space pollen-robotics/microduck-simulator \
  --target-space YOUR_HF_USER/microduck-simulator-test \
  --policy ~/Microduck/artifacts/published/RUN_ID/policy.onnx \
  --bundle ~/Microduck/artifacts/published/RUN_ID \
  --slot roll \
  --slug RUN_ID \
  --workdir ~/Microduck/registry/huggingface/space-staging/RUN_ID \
  --build
```

启动本地预览：

```bash
cd ~/Microduck/registry/huggingface/space-staging/RUN_ID/app
npm run dev -- --host 127.0.0.1 --port 5173
```

Mac 通过 SSH tunnel 打开。

## 6. 向官方 Space 提交 PR

个人 duplicate 完成以下验证后才做：

```text
ONNX 61→14
npm production build
动作触发
动作结束后 fallback
连续触发保护
reset
桌面键盘
gamepad
移动端触摸
浏览器 console 无 error
源 Space SHA 已记录
```

创建 Community PR：

```bash
uv run --with "huggingface_hub>=1.0" \
  python ~/Microduck/startup/scripts/hf/stage_space.py \
  --source-space pollen-robotics/microduck-simulator \
  --policy ~/Microduck/artifacts/published/RUN_ID/policy.onnx \
  --bundle ~/Microduck/artifacts/published/RUN_ID \
  --slot roll \
  --slug RUN_ID \
  --model-repo YOUR_HF_USER/MODEL_REPO \
  --workdir ~/Microduck/registry/huggingface/space-staging/RUN_ID-pr \
  --build \
  --create-pr \
  --upload
```

该命令只创建 PR，不直接写官方 `main`。

对于“替换已有 roll slot”的演示 PR，维护者可能要求改为新增独立 policy
profile。真正的新动作需要继续修改：

```text
app/src/game/constants.js        policy path / slot
app/src/game/game.js             state machine, command, timeout, fallback
app/src/ui/*                     label、按键和触摸入口
app/src/game/controls/*          keyboard/gamepad/touch mapping
README.md                        control、模型和来源
```

## 7. 发布门槛

正式展示至少包含：

```text
policy.onnx
preview.mp4
rollout.npz
metrics.json
resolved env/agent config
upstream commit
checkpoint hash
ONNX hash
Space source SHA
已知失败条件
实机安全声明
```

不要仅发布“看起来成功的一段视频”；固定 replay、指标和来源必须同时存在。
