# 09 · 许可证、来源与可追溯性

## 本仓库

原创文档与脚本：Apache License 2.0。

## 上游边界

本仓库只保存 clone URL、固定 SHA 和自动化脚本，不重新托管：

```text
ONNX weights
PyTorch checkpoints
MJCF
STL/GLB
图片
声音
上游源代码
```

这些内容下载到 gitignored 的 `work/upstream/`，继续遵循上游各自许可证。

## 主要上游

| 项目 | 主要用途 | 需单独检查的许可 |
|---|---|---|
| `pollen-robotics/microduck_rl` | RL、MJCF、训练 | 代码 Apache-2.0；3D 资产可能 CC BY-SA-NC |
| `pollen-robotics/microduck` | runtime、ONNX | 上游 LICENSE 与 policy 文件说明 |
| `IronSpiderMan/MicroDuckModels` | browser simulator | 仓库及其上游资产说明；不要假定所有媒体均属同一许可 |
| `fanhao375/microduck-replica` | 机械衍生内容 | scripts 与 CAD/drawings 的许可证不同；衍生 3D 内容可能 NC |
| `joeynyc/awesome-microduck` | 索引 | 列表许可不覆盖其链接项目 |

## 特别提醒：CC BY-SA-NC

`NC` 表示非商业限制。由上游 3D 模型转换、应用世界变换或重新组合产生的文件，仍可能是受同许可证约束的衍生作品。

## 模型来源

### 官方 ONNX

```text
pollen-robotics/microduck@590b.../policies/
```

### 浏览器 ONNX

```text
IronSpiderMan/MicroDuckModels@f336.../public/policies/
```

### 自训练 ONNX

```text
model_*.pt
  → pollen-robotics/microduck_rl@d424.../scripts/export.py
  → bootcamp_walk.onnx
```

## Manifest

运行：

```bash
bash scripts/15_record_manifest.sh
```

记录来源、SHA、host、GPU、配置和 artifact hashes。

## 凭据规则

允许为了复现保留：

```text
公开 commit SHA
非秘密 run ID
GPU 型号
host OS
实验参数
日志
artifact hash
```

禁止提交：

```text
GitHub PAT
W&B API key
Hugging Face token
SSH private key
密码
云凭据
私有 registry token
```

认证应通过官方 CLI/login/credential helper 或进程环境完成，不写入本仓库和 manifest。
