# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

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
- `source/annotated-code.md` — Full Civil Code text with ~3,681 norm-type annotations (25,925 lines)
- `test/` — 10 evaluation scenarios with reference analysis paths (合同 4 + 物权 2 + 侵权 2〔含反向题〕 + 担保 1 + 损害赔偿计算 1)

## Usage

This skill activates automatically in Claude Code when a user asks about civil dispute analysis under the Civil Code (contract performance/breach/termination, restitution, real-rights recovery, good-faith acquisition, tort liability, unjust enrichment, etc.). Follow the quick-start checklist in `SKILL.md`, loading references on demand via the routing table — do not load every reference at once.

## Development

This is a **pure Markdown skill repo** — there is no build step, no dependencies, no linter, and no automated test runner. "Development" means editing `SKILL.md` and the `references/`, then validating the change against the evals in `test/`.

### Running an eval (manual, no harness)

Evals are run by hand in a **fresh conversation** with the skill loaded — there is no script:

1. Start a new session and let the `claim-basis` skill activate.
2. Paste the `query` field from a `test/eval-NN-*.json` file verbatim.
3. Compare the output against the same-numbered `test/eval-NN-*-ref.md`, checking every item in the JSON's `expected_behavior`.

After editing `SKILL.md`, run **Eval-03 first** (basic flow), then **Eval-04** (参引/跨类), then **Eval-01 / Eval-02** (hardest). See `test/README.md` for the difficulty matrix. Note: self-running evals in a hot, skill-loaded session is "open-book" and over-optimistic — true regression checks need a clean session and ideally a blind judge (`darwin-skill` or an independent agent).

## Editing invariants (do not violate)

These are hard constraints, distilled from past mistakes — they override convenience:

- **Never invent statute or judicial-interpretation text from memory.** The repo had a real incident hallucinating 担保制度司法解释 article numbers. Any article number, wording, or 司法解释 citation must be grounded in `source/annotated-code.md` or an authoritative source actually present in the repo. If the source isn't in the repo, say so and mark it "需另行查证" rather than guessing.
- **`source/annotated-code.md` is the ground truth.** When touching it, change *formatting only* — never alter the substance of statutory text or the `〈规范类型〉` annotations. Commit in small, `git diff`-verifiable steps.
- **`SKILL.md` is a lean navigation layer, not a content dump.** New claim-basis detail belongs in a `references/ref-*.md` file reachable via the §三 routing table, not inline in `SKILL.md`.
- **Report output is template-bound.** Full analyses must follow `references/report-template.md` (read it before writing); see SKILL.md §0.

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
2. ~~**Eval-01 数据自相矛盾**：`query` 写"总价 300 万元"单份合同，`ref.md` 却按"153万+147万 两份合同"展开 → 需对齐修复。~~ **（2026-06-19 已修复：统一为单份合同 300 万元，改 `ref.md` 要件3及合同名、改 `.json` expected_behavior 第4条；另发现并修复 Eval-01 `query` 因 ASCII 直引号导致 JSON 无法解析的问题，改全角引号，四个 `.json` 现均可程序解析。）**
3. **"剧本式"评分**：`expected_behavior` 固化单一路径，可能奖励复述、惩罚"结论正确但路径不同"，测的是方法符合度而非法律正确性。
4. **无合格线/权重**：README 未定义几项算过、未区分核心项与加分项。
5. **自评不可靠 + 无自动化**：易出现"出题人即阅卷人"偏向。
6. **缺反向/陷阱题**：无"请求权不成立""防误触发（刑事/行政）""干扰事实稳健性"类测试。
7. **依赖题外假设**：如 Eval-03 时效"未届满（假设）"等事实未写入 query。
8. **模板合规无人检验**：§0 模板约束未被任何 `expected_behavior` 检查。
9. **易腐**：ref 写死 reference 结构；`skills` 字段曾错为 `contract-claim-basis`（已修为 `claim-basis`）。

**下次改动计划（按优先级）**：
- ~~**高**：①修 Eval-01 的 300万/153万矛盾；②给 4 个现有 eval 各加一条 `expected_behavior`——"输出须遵循 report-template 结构"；③在 `test/README.md` 定义合格线 + 核心项/加分项区分。~~ **（2026-06-19 三项全部完成：①见上文不足#2；②四个 `.json` 末条均已加模板合规检查；③`test/README.md` 已定义核心项C/加分项B/模板合规T 三类判定标准与"不合格/合格/良好"三级合格线，并强调"测法律正确性而非逐字复述"以纠"剧本式评分"。下一步进入"中"优先级补覆盖。）**
- ~~**中（补覆盖，从现成案例转化）**：Eval-05 物权·善意取得（由案例5.5）；Eval-06 侵权·特殊侵权+公平责任边界（由案例5.4/5.6）；Eval-07 担保·指导案例168号（由案例5.8）~~ **（2026-06-19 已落地三题，eval 总数 4→7，物权/侵权/担保三大编零覆盖缺口已补齐：Eval-05 物权·不动产善意取得[5.5]；Eval-06 侵权·公平责任边界[取 5.6 电梯劝烟案，做成反向题，考第1186非独立请求权基础]；Eval-07 担保·指导案例168号[5.8，刻意仅走民法典条文路径、不碰担保解释条号，呼应 §1 戒律]。）** **（2026-06-19 续：上述"仍待补"三题已全部落地，eval 总数 7→10，达成 8-10 目标且每大类≥1题：Eval-08 侵权·动物园动物致害[5.4 喂猴案，特殊侵权过错推定+监护过失与有过失+精神损害+违约竞合]；Eval-09 物权·占有保护 vs 所有物返还[第462 vs 第235，并存非竞合]；Eval-10 损害赔偿·替代交易具体计算优先于抽象计算[合同编通则解释第60条，出处据 ref-damages-calculation.md 非凭记忆]。）** 目标：精选补到 8-10 个，每大类至少 1 题（不盲目堆量，质量优先）——**已达成**。后续如再扩充宜转向"低"优先级的触发/反向题与盲评自动化。
- **低（治本）**：加 1-2 道触发/反向题（防误触发、请求权不成立）；探索轻量自动化或固定由 `darwin-skill`/独立 agent 盲评，摆脱自评偏向。

