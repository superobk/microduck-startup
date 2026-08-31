# 04 · Checkpoint 导出、原生推理与浏览器回灌

## 模型从哪里来

### 官方基线 ONNX

克隆 `pollen-robotics/microduck` 后位于：

```text
work/upstream/microduck/policies/
```

主线使用：

```text
alpha_walking.onnx
```

不需要额外模型下载命令。

### 自训练 checkpoint

训练产生：

```text
work/upstream/microduck_rl/logs/rsl_rl/**/model_*.pt
```

上游不在 Git 仓库中附带通用 `.pt` walking checkpoint；第一轮由你自己训练产生，或者使用特定 W&B run path。

## 为什么必须用官方 exporter

执行：

```bash
bash scripts/09_export_onnx.sh
```

底层调用：

```bash
uv run scripts/export.py Mjlab-Velocity-Flat-MicroDuck \
  --checkpoint-file /path/to/model_*.pt \
  --onnx-file /path/to/bootcamp_walk.onnx \
  --num-envs 1
```

官方 exporter 会把 observation normalization 作为 actor graph 的一部分导出。手工只导 actor MLP 可能导致训练 viewer 正常、部署完全失效。

## ONNX 契约验证

```bash
uv run python scripts/10_verify_onnx.py model.onnx
```

必须检查：

```text
唯一 input
input last dim = 61
唯一 output
output last dim = 14
metadata 可读取
SHA-256 已记录
```

## 原生 MuJoCo 部署预演

官方：

```bash
bash scripts/11_infer_official.sh
```

自训练：

```bash
bash scripts/12_infer_custom.sh
```

这一步比只在训练 viewer 中看 policy 更接近部署，因为它使用导出的 ONNX 和独立 observation 构建路径。

重点观察：

```text
normalizer 是否正确
joint order 是否正确
HOME pose 是否正确
action scale 是否正确
50 Hz loop 是否一致
commands 是否在正确 slot
```

## 浏览器回灌

```bash
bash scripts/13_install_policy_browser.sh
```

脚本复制模型并把：

```javascript
walk: `${POLICY_DIR}/BEST_alpha_walking.onnx`,
```

改为：

```javascript
walk: `${POLICY_DIR}/bootcamp_walk.onnx`,
```

然后重新 build。

## 浏览器缓存排查

使用新文件名而非覆盖旧文件。打开浏览器开发者工具：

```text
Network → 搜索 onnx → 确认 bootcamp_walk.onnx 返回 200
```

若行为没变：

1. 停止 Vite；
2. 确认 `constants.js`；
3. 确认 `public/policies/bootcamp_walk.onnx` hash；
4. `npm run build`；
5. 重启 Vite；
6. 浏览器 hard reload；
7. 清理 service-worker/cache（若存在）。

## 不能随 ONNX 一起随意改变的参数

```text
observation order
default pose
joint order
action scale
command slots
policy frequency
projected gravity convention
last-action convention
```

## 恢复官方策略

```bash
git -C work/upstream/MicroDuckModels restore src/game/constants.js
```

自定义 ONNX 文件仍留在 `public/policies/`，但不再被 walking slot 引用。
