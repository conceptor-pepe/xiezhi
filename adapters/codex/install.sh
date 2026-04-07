#!/usr/bin/env bash

set -euo pipefail

target_root="${CODEX_HOME:-$HOME/.codex}"
target_dir="$target_root/prompts"

mkdir -p "$target_dir"
cp specClawd/adapters/codex/prompts/*.md "$target_dir/"

echo "Installed Codex prompts to: $target_dir"
