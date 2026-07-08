#!/bin/bash
# 干净基线·考生批跑脚本 —— 请在你自己的终端（Terminal.app / iTerm）中运行：
#   bash test/baseline-20260707/run-baseline.sh          # 跑全部未完成的题
#   bash test/baseline-20260707/run-baseline.sh 03 05    # 只跑指定题号
#
# 每题 = 一个全新 `claude -p` 无头会话，工作目录为仓库外的临时空目录，
# 只输入 query 原文，skill 由 ~/.claude/skills/claim-basis 自动触发。
set -uo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
EXAM_ROOM="$(mktemp -d /tmp/claim-basis-exam.XXXXXX)"
ALL=$(ls "$BASE/queries" | sed 's/eval-\(..\)-query.txt/\1/')
TODO="${*:-$ALL}"

echo "考场目录: $EXAM_ROOM"
echo "待跑题号: $TODO"

for NN in $TODO; do
  OUT="$BASE/outputs/eval-${NN}-output.md"
  if [ -s "$OUT" ]; then
    echo "== eval-$NN 已有输出，跳过（重跑请先删除 ${OUT}）"
    continue
  fi
  echo "== eval-$NN 开始 $(date +%H:%M:%S)（完整报告约需数分钟，请耐心）"
  QUERY=$(cat "$BASE/queries/eval-${NN}-query.txt")
  ( cd "$EXAM_ROOM" && claude -p "$QUERY" \
      --output-format stream-json --verbose \
      --allowedTools "Read" \
      > "$BASE/outputs/eval-${NN}.stream.jsonl" \
      2> "$BASE/outputs/eval-${NN}.stderr.log" )
  RC=$?
  python3 - "$NN" "$BASE" <<'PYEOF'
import json, sys
nn, base = sys.argv[1], sys.argv[2]
result_text, model, skill_invoked, files_read = None, None, False, []
try:
    stream = open(f"{base}/outputs/eval-{nn}.stream.jsonl")
except FileNotFoundError:
    sys.exit(f"eval-{nn}: 无事件流文件")
for line in stream:
    line = line.strip()
    if not line: continue
    try: ev = json.loads(line)
    except json.JSONDecodeError: continue
    if ev.get("type") == "assistant":
        m = ev.get("message", {})
        if m.get("model") and not str(m.get("model")).startswith("<"): model = m["model"]
        for blk in m.get("content", []):
            if blk.get("type") == "tool_use":
                if blk.get("name") == "Skill": skill_invoked = blk.get("input", {}).get("skill", True)
                if blk.get("name") == "Read": files_read.append(blk.get("input", {}).get("file_path", "?"))
    if ev.get("type") == "result": result_text = ev.get("result")
leak = [p for p in files_read if "/test/" in p]
with open(f"{base}/outputs/eval-{nn}-output.md", "w") as f:
    f.write(result_text or "(未捕获到 result 事件)")
with open(f"{base}/outputs/eval-{nn}-meta.txt", "w") as f:
    f.write(f"model: {model}\nskill_invoked: {skill_invoked}\n")
    f.write(f"leak_check(读过test/答案则该题作废): {'!!! 泄漏 '+str(leak) if leak else '通过'}\n")
    f.write("files_read:\n" + "".join(f"  - {p}\n" for p in files_read))
status = "OK" if (result_text and len(result_text) > 1000) else "!! 输出异常(过短或缺失,检查 stderr.log)"
print(f"== eval-{nn} 完成: {status} | model={model} | skill触发={skill_invoked} | 泄漏检查={'不通过' if leak else '通过'} | {len(result_text or '')}字")
PYEOF
  [ ${RC} -ne 0 ] && echo "!! eval-$NN 退出码 ${RC}，查看 outputs/eval-${NN}.stderr.log"
done
echo "全部完成。请回到 Claude Code 会话告知，进入盲评阶段。"
