#!/usr/bin/env bash
# 작업 폴더에 작업 규칙, 스킬, 문서 템플릿을 복사하고 git을 초기화한다.
# 사용법 (과제 작업 폴더에서):
#   git clone <이 저장소 URL> /tmp/starter && bash /tmp/starter/bootstrap.sh
# 기존 파일은 덮어쓰지 않는다. Codex 버전은 건드리지 않는다.
set -uo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$(pwd)"
copy() { if [ -e "$DEST/$2" ]; then echo "건너뜀(이미 있음): $2"; else mkdir -p "$(dirname "$DEST/$2")"; cp "$SRC/$1" "$DEST/$2"; echo "복사: $2"; fi; }
copy templates/AGENTS.md AGENTS.md
copy templates/HANDOFF.md HANDOFF.md
copy templates/DECISIONS.md DECISIONS.md
for s in handoff ai-decision-log verify-before-submit; do copy ".agents/skills/$s/SKILL.md" ".agents/skills/$s/SKILL.md"; done
if [ ! -d "$DEST/.git" ]; then git init -q; fi
git config user.name >/dev/null || git config user.name "candidate"
git config user.email >/dev/null || git config user.email "candidate@local"
git add -A && git commit -qm "chore: 작업 규칙·스킬·문서 템플릿 세팅" && echo "커밋 완료"
if [ "${WITH_CONTEXT7:-0}" = "1" ] && command -v codex >/dev/null; then
  codex mcp add context7 -- npx -y @upstash/context7-mcp && echo "context7 MCP 추가 (Codex 재시작 필요)"
fi
echo "다음: codex 실행 → '/status' 확인 → AGENTS.md를 과제에 맞게 다듬기"
