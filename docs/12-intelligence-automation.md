# 12 · GitHub 与社交资讯自动刷新

## 目标

保持 Microduck 生态信息新鲜，同时不自动改变已验证训练基线。

```text
远端变化 → 资讯快照/摘要 → 人工 review → worktree 验证 → 更新 pin
```

禁止：

```text
远端 main 更新 → 自动 checkout → 正在训练的环境被改变
```

## GitHub 源

配置：

```text
configs/intelligence-sources.json
```

每个源可以指定：

```json
{
  "repo": "owner/repo",
  "branch": "main",
  "role": "why this repository matters",
  "include_releases": true,
  "include_pulls": true,
  "include_issues": true
}
```

Collector 记录 branch head、最近 commits、releases、PRs 和可选 issues。使用 `GITHUB_TOKEN` 时走认证 API；token 只从进程环境读取。

## 社交账号

用户尚未指定具体账号，因此默认配置为自动禁用。提供 feed 后自动启用：

```bash
export MICRODUCK_SOCIAL_FEED_URL='https://example.org/feed.xml'
python3 scripts/intelligence/refresh.py
```

推荐来源：

- 账号公开 RSS/Atom；
- YouTube 官方 Atom feed；
- Mastodon 公开 RSS；
- Bluesky 或其他平台的官方公开 API feed；
- 自己控制的 RSSHub/bridge。

X/Twitter 不建议使用匿名 HTML 抓取：页面结构、登录要求和服务条款均可能变化。使用官方 API 或自己有权运行的桥接服务。

GitHub Actions 可在 repository variable 中设置：

```text
MICRODUCK_SOCIAL_FEED_URL
```

公开仓库中不要保存 token、cookies 或带秘密查询参数的 URL。

## GitHub Actions

工作流：

```text
.github/workflows/intelligence-refresh.yml
```

计划：每六小时一次，另支持手工 `workflow_dispatch`。Scheduled Actions 可能被 GitHub 延后，因此它是周期性同步，不是实时告警系统。

公开输出：

```text
intelligence/snapshots/latest.json
intelligence/history/YYYY/MM/YYYY-MM-DD.json
intelligence/digests/latest.md
intelligence/digests/YYYY-MM-DD.md
```

只有文件发生变化时才提交。

## GPU 工作站 timer

```bash
cd ~/Microduck/startup
make intelligence-timer-install
```

安装：

```text
~/.config/systemd/user/microduck-intelligence.service
~/.config/systemd/user/microduck-intelligence.timer
~/.config/microduck/intelligence.env
```

本地输出：

```text
~/Microduck/intelligence/local
```

手工触发：

```bash
systemctl --user start microduck-intelligence.service
journalctl --user -u microduck-intelligence.service -n 100
```

## 失败处理

Collector 对单一源失败采用 best-effort：其他源继续更新，错误写入 snapshot 与 digest。若要在 CI 中将任何源错误视作失败：

```bash
python3 scripts/intelligence/refresh.py --fail-on-error
```

社交内容和社区提交只能作为线索；硬件参数、许可证和部署判断仍需回到官方源码、数据表或实测证据。
