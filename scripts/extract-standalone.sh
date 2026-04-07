#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  specClawd/scripts/extract-standalone.sh --target <new-repo-dir>

Example:
  specClawd/scripts/extract-standalone.sh --target /tmp/specClawd
EOF
}

target_dir=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      shift
      target_dir="${1:-}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if [[ -z "$target_dir" ]]; then
  echo "--target is required" >&2
  usage
  exit 1
fi

source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -e "$target_dir" ]] && [[ -n "$(find "$target_dir" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
  echo "Target directory must be empty or not exist: $target_dir" >&2
  exit 1
fi

mkdir -p "$target_dir"

copy_entry() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    cp -R "$src"/. "$dst"/
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  fi
}

for entry in \
  README.md \
  VERSION \
  CHANGELOG.md \
  LICENSE \
  docs \
  templates \
  rules \
  adapters \
  scripts \
  install \
  profiles \
  examples \
  .github; do
  copy_entry "$source_root/$entry" "$target_dir/$entry"
done

chmod +x \
  "$target_dir/scripts/check.sh" \
  "$target_dir/scripts/release-preflight.sh" \
  "$target_dir/scripts/specClawd-new-change.sh" \
  "$target_dir/scripts/specClawd-verify.sh" \
  "$target_dir/scripts/specClawd-archive.sh" \
  "$target_dir/scripts/specClawd-check-pr.sh" \
  "$target_dir/install/init.sh" \
  "$target_dir/install/bootstrap.sh" \
  "$target_dir/adapters/codex/install.sh"

(
  cd "$target_dir"
  ./scripts/check.sh
)

cat <<EOF
Extracted standalone specClawd repository to:
  $target_dir

Next:
  1. initialize a new git repository there
  2. review README.md and docs/alpha-release.md
  3. run scripts/release-preflight.sh before tagging
EOF
