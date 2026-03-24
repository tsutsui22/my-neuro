#!/bin/bash
# MemOS WebUI — port 8501
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/memos_system"
exec uv run --project "$ROOT" streamlit run webui/memos_webui_v3.py --server.port 8501
