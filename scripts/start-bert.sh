#!/bin/bash
# BERT Emotion Classifier — port 6007
# Requires: morelle/Omni_fn_bert model in full-hub/bert-hub/
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/full-hub"
exec uv run --project "$ROOT" python omni_bert_api.py
