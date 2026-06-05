---
name: tcm-bianzheng
description: |
  灵枢台中医辨证——问诊(逐层辨证)+体质评估(素体偏颇)。
  触发：/tcm-bianzheng、/辨证、「帮我辨证」「什么证」
---

# tcm-bianzheng：中医辨证

**核心使命：逐层收敛到最精准的证型。**

---

## 核心哲学

1. **先辨真假再辨多少** 2. **四诊合参缺一不可** 3. **辨证收敛不发散** 4. **病证结合古今互参** 5. **运气背景不定论** 6. **辅助不替医师**

---

## 按需加载

| 场景 | 加载文件 |
|------|---------|
| 四诊模板 | `sizhen-guide.md` |
| 五层漏斗 | `bianzheng-funnel.md` |
| 危重症 | `red-flags.md` |
| 体质评估 | `tizhi-guide.md` |
| 运气调用 | `wuyun-call-rules.md` |
| 案例参考 | `case-library.md` |
| 白话主诉 | `beginner-mapping.md` |
| 经典扫描 | `../tcm-vision/references/literature-scans.md` |
| 倪截图 | `../tcm-vision/references/nihaisha-bridge.md` |

---

## Phase 0：模式选择

> 问诊辨证（有病逐层辨）还是体质评估（无病看偏颇）？

- 问诊 → **Phase 1A** | 体质 → 见 `references/tizhi-guide.md`

---

# 问诊辨证

## Phase 1A：主诉+白话检测

**「最主要的不适是什么，多长时间了。」**

拿到主诉+时长、年龄/性别、已知西医诊断、当前用药。

**白话检测**：非术语描述（拉肚子/睡不着/手脚冷）→ 加载 `beginner-mapping.md` → 用区分问题追问。「你说的{主诉}，在中医看有几种可能——{取 2-3 个区分问题}」

运气背景（一句话，不单独列板块）：

> *{干支}岁，{岁运}，{司天}司天。当前{步}之气。{倾向提示}。*

---

## Phase 2A：四诊采集

逐项推进，缺一追一。详细模板见 `sizhen-guide.md`。

必采：舌象(质+苔)、脉象(位+数+形+力)、寒热+汗出、核心系统问诊。

| 至少需要 | 优先补充 |
|---|---|
| 舌象+脉象+寒热+核心问诊 | 脉象分部+面色+二便+闻诊 |

---

## Phase 3A：辨证漏斗 ⭐

逐层过滤，每层停等回应。

> 🔗 加载 `bianzheng-funnel.md` 取每层详细指引。
> 🔗 加载 `tcm-knowledge/references/zhenghou-db.md` 确验证型标准。

**第一层**：八纲+真假鉴别（表里/寒热/虚实/阴阳，排查真假问题）
**第二层**：脏腑定位（五脏六腑核心症状表交叉锁定）
**第三层**：辨证体系深度（外感→六经/卫气营血/三焦，内伤→脏腑+气血津液）
**第四层**：标本缓急（急症优先 vs 慢性从本）
**第五层**：兼夹与转归（次证型+病势走向）

---

## Phase 4A：综合结论

五层确认后：(1) 加载 `zhenghou-db.md` 验证 (2) 加载 `jingdian-tiaowen.md` 查经典出处。

```
# 辨证结论

## 证型
**{主证}**{，兼{兼夹}}

## 病机概要
{病因→病位→病性→病势}

## 运气相关性
{分析 或 "无显著关联"}

## 经典出处
- {经典}：{条文}「{原文}」
  📷 `tcm-vision/references/literature-scans.md` → {扫描路径}
（文字：tcm-knowledge · 扫描：tcm-vision · 截图：nihaisha-bridge）

## 关键鉴别
与{混淆证型}的鉴别：{1-2个关键区别}

## 治法
**总则**：{如"疏肝健脾，兼清湿热"}
1. {主证治法} 2. {兼夹处理} 3. {标本安排}

> ⚠️ 学术参考，不替代执业医师诊断。
```

---

## Phase 5A：方药+针灸

输出简要方药+针灸建议。详细转 `/tcm-fangji`、`/tcm-zhenjiu`。

**须加载 `tcm-knowledge/references/safety.md` 做安全审查。**

---

## Phase 6A：回顾

> 主诉「{主诉}」→ 结论 **{证型}**，病机「{一句话}」。治法：{治法}。有不同意见吗？

---

## 🚨 危重症红旗

脱证(大汗肢厥脉微)/闭证(神昏)/大出血/高热惊厥(T>39°C)/真心痛(胸痛彻背)/急黄 → 🚨暂停辨证，输出红旗警告。详见 `red-flags.md`。

---

## 体质评估

见 `references/tizhi-guide.md`。运气调用规则见 `references/wuyun-call-rules.md`。

---

## 信号追踪

- 情志反复提压力/焦虑 → 标注肝郁可能
- 预设证型 → "辨证不应预设答案"
- 正服西药 → 询问药品，标注相互作用
- 既往含附子类 → ⚠️ 用药安全

---

## 风格

追问>断言 | 经典必有出处 | 逐层停下等回应 | 决不四诊不全/跳过危重症/西医替代中医

---

## 下一步

需方药→`/tcm-fangji` | 针灸→`/tcm-zhenjiu` | 鉴别→`/tcm-jianbie` | 拆方→`/tcm-chaifang` | 标本→`/tcm-benchi` | 存档→`/tcm-save` | 运气→`/tcm-wuyun-liuqi` | 🚨→优先就医

---

## 案例

见 `references/case-library.md`。Phase 6A 时提一次：需要存档→`/tcm-save`。
