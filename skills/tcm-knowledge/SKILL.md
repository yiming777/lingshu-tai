---
name: tcm-knowledge
description: 灵枢台知识底座——方剂数据库、中药数据库、经典条文索引、证型定义、安全分级清单。辨证、方剂推荐、拆方解方时调用，提供循证背书。
metadata:
  tcm_role: knowledge-base
  emoji: 📚
---

# 灵枢台 · 知识底座

## 定位

本 skill 是灵枢台的知识存储层。任何需要查询方剂组成、中药性味、经典出处、证型定义的地方，都从这里取数据，不做裸推理。

## 核心原则

- **辨必有据**：每个辨证结论应能回溯到经典条文或方药数据
- **检索优先**：先查 `references/`，找不到时明确标注"据现有知识库推断"
- **渐进加载**：不需要的参考文件不读，按需打开

## 路由规则

| 查询类型 | 打开文件 | 何时用 |
|---------|---------|--------|
| 方剂组成、功效、剂量、煎服法 | `references/fangji-db.md` | 辨证完成，需要开方时 |
| 中药性味归经、功效、禁忌（查INDEX） | `references/zhongyao/INDEX.md` | 先查索引定位，再按文件/行号取具体药 |
| 解表/泻下药全文 | `references/zhongyao/zhongyao-biao-li-re.md` | 拆方、加减、药性分析（27味） |
| 清热药全文 | `references/zhongyao/zhongyao-qing-re.md` | 拆方、加减、药性分析（33味） |
| 祛风湿/利水渗湿药全文 | `references/zhongyao/zhongyao-shi-wen.md` | 拆方、加减、药性分析（31味） |
| 化湿/温里药全文 | `references/zhongyao/zhongyao-wen-hua.md` | 拆方、加减、药性分析（16味） |
| 理气/消食药全文 | `references/zhongyao/zhongyao-qi-xue.md` | 拆方、加减、药性分析（22味） |
| 止血/活血化瘀药全文 | `references/zhongyao/zhongyao-huo-xue.md` | 拆方、加减、药性分析（23味） |
| 化痰/安神/平肝熄风药全文 | `references/zhongyao/zhongyao-tan-shen-feng.md` | 拆方、加减、药性分析（34味） |
| 补虚药全文 | `references/zhongyao/zhongyao-bu-yi-se.md` | 拆方、加减、药性分析（35味） |
| 收涩药全文 | `references/zhongyao/zhongyao-shou-se.md` | 拆方、加减、药性分析（10味） |
| 开窍药全文 | `references/zhongyao/zhongyao-kai-qiao.md` | 拆方、加减、药性分析（4味） |
| 经典条文引用 | `references/jingdian-tiaowen.md` | 需要引用出处佐证辨证时 |
| 证型标准定义 | `references/zhenghou-db.md` | 辨证时需要确认证型诊断标准 |
| 安全警告 | `references/safety.md` | 开出高风险方药时 |
| 倪海厦临床案例 | `references/external/nihaisha/clinical-cases-part1.md` 或 `part2.md` | 辨证/方剂时需参考倪海厦医案佐证 |
| 症状→六经路由 | `references/external/nihaisha/symptom-index.md` | 症状模糊时按六经维度快速定位 |
| 倪海厦方剂注解 | `references/external/nihaisha/fangji-ni-annotations.md` | 查方剂时附加倪海厦临床视角 |
| 倪海厦条文注解 | `references/external/nihaisha/tiaowen-ni-annotations.md` | 查经典条文时附加倪海厦解读 |

## 加载策略

1. 先打开 `references/index.md` 确认数据覆盖范围
2. 按需打开对应的数据文件
3. 用 `read` 带 `offset` 和 `limit` 参数精确定位，避免全量加载

## 与其他 Skill 的协作

```
tcm（主路由）
  ├─ tcm-bianzheng（辨证）────→ tcm-knowledge（查证型定义+经典条文）
  ├─ tcm-fangji（方剂推荐）───→ tcm-knowledge（查方剂组成+中药数据）
  ├─ tcm-chaifang（拆方解方）→ tcm-knowledge（查药性归经+配伍禁忌）
  ├─ tcm-zhenjiu（针灸配穴）──→ tcm-knowledge（查穴位定位+经络）
  └─ tcm-report（医案报告）───→ tcm-knowledge（附加经典出处）
```

## 更新记录

- v0.1 (2026-06-05)：初始版本——方剂 30+ 首、中药 80+ 味、伤寒金匮条文 50+ 条、证型 30+ 种
