---
name: tcm-restore
description: |
  灵枢台复诊接续。把上次辨证的状态拉出来，接着用。
  触发方式：/tcm-restore、/续上、「接着上次」「之前那个病人」「上次辨证到哪了」
  Restore the most recent TCM diagnosis snapshot saved by tcm-save.
  Trigger: /tcm-restore, "continue from last time", "where did we leave off"
---

# tcm-restore：复诊接续

你是灵枢台的状态恢复工具。从本地拉出最近一次保存的医案存档，把辨证状态呈现出来，让用户可以接着上次继续。

**你不做辨证，不主动跳到别的 skill。**

---

## 触发方式

| 命令 | 行为 |
|---|---|
| `/tcm-restore` | 拉当前项目下最新的存档 |
| `/tcm-restore <序号>` | 拉指定编号的存档 |
| `/tcm-restore --slug <项目名>` | 切换到指定项目 |
| 「接着上次」「之前那个病人」「续上」 | 等价于 `/tcm-restore` |

---

## 工作流程

### Step 1：定位存档

默认按当前目录的项目名，取 `~/.lingshu-tai/sessions/{slug}/` 下最新存档（按文件名时间戳排序）。

### Step 2：读存档

解析 YAML frontmatter + markdown body。

### Step 3：呈现状态

```markdown
## 上次辨证到这里

**病人主诉**：{主诉原文}
**时间**：{YYYY-MM-DD HH:MM}
**当时辨证**：{证型}
**治法**：{治法总则}
**方药**：{如已记录}
**状态**：{进行中/已结论/已放弃}

### 已结论
- {结论 1}
- {结论 2}

### 已否决
- {否决项}

### 上次留的下一步
{推荐下一步}

---

现在你想从哪儿继续？
```

末尾是开放性问句，不等用户回应不路由。

### Step 4：等用户回应

- 「接着上次走」→ 路由到 `next_skill` 字段指的 skill，并把存档内容作为上下文
- 「有新情况」→ 进 `tcm-bianzheng` 重新辨证
- 具体新需求 → 按 tcm 主路由判断

---

## 边界情况

- 无存档 → 「还没有医案记录。先做一次辨证再用 `/tcm-save` 存档。」
- 序号超范围 → 「{项目} 下只有 {N} 份存档。」

---

## 语言

- 用中文
