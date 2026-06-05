# 灵枢台（Lingshu Tai）

**中医 AI 辨证 Agent Skill 家族**

以《灵枢》"经脉为纪、阴阳为纲"之思，构建从四诊到辨证、从方药到针灸、从运气到医案的全流程中医智能辅助系统。

---

## 快速安装

```bash
# 克隆
git clone https://github.com/yiming777/lingshu-tai.git
cd lingshu-tai

# 一键安装（Skills + Workspace 文件）
bash install.sh
```

**Windows**：
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

### 安装选项

| 选项 | 说明 |
|------|------|
| `--dry-run` | 模拟运行，查看会安装哪些文件 |
| `--skills-only` | 只安装 Skills，跳过 workspace |
| `--workspace-only` | 只安装 workspace 文件 |
| `--no-restart` | 安装后不重启 Gateway |

---

## 项目结构

```
lingshu-tai/
├── install.sh / install.ps1     # 一键安装脚本
├── skills/                      # 12 个 TCM Skill
│   ├── tcm/                     # 主路由入口
│   ├── tcm-bianzheng/           # 核心辨证（五层漏斗）
│   │   └── references/          #   - 四诊采集 · 漏斗手册 · 红旗信号 · 案例库
│   ├── tcm-wuyun-liuqi/         # 五运六气推算
│   │   └── references/          #   - 干支/运气/用药速查表
│   ├── tcm-knowledge/           # 知识底座
│   │   └── references/          #   - 方剂49首 · 中药113味 · 条文54条 · 证型35+种 · 安全清单
│   ├── tcm-fangji/              # 方剂推荐 + 安全审查
│   ├── tcm-benchi/              # 标本缓急
│   ├── tcm-jianbie/             # 类证鉴别
│   ├── tcm-chaifang/            # 拆方解方
│   ├── tcm-zhenjiu/             # 针灸配穴
│   ├── tcm-save/                # 医案存档
│   ├── tcm-restore/             # 复诊接续
│   └── tcm-report/              # 医案报告
├── dashboard/                   # 粒子全息中控台
│   ├── index.html               # 主界面（Three.js 3D 粒子场）
│   └── server.js                # 桥接服务器（OpenClaw API）
└── workspace/                   # Workspace 文件模板
    ├── AGENTS.md · SOUL.md · IDENTITY.md · USER.md
    ├── MEMORY.md · TOOLS.md · HEARTBEAT.md
    └── memory/
```

---

## 启动

```bash
# Gateway
openclaw gateway start

# 中控台
cd dashboard && node server.js
# → http://localhost:3333

# WebChat Dashboard
open http://127.0.0.1:18789
```

---

## 使用

在 WebChat 或中控台命令行输入：

```
/tcm                        → 打开灵枢台主菜单
帮我辨证一下                → 启动五层辨证漏斗
查今年运气                  → 五运六气推算
用什么方                    → 方剂推荐（含安全审查）
拆解这个方子：麻黄汤        → 拆方解方
```

---

## 架构亮点

| 特性 | 说明 |
|------|------|
| **五层辨证漏斗** | 八纲→脏腑→体系→标本→兼夹，逐层收敛 |
| **辨必有据** | 120KB 知识底座（方剂+中药+经典条文+证型标准） |
| **分级安全审查** | 三级风险判定 + 十八反/十九畏 + 妊娠/儿童/老人 |
| **按需加载** | SKILL.md ≤7KB，详细数据在 references/ 目录 |
| **运气整合** | 五运六气推算 + 时病预测 |
| **全息中控台** | Three.js 粒子场 + 命令行桥接 Gateway API |

---

## 依赖

- **OpenClaw** (`npm install -g openclaw`)
- **DeepSeek V4 Pro**（API Key）
- **Node.js ≥ 18**（中控台桥接服务）

---

## 平台

| 平台 | Skills | 中控台 | 安装 |
|------|:------:|:------:|:----:|
| macOS | ✅ | ✅ | `bash install.sh` |
| Linux | ✅ | ✅ | `bash install.sh` |
| Windows | ✅ | ✅ | `install.ps1` |

---

*既济 · 仲图·智衍 · 丙午年*
