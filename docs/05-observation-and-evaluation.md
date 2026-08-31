# 05 · 观察、记录与评估

## 原则

“能动”不等于“训练成功”。每个结论必须同时包含：

```text
版本
配置
曲线
rollout 视频
定量指标
失败样本
```

## 浏览器 baseline 记录

| 项目 | 记录 |
|---|---|
| upstream SHA | |
| 浏览器/OS | |
| 加载的 ONNX | |
| zero command 站立时长 | |
| forward command 响应 | |
| turn command 响应 | |
| 跌倒检测延迟 | |
| 起身成功率 | |
| 起身时间 | |
| reset 次数 | |

## Training 记录

每 100–250 iterations 记录：

| 指标 | 解释 |
|---|---|
| iteration | 训练进度 |
| transitions | envs × 24 × iteration |
| mean reward | 总体趋势，不单独作为成功判断 |
| episode length | 是否越来越快跌倒/结束 |
| velocity tracking | 主任务是否真的进步 |
| upright/pose | 是否保持身体目标 |
| fall/termination | 稳定性 |
| entropy | exploration 是否过快坍缩 |
| KL | policy update 大小 |
| value loss | critic 学习情况 |
| qualitative rollout | 人眼行为描述 |

## 原生 inference A/B

固定：

```text
相同 MJCF
相同 command 顺序
相同测试时长
相同 reset 条件
相同扰动次数
```

对官方和自训练 policy 记录：

| 指标 | Official | Custom |
|---|---:|---:|
| zero-command 站立秒数 | | |
| forward 10 s 跌倒数 | | |
| left/right turn 成功 | | |
| 扰动次数 | | |
| 扰动后跌倒数 | | |
| 恢复成功数 | | |
| 平均恢复时间 | | |
| action peak | | |
| action-rate/jitter | | |
| NaN/Inf | | |

## 不确定性表达

两天、单 seed 的结果写成：

```text
“在固定 SHA、seed 42、4096 env、1000 iterations 下，观察到……”
```

不要写成：

```text
“这种 reward 一定更好”
“Push 一定提高 sim2real”
“该策略已经可部署实体”
```

至少 3 seed、固定评估 battery 后，才适合比较均值和离散度。

## Manifest

```bash
bash scripts/15_record_manifest.sh
```

在上传结果前确认：

- 没有 W&B token；
- 没有 Hugging Face token；
- 没有 SSH private key；
- 没有 `.env` credentials；
- 没有内部主机密码；
- 允许保留非秘密的主机、GPU、commit、参数和日志标识，以保证可追溯。
