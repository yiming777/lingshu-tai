# MEMORY.md — 仲图·智衍 长期记忆

## 我是谁
- 仲图·智衍，一铭的跨学科AI智囊
- M.D. + AI/ML Ph.D. + 中医博士三重知识体系
- 融合西医临床推理、中医辨证论治、计算机工程能力
- Emoji: 🧬⚡🌿

## 一铭
- 临床中医师 + 科技公司CEO
- 时区：GMT+8（上海）
- 核心需求：临床辨证辅助 + 中医AI系统开发 + 计算机视觉（舌象/面象）+ 医疗数据收集
- GitHub：yiming777
- 偏好：学术深度但要可落地，病证结合视角，决策导向

## 灵枢台
- 2026-06-04 设计并构建完成
- 11 个 TCM Skill：tcm（路由）、tcm-bianzheng（辨证）、tcm-wuyun-liuqi（五运六气）、tcm-fangji（方剂）、tcm-benchi（标本缓急）、tcm-jianbie（类证鉴别）、tcm-chaifang（拆方）、tcm-zhenjiu（针灸）、tcm-save（存档）、tcm-restore（复诊）、tcm-report（报告）
- 架构灵感来自 dbskill（商业诊断工具箱），但独立设计
- GitHub：github.com/yiming777/lingshu-tai
- 医案存档：~/.lingshu-tai/sessions/
- Obsidian 医案：~/Documents/Obsidian Vault/灵枢台医案/

## 粒子全息中控台
- 路径：`~/openclaw/workspace/particle-dashboard/index.html`
- 启动：`cd ~/openclaw/workspace/particle-dashboard && python3 -m http.server 3333` → http://localhost:3333
- 396行单文件，Three.js CDN 零依赖
- **CONFIG 对象**在代码顶部，所有参数集中管理（particle/camera/controls/bloom/beidou/flow）
- 33333粒子无极⇄太极连续流场 + 北斗七星6功能节点 + 北极星脉动
- 配色：太极黑白灰，AdditiveBlending + Bloom辉光
- UI：灵枢台标题居中 + 黄历栏 + 命令行，极简无重复
- 快捷键：F 复位视角，R 切换自动旋转，点击节点激活模块
- OpenClaw（Gateway 模式，本地 loopback，Dashboard 18789）
- 模型：DeepSeek V4 Pro
- Tavily 搜索已配
- VS Code CLI 已装，Obsidian 已连
- Git + GitHub（gh CLI token 认证，需代理推）
- ClashX 代理：127.0.0.1:7890

## 首个临床病例
- 2026-06-04：男，30岁，脾肾阳虚泄泻
- 完整走了五层辨证漏斗 → 附子理中汤合四神丸加减
- 已存档到 Obsidian 和灵枢台归档系统
- 效果待复诊验证

## 记忆规则
- **每次对话结束/项目阶段性完成后**：必须更新 memory/YYYY-MM-DD.md（日志）+ 必要时更新 MEMORY.md（长期记忆）
- **新病例** → 当日日志记录辨证结论+方药
- **技术变动** → 更新 TOOLS.md
- **重要决策** → 更新 MEMORY.md
- **目标**：信息对称，醒来即知上下文

## 待办
- 将灵枢台 skills 在 Skill Workshop 中正式 approve（目前 pending）
- 积累更多临床病例验证辨证漏斗的有效性
- 构建知识库（方剂/中药/证型/经典条文）
- 考虑 Channels 配置（是否需要手机端访问）

---

*初次建立于 2026-06-04*
