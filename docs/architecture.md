# 灵枢台 系统架构

> 版本：v1.0 | 更新：2026-06-05

---

## 一、Skill 依赖与数据流

```
用户输入
  │
  ▼
┌─────────────────────────────────────────────────────────────┐
│  tcm（主路由）                                               │
│  识别意图 → 分发到子 Skill                                   │
└──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────────┘
       │      │      │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼      ▼      ▼
   bianzheng wuyun  fangji zhenjiu jianbie chaifang benchi
   （辨证）  （运气）（方剂）（针灸）（鉴别）（拆方）（标本）
       │              │                      
       │    ┌─────────┴──────────┐           
       │    ▼                    ▼           
       │  knowledge            vision        
       │  （知识底座）          （视觉证据）   
       │    │                    │           
       │    ├─ fangji-db        ├─ literature-scans
       │    ├─ zhongyao-db      ├─ nihaisha screenshots
       │    ├─ jingdian-tiaowen └─ (舌象/面象图库·待建)
       │    ├─ zhenghou-db
       │    ├─ safety
       │    └─ external/nihaisha/
       │         ├─ clinical-cases
       │         ├─ symptom-index
       │         ├─ fangji-ni-annotations
       │         ├─ tiaowen-ni-annotations
       │         └─ tianji
       │
       ├──────────────────────┐
       ▼                      ▼
     save                   restore
    （存档）                （复诊）
       │                      │
       └──────────┬───────────┘
                  ▼
               report
              （报告）
```

---

## 二、模块职责

| 模块 | 类型 | 职责 | 依赖 |
|------|------|------|------|
| **tcm** | 路由 | 意图识别→分发子 Skill | 无 |
| **tcm-bianzheng** | 核心 | 五层漏斗辨证 | knowledge, vision, wuyun-liuqi |
| **tcm-wuyun-liuqi** | 核心 | 五运六气推算+时病预测 | 无（速查表自含） |
| **tcm-fangji** | 执行 | 方剂推荐+安全审查 | knowledge |
| **tcm-zhenjiu** | 执行 | 针灸配穴+补泻手法 | knowledge |
| **tcm-jianbie** | 执行 | 类证鉴别 | knowledge |
| **tcm-chaifang** | 执行 | 拆方解方+药对分析 | knowledge |
| **tcm-benchi** | 执行 | 标本缓急分析 | 无 |
| **tcm-save** | 持久化 | 医案存档（Markdown + frontmatter） | 无 |
| **tcm-restore** | 持久化 | 复诊接续 | save |
| **tcm-report** | 持久化 | 多案合并报告 | save |
| **tcm-knowledge** | 数据 | 知识底座（方/药/经/证/安全） | 无 |
| **tcm-vision** | 数据 | 视觉证据索引 | 无 |
| **tcm-template** | 工具 | 新 Skill 骨架模板 | 无 |

---

## 三、数据流向

```
辨证流程（完整链路）：
  
  用户主诉
    → tcm（路由）
      → tcm-bianzheng（Phase 1A-6A）
        ├─ Phase 3A: 加载 zhenghou-db.md 验证证型
        ├─ Phase 4A: 加载 jingdian-tiaowen.md 查经典出处
        │           加载 literature-scans.md 查扫描路径
        ├─ Phase 5A: 加载 safety.md 做安全审查
        └─ Phase 6A: → /tcm-save 存档
                     → /tcm-fangji 详细方药

方剂推荐流程：
  
  辨证结论
    → tcm-fangji
      ├─ Phase 0: 加载 fangji-db.md 查方剂组成
      ├─ Phase 6: 加载 safety.md + safety-review.md 审查
      └─ 开方结论 → /tcm-chaifang 拆方

知识查询流程：
  
  查询请求
    → tcm-knowledge
      ├─ 方剂查询 → fangji-db.md + fangji-ni-annotations.md
      ├─ 药物查询 → zhongyao-db.md
      ├─ 条文查询 → jingdian-tiaowen.md + tiaowen-ni-annotations.md
      ├─ 证型查询 → zhenghou-db.md
      ├─ 安全查询 → safety.md
      └─ 临床案例 → clinical-cases-part1/2.md
```

---

## 四、外部数据来源

| 来源 | 导入位置 | 内容 | 清洗状态 |
|------|---------|------|:---:|
| nihaisha-tcm | `tcm-vision/external/nihaisha/` | 2986 截图证据索引 | ✅ |
| nihaisha-tcm | `tcm-knowledge/external/nihaisha/` | 临床案例+症状路由+方剂注解+条文注解+天纪 | ✅ |

---

## 五、文件体积预算

| 层级 | 上限 | 当前最大 |
|------|:---:|:---:|
| SKILL.md | 7KB | 6KB (tcm-fangji) |
| 单个 references/*.md | 50KB | 56KB (clinical-cases-part2) |
| 单个 Skill references 总量 | 200KB | ~120KB (tcm-knowledge) |
| 外部数据目录 | — | ~120KB (external/nihaisha/) |

---

## 六、关键技术决策记录

| 日期 | 决策 | 理由 |
|------|------|------|
| 2026-06-04 | 以 tcm- 前缀 + 小写连字符命名 | 统一、可 grep、与 OpenClaw 兼容 |
| 2026-06-04 | 五层辨证漏斗（八纲→脏腑→体系→标本→兼夹） | 逐层收敛，防止辨证跳跃 |
| 2026-06-05 | SKILL.md ≤7KB + references/ 按需加载 | 控制上下文体积，避免 token 浪费 |
| 2026-06-05 | 外部数据先清洗再纳入 | 自包含、不依赖外部 repo |
| 2026-06-05 | nihaisha 数据全部吸收（不桥接） | 宪章 §1.2 自包含原则 |
| 2026-06-05 | 采用 Conventional Commits | 对齐开源标准，自动化 changelog 可行 |
