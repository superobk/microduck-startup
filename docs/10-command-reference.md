# 10 · 命令速查

| 阶段 | 命令 |
|---|---|
| 主机预检 | `bash scripts/00_preflight_host.sh` |
| 固定版本 clone | `bash scripts/01_clone_upstreams.sh` |
| 官方模型检查 | `bash scripts/20_check_official_models.sh` |
| Browser 安装 | `bash scripts/02_setup_browser.sh` |
| Browser 启动 | `bash scripts/03_run_browser.sh` |
| RL 安装 | `bash scripts/04_setup_rl.sh` |
| RL tests | `bash scripts/05_rl_tests.sh` |
| Smoke | `bash scripts/06_rl_smoke.sh` |
| Walking 训练 | `bash scripts/07_train_walking.sh` |
| 找 checkpoint | `bash scripts/08_find_checkpoint.sh` |
| 导出 ONNX | `bash scripts/09_export_onnx.sh` |
| 验证 ONNX | `uv run python scripts/10_verify_onnx.py MODEL` |
| 官方 ONNX inference | `bash scripts/11_infer_official.sh` |
| 自定义 ONNX inference | `bash scripts/12_infer_custom.sh` |
| 回灌 Browser | `bash scripts/13_install_policy_browser.sh` |
| No-Push worktree | `bash scripts/14_create_no_push_worktree.sh` |
| Manifest | `bash scripts/15_record_manifest.sh` |
| Replica 安装 | `bash scripts/16_setup_replica.sh` |
| Replica 重建 | `bash scripts/17_rebuild_replica.sh` |
| SSH tunnel | `bash scripts/18_ssh_tunnel.sh USER@GPU_HOST` |
| TensorBoard | `bash scripts/19_tensorboard.sh` |
| 静态检查 | `make validate` |
