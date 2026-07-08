# 干净基线盲评记录（2026-07-07）

对应根目录 CLAUDE.md Roadmap §3"低"优先项前半：在**干净会话**逐题跑全部 10 个 eval，由**独立 agent 盲评**，建立可信基线。此前的"全过"结果系热环境开卷自评，不作数。

## 被测版本

- 运行时内容（SKILL.md + references/ + source/）：与分支 `claude/sad-germain-a0838c` 最新提交（bbe97e8 后、含未提交 CLAUDE.md 文档修订）一致；已用 `diff -rq` 核验安装副本 `~/.claude/skills/claim-basis`（commit 4190e9e）的运行时文件与本仓库**逐字节相同**，差异仅在 CLAUDE.md 与 test/（不参与 skill 运行）。
- Claude Code CLI：2.1.158
- 考生模型：见各 `outputs/eval-NN-meta.txt` 的 `model` 字段（取自事件流，非人工记录）

## 机制

- **考生（干净）**：`claude -p "<query原文>"` 无头模式，工作目录为仓库外的中立空目录（避免考生翻到 `test/` 参考答案）；skill 由用户级 `~/.claude/skills/claim-basis` 自动触发。每题一个全新会话，query 之外不给任何提示。**执行方式**：由用户在本机终端运行 `run-baseline.sh`（试验证明从 Claude Code 会话内嵌套启动 CLI 会因桌面端注入的认证环境变量而 401/403，须在用户自己的登录态下跑）。
- **过程留痕**：`outputs/eval-NN.stream.jsonl` 保存完整事件流；`eval-NN-meta.txt` 记录模型、skill 是否触发、读取过哪些文件（用于核查考生是否偷看 `test/` 答案——若 files_read 出现 `test/eval-*` 路径则该题作废重跑）。
- **阅卷（盲评）**：每题一个独立 judge agent，按 `grades/judge-protocol.md` 执行；judge 只见题目、考生输出、参考路径与评分标准，不见本仓库开发讨论。
- **人工抽查**：judge 判为"边缘/存疑"的项，以及任一不合格结论，由用户复核。

## 目录

- `queries/` — 10 道题的 query 原文（从 `.json` 程序化提取，保证逐字）
- `outputs/` — 考生输出（`-output.md` 为报告正文，`.stream.jsonl` 为全过程，`-meta.txt` 为元信息）
- `grades/` — 盲评结果（每题一份）+ `judge-protocol.md` 评分协议
- 最终汇总：`baseline-scorecard.md`（全部阅卷完成后生成）
