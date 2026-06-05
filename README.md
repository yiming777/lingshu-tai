# 灵枢台（Lingshu Tai）

**中医 AI 辨证 Agent Skill 家族**

以《灵枢》"经脉为纪、阴阳为纲"之思，构建从四诊到辨证、从方药到针灸、从运气到医案的全流程中医智能辅助系统。

## 项目结构

```
lingshu-tai/
├── skills/                    # 11 个 TCM Skill
│   ├── tcm/                   # 主路由入口
│   ├── tcm-bianzheng/         # 核心辨证（五层漏斗）
│   ├── tcm-wuyun-liuqi/       # 五运六气推算
│   ├── tcm-fangji/            # 方剂推荐
│   ├── tcm-benchi/            # 标本缓急
│   ├── tcm-jianbie/           # 类证鉴别
│   ├── tcm-chaifang/          # 拆方解方
│   ├── tcm-zhenjiu/           # 针灸配穴
│   ├── tcm-save/              # 医案存档
│   ├── tcm-restore/           # 复诊接续
│   └── tcm-report/            # 医案报告
└── dashboard/                 # 粒子全息中控台
    ├── index.html             # 主界面（Three.js）
    ├── server.js              # 桥接服务器（OpenClaw API）
    └── package.json           # 依赖清单
```

## 依赖

- **OpenClaw Gateway** — Agent 运行时
- **DeepSeek V4 Pro** — 推理模型
- **Node.js ≥ 18** — 中控台桥接服务

## 安装

### Skills

```bash
# 复制到 OpenClaw plugin-skills 目录
cp -r skills/tcm* ~/.openclaw/plugin-skills/
openclaw gateway restart
```

### 中控台

```bash
cd dashboard
node server.js
# 浏览器打开 http://localhost:3333
```

## 启动命令速查

```bash
openclaw gateway start              # Gateway
cd dashboard && node server.js      # 中控台
http://localhost:3333               # 中控台界面
http://127.0.0.1:18789              # Gateway Dashboard
```

## 平台

| 项目 | Mac (当前) | Windows |
|------|-----------|---------|
| Gateway | ✅ | 待迁移 |
| Skills | ✅ | 复制即用 |
| Dashboard | ✅ | Node.js 跨平台 |

---

*既济 · 仲图·智衍 · 丙午年*
