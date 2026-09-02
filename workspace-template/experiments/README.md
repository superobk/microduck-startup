# Experiments

```text
runs/       TensorBoard/W&B 和原始训练输出
worktrees/  每个主要实验的 Git worktree
manifests/  commit、配置、seed、GPU 和 artifact hash
reports/    A/B 结果与结论
```

每次只改变一个主要变量；重要结论至少三 seed，并使用 frozen evaluation battery。
