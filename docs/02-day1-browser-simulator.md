# 02 · Day 1 浏览器模拟器：逐行观察指南

## 为什么先跑浏览器

浏览器 simulator 能在不理解 PPO 的情况下先展示完整部署闭环：

```text
state → observation → ONNX actor → action → MuJoCo → next state
```

这样进入训练代码时，你知道训练最终要生成什么，而不是把 PPO 当成孤立算法。

## 安装与运行

```bash
bash scripts/01_clone_upstreams.sh
bash scripts/02_setup_browser.sh
bash scripts/03_run_browser.sh
```

远程访问使用 SSH tunnel，不建议把 Vite 直接监听公网地址。

## 第一次观察

### 1. 启动阶段

观察 BIOS/启动信息：

```text
MuJoCo WASM 是否加载
MJCF 是否解析
mesh assets 是否加载
ONNX policies 是否加载
physics 是否 compile
```

任何一个阶段失败都不要直接归因于“RL 模型不好”。先看 browser console 的网络、WASM 和 shape 错误。

### 2. 站立

在不输入 command 时观察 20–30 秒：

```text
脚是否持续滑动
膝/踝是否抖动
头部是否缓慢下垂
躯干是否有固定方向偏置
```

### 3. Command tracking

依次只给一个 command：

```text
前进
后退
左转
右转
零 command
```

不要同时按多个键，以便确定每个 command slot 的响应。

### 4. Policy switching

测试坐立、踢球、ground pick、翻滚和起身。观察这些不是 walking policy “临时学会了动作”，而是程序换到不同 ONNX session。

## 阅读 `constants.js`

```bash
grep -nE 'POLICIES|JOINT_NAMES|DEFAULT_POSE|OBS_SIZE|CMD_SIZE|ACTION_SCALE|TIMESTEP|DECIMATION' \
  work/upstream/MicroDuckModels/src/game/constants.js
```

逐项确认：

```text
POLICIES      哪个行为对应哪个 ONNX
JOINT_NAMES   14 个输出的顺序
DEFAULT_POSE  action 的 reference
OBS_SIZE      61
CMD_SIZE      13
ACTION_SCALE  1.0
TIMESTEP      0.005
DECIMATION    4
CTRL_DT       0.02
```

## 阅读 `game.js`

```bash
grep -nE 'bootGame|InferenceSession|buildPhysicsXml|buildObs|activeSession|controlStep|session.run|data.ctrl|mj_step|recovery' \
  work/upstream/MicroDuckModels/src/game/game.js
```

阅读顺序：

1. `bootGame`：初始化入口；
2. `buildPhysicsXml`：浏览器如何动态准备 MJCF；
3. `InferenceSession.create`：ONNX sessions；
4. `resolveAddrs`：joint/sensor address；
5. `buildObs`：61D tensor；
6. `activeSession`：当前策略；
7. `controlStep`：推理、action、physics；
8. recovery state machine。

## 61D 观察向量核对

`buildObs` 应依次填入：

```text
0:3    angular velocity
3:6    projected gravity
6:20   joint position - default pose
20:34  joint velocity
34:48  last action
48:61  command
```

自己在纸上写出 index range。以后修改任何部署端时都用这张表核对。

## 最有价值的小实验：Action Scale

先保存源文件：

```bash
cp work/upstream/MicroDuckModels/src/game/constants.js \
   work/state/constants.js.before-action-scale
```

把：

```javascript
export const ACTION_SCALE = 1.0;
```

临时改为：

```javascript
export const ACTION_SCALE = 0.7;
```

重新运行，观察步幅和 tracking。再测试 1.3。结束后恢复：

```bash
git -C work/upstream/MicroDuckModels restore src/game/constants.js
```

实验结论应是：

> ONNX 权重不是完整控制系统。相同权重在不同 action scale、default pose、joint order 或 control frequency 下会表现完全不同。

## Learned 与 Hand-written 边界

### Learned

```text
walking
stand/recovery motion
sitstand
kick
roulade
ground pick
roller motion
```

### Hand-written

```text
input mapping
command smoothing
policy switching
fall threshold/debounce
timeout/reset
50 Hz scheduler
scene/ball/camera/UI
```

## Day 1 浏览器验收

- [ ] 能指出 61D 的每个区间；
- [ ] 能列出 14 个 joint 顺序；
- [ ] 能解释 `DEFAULT_POSE + action * scale`；
- [ ] 能解释 0.005×4=0.02 s；
- [ ] 能区别 policy 和 state machine；
- [ ] 完成 action-scale 实验并恢复 source。
