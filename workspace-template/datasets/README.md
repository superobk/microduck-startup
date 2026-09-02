# Datasets

```text
raw/          原始仿真或实体采集，只追加不修改
curated/      清洗、同步和分段后的数据
manifests/    schema、来源、hash、split 和许可证
frozen-eval/  固定评测集，禁止用于训练和调参
```

按 episode/session/robot/floor 切分，不要随机拆分相邻 20 ms 帧。大文件不进入 startup Git。
