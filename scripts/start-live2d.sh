#!/bin/bash
# Live2D Electron App
# Requires: npm install (run once: cd live-2d && npm install)
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

# Inject .env values into config.json (config.json itself holds ${VAR} placeholders)
envsubst < "$ROOT/live-2d/config.json" > "$ROOT/live-2d/config.json.tmp" \
    && mv "$ROOT/live-2d/config.json.tmp" "$ROOT/live-2d/config.json"

cd "$ROOT/live-2d"

if [ ! -d "node_modules" ]; then
    echo "node_modules not found. Running npm install..."
    npm install
fi

exec npm start
