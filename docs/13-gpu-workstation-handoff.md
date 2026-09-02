# 13 · GPU 工作站交接规范

## 接手时

```bash
cd ~/Microduck/startup
cat HANDOFF.md
cat ~/Microduck/notes/handoffs/LATEST.md 2>/dev/null || true
make workspace-status
make preflight
```

然后确认：

```text
目标 task
目标 worktree
基线 commit
GPU index
seed
env count
checkpoint
frozen evaluation version
```

## 离开时

```bash
make manifest
make handoff
make workspace-status
```

在 `LATEST.md` 的 Operator notes 补充：

```text
Current objective
Last successful command
Current blocker
Next single-variable experiment
Expected evidence/pass condition
```

## 禁止交接的含糊状态

不要只写：

```text
训练过了
效果不错
模型在 logs 里
```

必须写清：

```text
repository SHA
worktree path
exact command
seed/envs/iterations
selected checkpoint path and hash
ONNX path and hash
pass/fail metrics
known failure cases
```
