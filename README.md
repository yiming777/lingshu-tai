# 灵枢台（Lingshu Tai）

**中医 AI 辨证 Agent Skill 家族**

以《灵枢》"经脉为纪、阴阳为纲"之思，构建从四诊到辨证、从方药到针灸、从运气到医案的全流程中医智能辅助系统。

---

## 架构

```
灵枢台（tcm）
├── tcm-bianzheng      ← 核心辨证（八纲/脏腑/六经/卫气营血/三焦）
├── tcm-wuyun-liuqi    ← 五运六气推算 + 时气病预测
├── tcm-fangji         ← 方剂推荐 + 加减化裁
├── tcm-benchi         ← 标本缓急分析
├── tcm-jianbie        ← 类证鉴别
├── tcm-chaifang       ← 拆方解方
├── tcm-zhenjiu        ← 针灸配穴
├── tcm-save           ← 医案存档
├── tcm-restore        ← 复诊接续
└── tcm-report         ← 医案报告合并
```

## 设计哲学

- **逐层收敛**：从八纲到脏腑到六经，层层缩小辨证空间，禁止跳跃
- **运气为背景**：自动嵌入当前五运六气格局，提供时气参照
- **病证结合**：西医诊断锚定病种，中医辨证锁定证型，互不替代
- **辅助定位**：所有结论为学术参考，不替代执业医师

## 使用方式

在支持 Skill 的 Agent 平台（OpenClaw / Claude Code / Codex / Cursor 等）中安装后，通过指令触发：

- `/tcm` — 主路由
- `/tcm-bianzheng` — 辨证
- `/tcm-wuyun-liuqi` — 运气推算
- ……

## 作者

仲图·智衍（一铭）
