# 灵枢台 开发宪章

> 版本：v1.0 | 生效：2026-06-05  
> 本文档约束所有灵枢台 Skill 的开发、外部数据引入、目录结构和命名规范。  
> 原则优先于便利。宁愿多一步清洗，不留一份屎山。

---

## 一、核心原则（不可妥协）

### 1.1 灵枢台为中心

**灵枢台是唯一的框架。** 所有 Skill、所有数据、所有功能，均以灵枢台命名体系和组织结构为准。外部项目（如 nihaisha-tcm）只作为数据来源，不作为架构依赖。

- ✅ 从外部提取数据 → 清洗 → 按灵枢台标准重新组织 → 纳入
- ❌ 依赖外部 repo、外部 API、外部脚本路径

### 1.2 自包含

灵枢台 clone 后应能独立工作。不依赖：
- 外部 Git 仓库的 submodule 或 clone
- 在线 API（除 LLM 本身）
- 特定操作系统路径（用相对路径 + 环境变量）

### 1.3 渐进加载

**SKILL.md 是索引，不是数据库。** 
- SKILL.md ≤ 7KB：核心逻辑 + 路由规则
- references/ 目录：详细数据，按需 `read(offset, limit)`
- 不在上下文里塞不需要的东西

### 1.4 数据先清洗

外部数据引入前必须：
1. 去重 —— 删除与灵枢台已有知识库重复的内容
2. 重命名 —— 统一为灵枢台命名规范
3. 标注来源 —— 每个文件头部标注原始出处和时间
4. 格式转换 —— 转为灵枢台统一的 Markdown 格式

### 1.5 简洁优先

- 一个 Skill 只做一件事
- 能用一个 grep 解决的不写 Python 脚本
- 能用一个文件解决的不建三个
- 命名自解释，不加注释如果名字已经说清楚了

---

## 二、目录结构规范

```
lingshu-tai/
├── DEVELOPMENT.md                    # 本文件
├── README.md                         # 项目说明
├── install.sh / install.ps1          # 安装脚本
│
├── skills/                           # 所有 Skill（每个一个目录）
│   ├── tcm/                          #   主路由
│   │   └── SKILL.md
│   ├── tcm-bianzheng/                #   辨证
│   │   ├── SKILL.md                  #     ≤7KB 核心逻辑
│   │   └── references/               #     按需加载的详细数据
│   │       ├── sizhen-guide.md
│   │       ├── bianzheng-funnel.md
│   │       └── ...
│   ├── tcm-knowledge/                #   知识底座
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── fangji-db.md
│   │       ├── zhongyao-db.md
│   │       └── ...
│   ├── tcm-vision/                   #   视觉证据
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── literature-scans.md   #     自有数据
│   │   │   └── external/             #     外部导入数据（已清洗）
│   │   │       └── nihaisha/
│   │   │           ├── README.md     #       来源说明
│   │   │           └── *.md          #       清洗后的索引
│   │   ├── scripts/                  #     工具脚本
│   │   └── assets/                   #     二进制资源（.gitignore 大文件）
│   └── tcm-template/                 #   新 Skill 模板
│       └── SKILL.md
│
├── dashboard/                        # 中控台（独立应用）
│   ├── index.html
│   └── server.js
│
└── workspace/                        # Workspace 文件模板
    ├── AGENTS.md
    ├── SOUL.md
    └── ...
```

### 2.1 Skill 命名规范

- 前缀 `tcm-`：所有灵枢台 Skill
- 小写字母 + 连字符：`tcm-bianzheng` 不是 `tcm_bianzheng` 或 `TCM-BianZheng`
- 简短自解释：`tcm-fangji` 不取名 `tcm-formula-recommendation`
- 新增 Skill 从 `tcm-template/` 复制

### 2.2 参考文件命名规范

- 描述性文件名：`bianzheng-funnel.md` 不是 `layer3.md`
- 外部数据放 `references/external/<来源>/`，加 README.md 说明来源
- 脚本放 `scripts/`，资源放 `assets/`

### 2.3 输出格式

- Markdown，UTF-8，LF 换行
- 中文正文，代码/路径用英文
- YAML frontmatter 在 SKILL.md 顶部（`---` 包裹）

---

## 三、SKILL.md 编写规范

### 3.1 必需结构

