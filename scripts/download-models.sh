#!/bin/bash
# Download all models needed by my-neuro services.
# Skips the Windows-only GPT-SoVITS TTS bundle.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FULL_HUB="$ROOT/full-hub"

echo "============================================"
echo " my-neuro model download (Linux)"
echo "============================================"

# Ensure modelscope CLI is available
if ! uv run --project "$ROOT" python -c "import modelscope" 2>/dev/null; then
    echo "ERROR: modelscope not installed. Run: uv sync first."
    exit 1
fi

# Helper
ms_download() {
    local model="$1"
    local dest="$2"
    echo ""
    echo ">>> Downloading $model -> $dest"
    uv run --project "$ROOT" modelscope download --model "$model" --local_dir "$dest"
}

# ── 1. BERT emotion model ──────────────────────────────────────────────────────
BERT_DIR="$FULL_HUB/bert-hub"
if [ -f "$BERT_DIR/model.safetensors" ]; then
    echo "[SKIP] bert-hub: already downloaded"
else
    ms_download "morelle/Omni_fn_bert" "$BERT_DIR"
fi

# ── 2. RAG embedding model (BAAI/bge-m3) ──────────────────────────────────────
RAG_DIR="$FULL_HUB/rag-hub"
if [ -f "$RAG_DIR/model.safetensors" ] || [ -f "$RAG_DIR/pytorch_model.bin" ]; then
    echo "[SKIP] rag-hub: already downloaded"
else
    ms_download "BAAI/bge-m3" "$RAG_DIR"
fi

# ── 3. ASR: VAD model ─────────────────────────────────────────────────────────
VAD_DIR="$FULL_HUB/asr-hub/model/torch_hub"
VAD_MODEL="$VAD_DIR/snakers4_silero-vad_master"
if [ -d "$VAD_MODEL" ]; then
    echo "[SKIP] VAD model: already downloaded"
else
    mkdir -p "$VAD_DIR"
    ms_download "morelle/my-neuro-vad" "$VAD_DIR"
fi

# ── 4. ASR: SeACo-Paraformer model (hotword support, used by asr_api.py) ──────
SEACO_DIR="$FULL_HUB/asr-hub/model/asr/models/iic/speech_seaco_paraformer_large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"
if [ -f "$SEACO_DIR/model.pt" ]; then
    echo "[SKIP] ASR seaco-paraformer model: already downloaded"
else
    mkdir -p "$SEACO_DIR"
    ms_download "iic/speech_seaco_paraformer_large_asr_nat-zh-cn-16k-common-vocab8404-pytorch" "$SEACO_DIR"
fi

# ── 5. ASR: Punctuation model ─────────────────────────────────────────────────
PUNC_DIR="$FULL_HUB/asr-hub/model/asr/models/iic/punc_ct-transformer_cn-en-common-vocab471067-large"
if [ -f "$PUNC_DIR/model.pt" ]; then
    echo "[SKIP] Punctuation model: already downloaded"
else
    mkdir -p "$PUNC_DIR"
    ms_download "iic/punc_ct-transformer_cn-en-common-vocab471067-large" "$PUNC_DIR"
fi

# ── 6. TTS: SKIPPED (GPT-SoVITS bundle is Windows-only) ──────────────────────
echo ""
echo "[SKIP] TTS (GPT-SoVITS): Windows-only bundle — not supported on Linux."
echo "       To enable TTS, set cloud.tts.enabled=true in live-2d/config.json"
echo "       and add your SiliconFlow API key."

echo ""
echo "============================================"
echo " All done!"
echo "============================================"
