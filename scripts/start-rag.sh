#!/bin/bash
# RAG Knowledge Retrieval — port 8002
# Requires: BAAI/bge-m3 model in full-hub/rag-hub/
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/full-hub"
exec uv run --project "$ROOT" python run_rag.py
