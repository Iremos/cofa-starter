#!/usr/bin/env bash
# 작업 폴더에 작업 규칙, 스킬, 문서 템플릿을 복사하고 git을 초기화한다.
# 사용법 (과제 작업 폴더에서):
#   git clone <이 저장소 URL> /tmp/starter && bash /tmp/starter/bootstrap.sh
# 선택 옵션 (환경 변수, 여러 개 함께 써도 됨):
#   WITH_CONTEXT7=1            라이브러리 문서 조회 MCP (Context7)
#   WITH_NEXT_MCP=1            Next.js DevTools MCP (Next.js 16+, 개발 서버 실행 중일 때 유용, 통계 전송 끔)
#   WITH_BROWSER_MCP=playwright | chrome   브라우저 자동화 MCP (환경에 브라우저가 있어야 동작)
#   예) WITH_CONTEXT7=1 WITH_NEXT_MCP=1 bash /tmp/starter/bootstrap.sh
# 기존 파일은 덮어쓰지 않는다. Codex 버전은 건드리지 않는다.
set -uo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$(pwd)"
copy() { if [ -e "$DEST/$2" ]; then echo "건너뜀(이미 있음): $2"; else mkdir -p "$(dirname "$DEST/$2")"; cp "$SRC/$1" "$DEST/$2"; echo "복사: $2"; fi; }
copy templates/AGENTS.md AGENTS.md
copy templates/HANDOFF.md HANDOFF.md
copy templates/DECISIONS.md DECISIONS.md
copy templates/VERIFY.md VERIFY.md
copy templates/docs/DESIGN.md docs/DESIGN.md
copy templates/docs/ARCHITECTURE.md docs/ARCHITECTURE.md
for s in handoff ai-decision-log verify-manual verify-before-submit; do copy ".agents/skills/$s/SKILL.md" ".agents/skills/$s/SKILL.md"; done
if [ ! -d "$DEST/.git" ]; then git init -q; fi
git config user.name >/dev/null || git config user.name "candidate"
git config user.email >/dev/null || git config user.email "candidate@local"
git add -A && git commit -qm "chore: 작업 규칙·스킬·문서 템플릿 세팅" && echo "커밋 완료"

# ---- 선택: MCP 서버 추가 ----
ADDED=0
add_mcp() {   # add_mcp <이름> <codex mcp add 뒤에 붙일 인자...>
  local name="$1"; shift
  if ! command -v codex >/dev/null; then echo "codex 명령을 찾을 수 없어 MCP 추가를 건너뜀: $name"; return; fi
  if codex mcp add "$name" "$@"; then echo "MCP 추가: $name"; ADDED=1; else echo "MCP 추가 실패(건너뜀): $name"; fi
}
if [ "${WITH_CONTEXT7:-0}" = "1" ]; then
  add_mcp context7 -- npx -y @upstash/context7-mcp
fi
if [ "${WITH_NEXT_MCP:-0}" = "1" ]; then
  add_mcp next-devtools --env NEXT_TELEMETRY_DISABLED=1 -- npx -y next-devtools-mcp@latest
fi
case "${WITH_BROWSER_MCP:-}" in
  playwright) add_mcp playwright -- npx -y @playwright/mcp@latest ;;
  chrome)     add_mcp chrome-devtools -- npx -y chrome-devtools-mcp@latest --headless --no-usage-statistics --no-performance-crux ;;
  "") ;;
  *) echo "WITH_BROWSER_MCP 값은 playwright 또는 chrome" ;;
esac

echo ""
echo "통계 전송 끄기 (이 터미널과 새 터미널마다):  export NEXT_TELEMETRY_DISABLED=1"
echo "Next.js 설치 후 영구적으로 끄기:            npx next telemetry disable"
[ "$ADDED" = "1" ] && echo "MCP를 추가했으면 Codex를 (재)시작한 뒤 /mcp 로 확인"
echo "다음: codex 실행 → '/status' 확인 → AGENTS.md를 과제에 맞게 다듬기"
