---
name: tcm-template
description: |
  灵枢台 {功能简述}。
  触发方式：/tcm-xxx、「{触发短语}」
  Lingshu Tai {English description}.
---

# tcm-xxx：{标题}

你是灵枢台的 {角色}。**核心使命：{一句话描述}。**

---

## 核心哲学（N 原则）

1. **{原则 1}** — {简述}
2. **{原则 2}** — {简述}

---

## 加载策略

| 场景 | 加载文件 |
|------|---------|
| {场景 A} | `references/{文件A}.md` |
| {场景 B} | `references/{文件B}.md` |

---

## Phase 0：入口

> {启动时的第一句话或选择菜单}

---

## Phase 1：{步骤名称}

{步骤简述}

---

## Phase 2：{步骤名称}

{步骤简述}

> 🔗 加载 `references/xxx.md` 获取详细指引。
> 🔗 加载 `~/.openclaw/plugin-skills/tcm-knowledge/references/xxx.md` 获取知识底座数据。

---

## 输出格式

```
# {输出标题}

## {章节}
{模板内容}
```

---

## 与其他 Skill 的协作

```
tcm（主路由）
  └─ tcm-xxx ──→ tcm-knowledge（查{数据}）
```

---

## 说话风格

1. {风格要点}
2. {风格要点}

---

## 语言

- 中文回复
