# 07 · 机械复刻模块

## 定位

`microduck-replica` 从公开 MJCF 和 STL 中恢复：

```text
运动学树
局部/世界变换
刚体分组
质量和惯量
装配/爆炸图
CAD 可导入 assembly STL
孔特征与紧固件推断
硬件/电控线索
```

它对理解仿真非常有价值，但不是经过实物装配验证的 manufacturing release。

## 准备

```bash
bash scripts/16_setup_replica.sh
```

脚本建立 venv，并把已固定的官方 upstream 连接到 replica 的 `upstream/` 目录，避免其内部 fetch 脚本重新拉取浮动版本。

## 重建

```bash
bash scripts/17_rebuild_replica.sh
```

执行：

```text
render_assembly.py
export_assembly_stl.py
analyze_holes.py
```

## 应重点学习

### MJCF tree

```text
body parent/child
joint axis/range
geom transform
inertial mass/inertia
site/sensor
actuator
```

### World transform

上游 STL 多为零件局部坐标。直接导入 CAD 会堆在原点。脚本从 MJCF 计算 geom 世界变换再导出。

### 15 舵机 vs 14 action

walking policy 控制 14 个腿/头颈关节；喙/下颚舵机不进入 locomotion action vector。

### 高重心

头部 assembly 占据显著质量，walking 时头部 tracking、CoM randomization 和 dynamic motion regularization 都必须尊重真实物理，不可简单套用大尺寸人形机器人的直觉。

## 不能直接假定的内容

```text
STL 水密和可打印性
孔径补偿
打印收缩
螺丝长度
热熔螺母结构
轴承压配
线束弯折半径
内部走线
PCB Gerber/原理图
实体 sim2real
```

## 许可证提醒

机械图、CAD/STL 衍生内容可能继承上游 CC BY-SA-NC。不要把本启动仓库的 Apache-2.0 当成这些资产的商用许可。
