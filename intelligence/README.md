# Microduck Intelligence

这个目录保存可公开、可审计的轻量资讯快照，不保存凭据、媒体大文件或社交平台 cookies。

```text
snapshots/latest.json               最新规范化数据
history/YYYY/MM/YYYY-MM-DD.json      每日快照
 digests/latest.md                    人可读摘要
 digests/YYYY-MM-DD.md                每日摘要
```

默认跟踪：

```text
superobk/microduck-startup
pollen-robotics/microduck
pollen-robotics/microduck_rl
IronSpiderMan/MicroDuckModels
fanhao375/microduck-replica
joeynyc/awesome-microduck
mujocolab/mjlab
leggedrobotics/rsl_rl
```

运行：

```bash
python3 scripts/intelligence/refresh.py
```

GitHub Actions 每六小时尝试刷新。GPU 工作站的本地 timer 将结果写到外层工作区 `intelligence/local`，避免制造 Git dirty state。

社交账号通过 `MICRODUCK_SOCIAL_FEED_URL` 接入。支持 RSS/Atom 形式的公开或合规 feed；不要提交 API token、session cookie 或私人 feed URL。
