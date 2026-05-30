# contract-claim-basis

Claude Code custom skill for structured claim-basis (Anspruchsgrundlage) analysis under the Chinese Civil Code. Originally scoped to the Contract Book (Articles 463–988), now also covers the **Property Book** (返还原物、占有保护、善意取得、占有回复) and the **Tort Liability Book** (过错/无过错侵权、数人侵权、第三人侵害债权、损害赔偿计算), plus quasi-contract (无因管理、不当得利) and related General-Part rules (第157条等).

## Structure

- `SKILL.md` — Lean navigation layer: analysis framework, claim-basis index, **reference routing table**, concurrence rules
- `references/`
  - `ref-norm-types.md` — 18-category norm-type guide
  - `ref-contract-claims.md` — Contract Book + quasi-contract catalog (general provisions, sale/lease/loan/suretyship)
  - `ref-property-rights.md` — Property Book catalog (real-rights protection, good-faith acquisition, possession)
  - `ref-tort-liability.md` — Tort Book catalog (general/special torts, joint tort liability, damages)
  - `ref-*.md` — Contract-type-specific provisions (contracting, transport, technology, agency, storage, others)
  - `ref-case-examples.md` — Worked scenario analyses
  - `report-template.md` — Structured report template
- `source/annotated-code.md` — Full Civil Code text with 2,772 norm-type annotations (25,915 lines)
- `test/` — 4 evaluation scenarios with reference analysis paths

## Usage

This skill activates automatically in Claude Code when a user asks about civil dispute analysis under the Civil Code (contract performance/breach/termination, restitution, real-rights recovery, good-faith acquisition, tort liability, unjust enrichment, etc.). Follow the quick-start checklist in `SKILL.md`, loading references on demand via the routing table — do not load every reference at once.

## Development

Run evaluations with the scenarios in `test/`. See `test/README.md` for the evaluation methodology.