```markdown
---
name: tcm-xxx
description: |
  一句话说明 + 触发方式 + 英文简述
---

# tcm-xxx：简短标题

核心使命（一句话）。

---

## 加载策略

| 场景 | 加载文件 |
|------|---------|
| ... | ... |

---

## Phase 0：入口

...

## Phase N：结束
```

### 3.2 体积约束

| 类型 | 上限 |
|------|:---:|
| SKILL.md | 7KB |
| 单个 references/*.md | 50KB |
| 单个 Skill 的 references/ 总量 | 200KB |
| 嵌入图片/二进制 | 不放 git，用 sync 脚本 |

### 3.3 禁止事项

- ❌ SKILL.md 内含超过 20 行的表格（移到 references/）
- ❌ SKILL.md 内含超过 500 字的连续段落（拆到 references/）
- ❌ 硬编码绝对路径
- ❌ 内嵌 base64 图片
- ❌ 在 Skill 之间循环依赖

---

## 四、外部数据引入标准

### 4.1 引入流程

```
1. 评估：数据是否与灵枢台已有知识重叠？
   ↓ 否 → 可以引入
   ↓ 是 → 只提取增量部分
2. 清洗：去格式 → 重命名 → 标注来源 → 转换路径
3. 放置：references/external/<来源名>/
4. 索引：添加 README.md 说明来源/许可/清洗记录
5. 接入：更新对应 SKILL.md 的加载策略表
```

### 4.2 清洗检查清单

- [ ] 文件名符合灵枢台规范（小写+连字符）
- [ ] 文件头部有来源标注（原始项目 + URL + 导入日期）
- [ ] 引用路径已更新为灵枢台内部路径
- [ ] 没有原项目的绝对路径残留
- [ ] 去除了原项目的 LICENSE/安装脚本等无关文件
- [ ] 纯文本格式符合灵枢台 Markdown 规范
- [ ] 数据与灵枢台已有知识库无冗余（或有明确互补关系）

### 4.3 外部数据存放位置

```
tcm-{模块}/references/external/
├── README.md              # 来源清单 + 清洗记录
├── {来源名}/              # 每个外部来源一个子目录
│   ├── SOURCE.md          # 原始出处 + 许可说明
│   └── *.md               # 清洗后的数据文件
```

---

## 五、nihaisha 数据清洗标准（实例）

### 5.1 已导入数据

| 原始位置 | 清洗后位置 | 处理 |
|---------|-----------|------|
| `nihaisha-tcm/references/*-screenshot-evidence.md` | `tcm-vision/references/external/nihaisha/*.md` | ✅ 路径待更新 |
| `nihaisha-tcm/scripts/search_screenshots.py` | `tcm-vision/scripts/search_nihaisha.sh` | ✅ 重写为 bash |
| `nihaisha-tcm/assets/screenshots/*.webp` | `tcm-vision/assets/nihaisha/` (sync 下载) | ✅ 脚本化 |

### 5.2 待清洗项

- [ ] 索引文件内的路径 `assets/screenshots/` → `tcm-vision/assets/nihaisha/`
- [ ] 索引文件添加来源标注头部
- [ ] 移动 `nihaisha-screenshots/` → `external/nihaisha/`
- [ ] 更新 nihaisha-bridge.md 指向新路径

---

## 六、新增 Skill 流程

```bash
# 1. 从模板复制
cp -r skills/tcm-template skills/tcm-{新名称}

# 2. 编辑 SKILL.md（参考 §三）
# 3. 创建 references/（如需）
# 4. 更新 tcm/SKILL.md 路由表
# 5. 更新 README.md
# 6. git commit -m "新增 tcm-{名称}: {一句话说明}"
```

---

## 七、Git 规范

### 7.1 Commit 格式

```
<类型>: <简短描述>

<详细说明（可选）>
```

类型：`新增` | `修复` | `优化` | `重构` | `文档`

示例：
```
新增 tcm-vision: 视觉证据层——文献扫描+截图索引

优化 tcm-bianzheng: SKILL.md 25KB→7KB，内容外挂 references/
```

### 7.2 禁止提交

- 二进制大文件（>1MB）→ 用 sync 脚本
- API Key / Token / 密码
- 系统临时文件（.DS_Store, Thumbs.db）
- node_modules / vendor 目录

---

*本宪章随灵枢台演进持续修订。修订需要更新版本号和日期。*
