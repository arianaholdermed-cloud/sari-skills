#!/usr/bin/env bash
# Instala el agente principal "prompting-assistant" de Claude Code.
#   1. Copia agents/prompting-assistant.md a ~/.claude/agents/
#   2. Agrega el alias  pa="claude --agent prompting-assistant"  a tu shell
#   3. (por defecto) Pone "agent": "prompting-assistant" en ~/.claude/settings.json
#      -> usa  --no-default  para saltar este paso.
# Es idempotente: puedes correrlo varias veces sin duplicar nada.
set -euo pipefail

SET_DEFAULT=1
[ "${1:-}" = "--no-default" ] && SET_DEFAULT=0

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/agents/prompting-assistant.md"
CLAUDE_DIR="$HOME/.claude"

[ -f "$SRC" ] || { echo "No encuentro $SRC"; exit 1; }

# 1. Archivo del agente
mkdir -p "$CLAUDE_DIR/agents"
cp "$SRC" "$CLAUDE_DIR/agents/prompting-assistant.md"
echo "✓ Agente copiado a $CLAUDE_DIR/agents/prompting-assistant.md"

# 2. Alias en el rc de tu shell (zsh en macOS por defecto)
ALIAS_LINE='alias pa="claude --agent prompting-assistant"'
case "$(basename "${SHELL:-zsh}")" in
  bash) RC="$HOME/.bashrc" ;;
  *)    RC="$HOME/.zshrc" ;;
esac
touch "$RC"
if grep -qF "$ALIAS_LINE" "$RC"; then
  echo "✓ Alias 'pa' ya estaba en $RC"
else
  printf '\n# Prompting Assistant (Claude Code)\n%s\n' "$ALIAS_LINE" >> "$RC"
  echo "✓ Alias 'pa' agregado a $RC"
fi

# 3. Agente por defecto en settings.json (fusiona sin borrar lo demás)
if [ "$SET_DEFAULT" = 1 ]; then
  SETTINGS="$CLAUDE_DIR/settings.json"
  [ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak-$(date +%Y%m%d%H%M%S)"
  python3 - "$SETTINGS" <<'PY'
import json, os, sys
p = sys.argv[1]
data = {}
if os.path.exists(p) and os.path.getsize(p) > 0:
    with open(p) as f:
        data = json.load(f)
data["agent"] = "prompting-assistant"
with open(p, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
  echo "✓ \"agent\": \"prompting-assistant\" en $SETTINGS (respaldo .bak creado si existía)"
fi

echo
echo "Listo. Abre una terminal nueva (o: source $RC) y escribe: claude   (o pa)"
