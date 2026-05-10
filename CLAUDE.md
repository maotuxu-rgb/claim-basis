# contract-claim-basis

Claude Code custom skill for structured claim-basis analysis under the Contract Book of the Chinese Civil Code (Articles 463–988).

## Structure

- `SKILL.md` — Skill definition: analysis framework, claim-basis catalog, concurrence rules
- `references/` — Norm-type guide, report template, case examples, and contract-specific provisions
- `source/annotated-code.md` — Full Civil Code text with 2,772 norm-type annotations (25,915 lines)
- `test/` — 4 evaluation scenarios with reference analysis paths

## Usage

This skill activates automatically in Claude Code when a user asks about contract dispute analysis under the Civil Code.

## Development

Run evaluations with the scenarios in `test/`. See `test/README.md` for the evaluation methodology.