> **附：本轮自测结果（热环境，仅供参考）**——Eval-03/04/01/02 在已装载 skill + 讨论上下文中手动跑，`expected_behavior` 全项通过、ref 缺陷清单 0 踩坑、模板合规。但属"开卷+自评"，偏乐观，不代表干净新会话下的真实表现；真回归须另开会话单跑 + 独立盲评。

### 4. source 数据清洗与规范化（待办）

**现状**：`source/annotated-code.md`（约 2.6 万行）格式偏乱，影响上层所有 reference 与检索准确性。属底层数据质量问题，优先级不低。

**计划要点**：
- **统一格式**：条文编号、`〈规范类型〉` 标注、`「关联条文」`、`a/b` 子项等的排版规则统一。
- **修正残留**：OCR/转换产生的全角半角混用、多余空格、异常断行、乱码。
- **可选结构化**：为每条增加可解析标记（如稳定的条文 ID、字段分隔），便于将来程序化检索，并呼应 §7 的 JSON 架构。
- **保真铁律**：只动格式，**不得改动法条原文与规范类型标注的实质内容**；用 git diff 分步可核验，小步提交。

### 5. 重要司法解释 reference 体系（待办，§1 的扩展）

**范围**：不止担保解释（§1 已列），还应纳入其他高频司法解释。

**优先级**：担保制度解释（法释〔2020〕28号）> 合同编通则解释 > 总则编解释 > 各分则解释（买卖、租赁等）。

**方法（沿用现有标注法，避免两个坑）**：
- **不贴全文**：仅抽取"可作请求权基础/抗辩"的条款，做 `〈规范类型〉` 标注，其余略，防止撑爆 context、稀释信噪比。
- **版本管理**：标注法释文号 + 现行有效性（司法解释常修订）；**严禁凭记忆杜撰条文**（参 §1 实战教训）。

### 6. 民法典各编典型案例精选（待办）

**目标**：使高频/易错/有争议的细分领域都有典型案例可参照，沉淀进 `ref-case-examples.md`，并可一案两吃转化为 `test/` 的 eval。

**原则**：
- **案例位阶分级**：指导性案例 > 最高法公报案例 > 各级法院典型案例，优先前两类。
- **克制覆盖**：不追求每个细分领域都配案例（维护爆炸），优先"高频 + 易错 + 有争议"领域（善意取得、占有保护顺位、违约方解除、公平责任边界、担保未登记等），长尾留白。

### 7. 两阶段分析架构与 JSON 中间表示（IR）（设想，待验证）

**设想**：input → 模型枚举所有候选请求权基础并逐一四步检视 → 输出结构化 JSON（"请求权检索表 / Anspruchsmatrix"）→ 该 JSON 作为输入 → 渲染为符合 `report-template.md` 的分析报告。

**可行性结论**：可行，是"分解→结构化中间表示→合成"的成熟模式，与鉴定式方法天然契合。

**四个必须避开的误区/要点**：
1. **两次调用 ≠ 二次验证**：同一上下文把 JSON 喂回同一模型不会真正复核（garbage in, garbage out）。真正的验证需**独立上下文/agent 盲查 JSON**，或令第二阶段为**受约束的纯渲染**（只照 JSON 写、不新增结论）。价值在于"中间产物可被审查/复核"与"强制穷尽枚举"，不在"多调一次"。
2. **JSON 须装"结构化 findings"而非"是非薄表"**：验证请求权成立本身就是四步攻防，无法在轻量表里"顺便完成"。
3. **Schema 草案**（每个候选请求权一行/一对象）：
   ```
   案件{当事人, 请求人所求法律效果[]}
   请求权候选[]{ id, 请求权人, 相对人, 规范基础, 规范类型, 法律效果,
     产生要件[]{要件, 涵摄, 结论}, 权利发生抗辩[], 权利消灭抗辩[],
     权利行使抗辩[], 成立结论, 争点[], 置信度 }
   竞合[]{涉及[], 类型, 处理}
   ```
   收益：①报告渲染只读它；②可作 eval 的 ground-truth/自动比对（解决 §3 无自动化痛点）；③`争点`/`置信度` 字段强制暴露不确定性。
4. **落地分两版**：先做**指令版**（SKILL.md 内编排"先出 JSON 草表 → 可选用户审 → 再渲染报告"，零代码）验证是否真比单趟好；产品化时再用 **Claude Agent SDK** 做真两阶段流水线 + 独立复核 agent。**先验证、勿过度工程**。

---

> **Roadmap 推进优先级建议**：1（担保 reference，需先补法源）与 3 高优先项（修 Eval-01、加模板检查、定合格线）可即刻做；4（source 清洗）为底层基础，宜尽早；5/6 持续补充；7 先做指令版小规模验证再决定是否工程化。
