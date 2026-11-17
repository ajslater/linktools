#!/usr/bin/env bash
# Run linktools in development
set -euo pipefail
export PYTHONDEVMODE=1
uv run ./linktools.py "$@"
