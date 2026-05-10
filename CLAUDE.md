# 合同法请求权基础

Claude Code 自定义技能：基于请求权基础方法，对《民法典》合同编（第463—988条）纠纷进行结构化分析。

## Structure

- `SKILL.md` — Skill definition: analysis framework, claim-basis catalog, concurrence rules
- `references/` — Norm-type guide, report template, case examples, and contract-specific provisions
- `source/annotated-code.md` — Full Civil Code text with 2,772 norm-type annotations (25,915 lines)
- `test/` — 4 evaluation scenarios with reference analysis paths

## Usage

This skill activates automatically in Claude Code when a user asks about contract dispute analysis under the Civil Code.

## Development

Run evaluations with the scenarios in `test/`. See `test/README.md` for the evaluation methodology.
