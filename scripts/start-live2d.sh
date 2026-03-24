#!/bin/bash
# Live2D Electron App
# Requires: npm install (run once: cd live-2d && npm install)
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/live-2d"

if [ ! -d "node_modules" ]; then
    echo "node_modules not found. Running npm install..."
    npm install
fi

exec npm start
