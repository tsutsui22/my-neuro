#!/bin/bash
# MemOS Memory API — port 8003
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Load .env into environment
if [ -f "$ROOT/.env" ]; then
    set -a
    # shellcheck disable=SC1091
    source "$ROOT/.env"
    set +a
else
    echo "WARNING: .env not found. Copy .env.example to .env and fill in your API keys."
fi

# Inject .env values into memos_config.json (it holds ${VAR} placeholders)
envsubst < "$ROOT/memos_system/config/memos_config.json" \
    > "$ROOT/memos_system/config/memos_config.json.tmp" \
    && mv "$ROOT/memos_system/config/memos_config.json.tmp" \
        "$ROOT/memos_system/config/memos_config.json"

cd "$ROOT/memos_system"
exec uv run --project "$ROOT" python api/memos_api_server_v2.py
