#!/bin/bash
# MemOS Memory API — port 8003
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/memos_system"
exec uv run --project "$ROOT" python api/memos_api_server_v2.py
