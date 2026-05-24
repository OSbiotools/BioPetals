#!/usr/bin/env bash
set -euo pipefail

# Simple helper to start a private Petals swarm that serves only the biology model.
# Usage: ./run_bio_server.sh [--num-blocks N] [--port 31337] [additional run_server args]

MODEL="aaditya/Llama3-OpenBioLLM-8B"
NUM_BLOCKS=""
PORT="31337"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --num-blocks)
      NUM_BLOCKS="$2"
      shift 2
      ;;
    --port)
      PORT="$2"
      shift 2
      ;;
    --model)
      MODEL="$2"
      shift 2
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

CMD=(python -m petals.cli.run_server "$MODEL" --new_swarm --public_ip 127.0.0.1 --port "$PORT")
if [[ -n "$NUM_BLOCKS" ]]; then
  CMD+=(--num_blocks "$NUM_BLOCKS")
fi
if [[ ${#EXTRA_ARGS[@]:-0} -gt 0 ]]; then
  CMD+=("${EXTRA_ARGS[@]}")
fi

echo "Starting private BioPetals server for model: $MODEL"
echo "Command: ${CMD[*]}"
exec "${CMD[@]}"
