# contract-claim-basis

Claude Code 自定义技能：基于请求权基础方法，对《民法典》合同编（第463—988条）纠纷进行结构化分析。

## 功能

给定合同纠纷事实，本技能将：

1. 从请求权人所求的**法律效果**出发，预选候选请求权基础
2. 按标准检视顺序（合同→缔约过失→无因管理→物法→不当得利/侵权）排列
3. 对每个候选请求权执行**四步审查**（产生要件→权利发生抗辩→权利消灭抗辩→权利行使抗辩权）
4. 处理请求权竞合（特别法优先、合同吸收等）
5. 输出结构化分析报告

覆盖的请求权类型包括：合同履行、违约赔偿、合同解除与恢复原状、合同无效/撤销后返还与折价补偿、缔约过失、不当得利，以及违约方申请司法解除（第580条第2款）等争议场景。

## 安装

将本仓库克隆到 Claude Code 的 skills 目录：

```bash
git clone https://github.com/maotuxu-rgb/contract-claim-basis.git ~/.claude/skills/contract-claim-basis
```

安装完成后，当你向 Claude Code 提出合同纠纷分析问题时，技能将自动触发。

## 使用示例

向 Claude Code 输入类似以下问题：

- "甲将房屋出租给乙，租期两年已届满，乙拒绝返还。甲可主张哪些请求权？"
- "出卖人以欺诈手段出售套牌车，买受人可主张何种权利？请在合同被撤销情形下分析。"
- "违约方能否申请解除合同？请分析第580条第2款的适用要件。"

## 项目结构

```
contract-claim-basis/
  SKILL.md              -- 技能定义（分析框架 + 请求权基础目录 + 竞合规则）
  CLAUDE.md             -- 项目说明
  references/
    ref-norm-types.md           -- 18类规范类型操作指南
    report-template.md          -- 分析报告模板
    ref-case-examples.md        -- 典型案例场景分析范本
    ref-contracting-construction.md  -- 承揽 + 建设工程合同条文
    ref-transport.md            -- 运输合同条文
    ref-technology.md           -- 技术合同条文
    ref-agency-brokerage.md     -- 委托 + 行纪 + 中介合同条文
    ref-storage-warehouse.md    -- 保管 + 仓储合同条文
    ref-others.md               -- 融资租赁/保理/物业/合伙/供用电/赠与条文
  source/
    annotated-code.md   -- 民法典全编规范类型标注（25,915行，2,772个标注）
  test/
    eval-01 ~ eval-04   -- 评估场景（JSON + 参考分析路径）
```

## 方法论来源

本技能的分析框架基于请求权基础（Anspruchsgrundlage）方法论，主要参考：

- 吴香香：《民法典请求权基础——方法、体系与实例》（北京大学出版社）
- 吴香香：《请求权基础视角下〈民法典〉的规范类型》
- 吴香香：《请求权基础思维及其对手》

`source/annotated-code.md` 中的规范类型标注体系源自上述著作。

## 规范类型体系

本技能采用18类规范分类（详见 `references/ref-norm-types.md`）：

| 类别 | 包含类型 |
|------|----------|
| 原告攻击工具 | 主要规范、不完全主要规范 |
| 辅助规范 | 辅助、提示参引、类推参引、外部、宣导、原则、裁判指引 |
| 被告防御工具 | 抗辩、反抗辩、再抗辩、否认、抗辩排除、否认排除 |
| 跨类规范 | 主要/辅助、主要/抗辩、辅助/抗辩 |

## 评估

`test/` 目录包含 4 个评估场景，覆盖不同难度和考察重点：

| 编号 | 场景 | 难度 |
|------|------|------|
| Eval-01 | 合同被撤销后折价补偿 | ★★★ |
| Eval-02 | 违约方申请司法解除 | ★★★ |
| Eval-03 | 租期届满返还（基础） | ★☆☆ |
| Eval-04 | 品质瑕疵与提示参引 | ★★☆ |

评估方法见 `test/README.md`。

## 许可证

本项目采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可证。

`source/annotated-code.md` 中的规范类型标注体系源自吴香香教授的著作，仅供学术研究和学习使用。
