# 回归测试：担保 reference + ref-damages 订正（2026-07-08）

对照基线 `test/baseline-20260707/`，检验本轮内容改动是否让 skill 变好/退步。**基线不可动**，本目录独立留痕。

## 被测改动（相对基线）

| 提交 | 改动 | 影响的 eval |
|------|------|------------|
| 9838500 | 《担保制度解释》原文入库 | Eval-07 |
| b22b25c | **新增 `ref-security-rights.md`**（担保编此前无专门 reference）| Eval-07 |
| 11ea8ad | 《合同编通则解释》入库 + **ref-damages 第61/62条订正** | Eval-10 |

## 基线成绩（对照锚点，取自 baseline-scorecard.md）

| 题 | 基线评级 | 基线 C | 基线 B | 备注 |
|----|---------|--------|--------|------|
| Eval-07 担保·抵押未登记 | 良好 | 7/7 | 1/1 | H 未触发（未杜撰担保解释条文）——**当时 skill 尚无担保 reference，靠模型自身能力过关**；本次有 reference 后应≥持平，且引用可被 source 核验 |
| Eval-10 替代交易计算 | 临界 | 6/6 | 0.5/2 | H 有 1 处存疑（引《合同编通则解释》第60条 source 查无实据）——**本次原文已入库，H 存疑应消解**；ref-damages 订正后第61/62条表述应更准 |

## 关注点（本轮改动应带来的变化）

- **Eval-07**：考生应能 Read 到 `ref-security-rights.md`，引用担保解释条文时**可被 source 核验**（H 保持未触发）；对第215条区分原则、解释46条三款、592②过失相抵的处理应更扎实。
- **Eval-10**：`合同编通则解释` 原文已在 `source/interpretations/`，H 的"查无实据"存疑应消解；第62条不应再出现"以获利为赔偿额/故意重大过失门槛"的旧错述。

## 机制（与基线同协议）

- 被测版本：安装副本 `~/.claude/skills/claim-basis` 已 `reset --hard origin/main`（= 0626920），含 ref-security-rights + 两部解释。
- 考生：`run-regression.sh`（= 基线同款批跑脚本），干净会话、中立目录、`--allowedTools "Read"`、泄漏自检；**须在用户本机终端运行**（嵌套 CLI 认证受限）。
- 阅卷：独立 judge agent 按 `grades/judge-protocol.md` 盲评，与基线同一套 C/B/T/H 标准。
- 判读：与基线 grade 逐项对比——评级不降、H 不新增、争点/引用可核验性提升即为通过。

## 运行

```bash
bash test/regression-20260708-security/run-regression.sh   # 跑 07、10 两题
```

跑完回到 Claude Code 会话告知，进入盲评与对照。
