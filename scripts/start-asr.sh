#!/bin/bash
# ASR Speech Recognition — port 10000
# Requires: models in full-hub/asr-hub/ (run scripts/download-models.sh first)
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/full-hub"
exec uv run --project "$ROOT" python asr_api.py
