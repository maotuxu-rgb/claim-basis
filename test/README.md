# 评估体系说明

本目录包含 `claim-basis` 技能的评估场景，用于检验 SKILL.md 修改前后技能效果是否达标。

## 目录结构

```
test/
  README.md                                    ← 本文件
  eval-01-rescission-compensation.json         ← 评估场景一（合同被撤销后折价补偿）
  eval-01-rescission-compensation-ref.md       ← 评估一参考分析路径
  eval-02-breach-termination.json              ← 评估场景二（违约方申请司法解除）
  eval-02-breach-termination-ref.md            ← 评估二参考分析路径
  eval-03-basic-lease-return.json              ← 评估场景三（基础：租期届满返还）
  eval-03-basic-lease-return-ref.md            ← 评估三参考分析路径
  eval-04-quality-defect-reference.json        ← 评估场景四（品质瑕疵与提示参引操作）
  eval-04-quality-defect-reference-ref.md      ← 评估四参考分析路径
```

## 如何使用

目前无自动运行机制。每次评估按以下步骤手动执行：

1. 加载 `claim-basis` 技能（新建对话，确保技能已激活）
2. 将 `.json` 文件中 `query` 字段的内容原文输入 Claude
3. 对照同名 `-ref.md` 文件中的分析路径，检查 Claude 输出是否满足 `expected_behavior` 中的各项过程性标准
4. 记录未满足的项目，作为 SKILL.md 迭代改进的依据

## 评估难度分级

| 编号 | 场景 | 难度 | 考察重点 |
|------|------|------|----------|
| Eval-01 | 合同被撤销后折价补偿 | ★★★ | 第157条的独立性、特别规范优先、撤销权审查、类推参引操作（第525—526条类推适用于返还关系）|
| Eval-02 | 违约方申请司法解除 | ★★★ | 第580条第2款要件、解除权审查顺序、跨类规范处理（辅助/抗辩）、不当得利排除 |
| Eval-03 | 租期届满返还（基础）| ★☆☆ | 预选流程、四步结构、请求权竞合基础规则、规范类型标注 |
| Eval-04 | 品质瑕疵与提示参引 | ★★☆ | 提示参引操作（第617条→第582—584条）、跨类规范（第582条主要/抗辩）、句级规范类型差异（第584条）、展开公因式方法 |

> **建议**：每次修改 SKILL.md 后，先跑 Eval-03，确认基础流程无误，再跑 Eval-04（参引与跨类），最后跑 Eval-01 和 Eval-02。
