# claim-basis

Claude Code custom skill for structured claim-basis (Anspruchsgrundlage) analysis under the Chinese Civil Code. Originally scoped to the Contract Book (Articles 463–988), now also covers the **Property Book** (返还原物、占有保护、善意取得、占有回复) and the **Tort Liability Book** (过错/无过错侵权、数人侵权、第三人侵害债权、损害赔偿计算), plus quasi-contract (无因管理、不当得利) and related General-Part rules (第157条等).

## Structure

- `SKILL.md` — Lean navigation layer: analysis framework, claim-basis index, **reference routing table**, concurrence rules
- `references/`
  - `ref-norm-types.md` — 18-category norm-type guide
  - `ref-contract-claims.md` — Contract Book + quasi-contract catalog (general provisions, sale/lease/loan/suretyship)
  - `ref-property-rights.md` — Property Book catalog (real-rights protection, good-faith acquisition, possession)
  - `ref-tort-liability.md` — Tort Book catalog (general/special torts, joint tort liability, damages)
  - `ref-damages-calculation.md` — Damages quantification methodology (履行/信赖/固有利益、替代交易抽象vs具体计算、合同编通则解释60-62、人身/精神损害)
  - `ref-concurrence.md` — Authoritative concurrence handling (规范竞合/请求权竞合/请求权聚合三分、违约vs侵权择一门槛与后果、禁止重复受偿)
  - `ref-*.md` — Contract-type-specific provisions (contracting, transport, technology, agency, storage, others)
  - `ref-case-examples.md` — Worked scenario analyses
  - `report-template.md` — Structured report template
- `source/annotated-code.md` — Full Civil Code text with 2,772 norm-type annotations (25,915 lines)
- `test/` — 4 evaluation scenarios with reference analysis paths

## Usage

This skill activates automatically in Claude Code when a user asks about civil dispute analysis under the Civil Code (contract performance/breach/termination, restitution, real-rights recovery, good-faith acquisition, tort liability, unjust enrichment, etc.). Follow the quick-start checklist in `SKILL.md`, loading references on demand via the routing table — do not load every reference at once.

## Development

Run evaluations with the scenarios in `test/`. See `test/README.md` for the evaluation methodology.

## Roadmap / 待办（已知缺口与日后计划）

### 1. 担保物权专项 reference（`ref-security-rights.md`，待制作）

**现状缺口**：本 skill 目前缺少担保领域的专门 reference。担保物权（抵押/质押/留置）与保证的**法条骨架**在 `source/annotated-code.md`（民法典担保物权编第386–457条、保证合同第681–702条，含规范类型标注），但**裁判操作规则大量沉淀在《民法典担保制度司法解释》(法释〔2020〕28号，71条) 与九民纪要（担保部分 §31–58）**，而这两份**原文目前不在仓库**，仅在标注的"关联条文"中被编号提及。

**风险提示（来自实战教训）**：曾在分析指导案例168号时**凭记忆"复述"担保解释条文，结果条号/措辞不可靠（幻觉）**。故制作本 reference 的**前置条件**是先补权威法源，不得凭记忆杜撰司法解释条文。

**计划路径**（按优先级）：
1. **补法源**：将《担保制度司法解释》《九民纪要（担保部分）》原文纳入 `source/`，再据此撰写完整 reference（设立与登记效力、未登记的违约赔偿、动产/权利/应收账款质权、留置权、混合共同担保的清偿与内部追偿、公司对外担保决议、流押流质条款转化、担保物权顺位竞存等）。
2. **过渡方案**（暂无法源时）：先做"**法条骨架版**"——仅整理民法典担保物权编 + 保证合同的条文与规范类型，并**显式标注"裁判细则见担保解释/九民纪要，需另行查证"**，不臆造解释条文。
3. **案例集**：随权威案例逐个补充范式。

**已落地的起点**：`references/ref-case-examples.md §5.8` 已沉淀指导案例168号（抵押合同有效但未登记→违约赔偿责任，抵押物价值为限 + 债权人过错过失相抵减责）。

### 2. 输出报告须严格套用模板（已强化，持续校验）

`SKILL.md §0` 已将"按 `references/report-template.md` 结构输出"设为强制约束（先 Read 模板再写、四段式齐全、附引用规范表）。后续评估时应抽查输出是否真正遵循模板，而非自创表格式排版。

### 3. 评估体系（`test/`）的扩充与完善（待办）

**现状**：仅 4 个 eval，全部集中在合同编（买卖瑕疵、租赁返还、撤销返还、违约方解除），无自动化、靠人工跑。skill 已扩至物权编/侵权编/准合同/担保，但评估未跟上 → 这些领域改动时无回归保护。

**已识别的不足**：
1. **覆盖结构性缺失**：物权（善意取得311、占有保护462 vs 所有权235、占有回复458-461、添附322）、侵权（特殊侵权·过错推定/无过错、责任成立→范围两阶层、公平责任边界1186、数人侵权1168-1172）、损害赔偿计算、担保（指导案例168号）均**无 eval**——而其中多数已有现成 reference 与案例范式（5.4-5.8）可直接转化。
2. **Eval-01 数据自相矛盾**：`query` 写"总价 300 万元"单份合同，`ref.md` 却按"153万+147万 两份合同"展开 → 需对齐修复。
3. **"剧本式"评分**：`expected_behavior` 固化单一路径，可能奖励复述、惩罚"结论正确但路径不同"，测的是方法符合度而非法律正确性。
4. **无合格线/权重**：README 未定义几项算过、未区分核心项与加分项。
5. **自评不可靠 + 无自动化**：易出现"出题人即阅卷人"偏向。
6. **缺反向/陷阱题**：无"请求权不成立""防误触发（刑事/行政）""干扰事实稳健性"类测试。
7. **依赖题外假设**：如 Eval-03 时效"未届满（假设）"等事实未写入 query。
8. **模板合规无人检验**：§0 模板约束未被任何 `expected_behavior` 检查。
9. **易腐**：ref 写死 reference 结构；`skills` 字段曾错为 `contract-claim-basis`（已修为 `claim-basis`）。

**下次改动计划（按优先级）**：
- **高**：①修 Eval-01 的 300万/153万矛盾；②给 4 个现有 eval 各加一条 `expected_behavior`——"输出须遵循 report-template 结构"；③在 `test/README.md` 定义合格线 + 核心项/加分项区分。
- **中（补覆盖，从现成案例转化）**：Eval-05 物权·善意取得（由案例5.5）；Eval-06 侵权·特殊侵权+公平责任边界（由案例5.4/5.6）；Eval-07 担保·指导案例168号（由案例5.8）；视情补占有保护 vs 所有权返还、损害赔偿抽象/具体计算各一题。目标：精选补到 8-10 个，每大类至少 1 题（不盲目堆量，质量优先）。
- **低（治本）**：加 1-2 道触发/反向题（防误触发、请求权不成立）；探索轻量自动化或固定由 `darwin-skill`/独立 agent 盲评，摆脱自评偏向。

> **附：本轮自测结果（热环境，仅供参考）**——Eval-03/04/01/02 在已装载 skill + 讨论上下文中手动跑，`expected_behavior` 全项通过、ref 缺陷清单 0 踩坑、模板合规。但属"开卷+自评"，偏乐观，不代表干净新会话下的真实表现；真回归须另开会话单跑 + 独立盲评。
