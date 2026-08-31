# 08 · 排障手册

## GitHub clone 失败

### DNS

```bash
getent hosts github.com
```

### HTTPS

```bash
curl -I https://github.com
```

不要在公共仓库写入 personal access token。凭据使用系统 credential helper 或 SSH agent。

## `npm ci` 失败

检查：

```bash
node --version
npm --version
```

使用 Node 20+，推荐 22+。不要用 `--force` 掩盖 lockfile 或 engine 问题。

## 浏览器页面打开但资源 404

必须通过 Vite：

```bash
bash scripts/03_run_browser.sh
```

不要双击 `index.html`。

检查开发者工具：

```text
WASM
MJCF XML
STL/GLB
ONNX
```

## 浏览器只能本机访问

主路径使用 `127.0.0.1` + SSH tunnel：

```bash
ssh -L 5173:127.0.0.1:5173 USER@GPU_HOST
```

不要为了方便直接把开发服务器公开到公网。

## `uv sync` 下载超时

ARM64：

```bash
export UV_HTTP_TIMEOUT=600
uv sync
```

## `torch.cuda.is_available()` 为 False

```bash
cd work/upstream/microduck_rl
uv run python - <<'PY'
import torch
print(torch.__version__)
print(torch.version.cuda)
print(torch.cuda.is_available())
print(torch.cuda.device_count())
PY
```

同时看：

```bash
nvidia-smi
uname -m
```

不要仅因 `nvidia-smi` 正常就认定 Python CUDA 正常。

## Training OOM

只降低：

```text
TRAIN_ENVS=4096 → 2048 → 1024 → 512
```

然后重新 smoke。不要同时减网络、关 DR 和改 reward。

## Smoke 出现 NaN

依次检查：

1. checkout SHA；
2. clean `uv sync`；
3. tests；
4. task ID；
5. 是否修改 env config；
6. CUDA/Torch/Warp；
7. 只用 64 env 重现；
8. 保存完整 traceback 和 manifest。

## TensorBoard 没有数据

确认训练 logger：

```text
--agent.logger tensorboard
```

确认：

```bash
find work/upstream/microduck_rl/logs/rsl_rl -maxdepth 4 -type f | head
```

## 找到的是 smoke checkpoint

`08_find_checkpoint.sh` 只按 mtime 选择最新。导出前检查路径中的 run name。重要结果应显式传 checkpoint：

```bash
bash scripts/09_export_onnx.sh /absolute/path/to/model_1000.pt
```

## Export 报 checkpoint 不存在

使用绝对路径：

```bash
realpath work/upstream/microduck_rl/logs/rsl_rl/.../model_*.pt
```

## ONNX shape 不是 61→14

停止部署。可能原因：

```text
错误 task
旧 observation contract
错误 exporter
错误模型文件
模型缓存
```

不要通过 padding/truncation 强行适配。

## ONNX 在训练 viewer 正常、原生 inference 失败

重点检查：

```text
normalizer 是否导出
projected gravity
joint order
HOME/default pose
action scale
command slots
last_action
50 Hz timing
```

## 替换浏览器 ONNX 后行为不变

```bash
grep -n 'walk:' work/upstream/MicroDuckModels/src/game/constants.js
sha256sum work/upstream/MicroDuckModels/public/policies/bootcamp_walk.onnx
npm run build
```

然后重启 Vite和硬刷新浏览器。

## 原生 MuJoCo viewer 无法打开

`infer_policy.py` 使用 native viewer，需要图形/OpenGL session。解决路径：

```text
Ubuntu GNOME 本地桌面
XRDP 的 X11/GNOME session
其他可用 DISPLAY/OpenGL 环境
```

纯 SSH/headless 环境先使用浏览器 simulator 和训练/导出步骤。

## `microduck-replica` 渲染失败

可能是离屏 OpenGL context。先测试：

```bash
work/upstream/microduck-replica/.venv/bin/python -c 'import mujoco; print(mujoco.__version__)'
```

在 headless 环境根据系统图形栈设置 EGL/OSMesa；不要盲目修改 MJCF。
