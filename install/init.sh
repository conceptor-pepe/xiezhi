#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  speclawd/install/init.sh --target <repo-dir> [--profile backend-brownfield] [--tool all]

Example:
  speclawd/install/init.sh --target /path/to/repo
  speclawd/install/init.sh --target /path/to/repo --profile minimal
  speclawd/install/init.sh --target /path/to/repo --profile go-service --tool cursor
  speclawd/install/init.sh --target /path/to/repo --profile backend-brownfield --tool cursor,claude
EOF
}

target_dir=""
profile="backend-brownfield"
tool_mode="all"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      shift
      target_dir="${1:-}"
      ;;
    --profile)
      shift
      profile="${1:-}"
      ;;
    --tool)
      shift
      tool_mode="${1:-}"
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

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$root_dir/profiles/$profile/manifest.tsv"

if [[ ! -f "$manifest" ]]; then
  echo "Profile manifest not found: $manifest" >&2
  echo "Available profiles:" >&2
  find "$root_dir/profiles" -mindepth 1 -maxdepth 1 -type d -printf '  - %f\n' >&2
  exit 1
fi

mkdir -p "$target_dir"

should_install_path() {
  local rel_dst="$1"
  local selected_tools=",${tool_mode},"

  case "$tool_mode" in
    all)
      return 0
      ;;
    none)
      case "$rel_dst" in
        .cursor/commands/*|.github/prompts/*|.claude/prompts/*|.krio/prompts/*)
          return 1
          ;;
      esac
      return 0
      ;;
    *)
      case ",$tool_mode," in
        *,all,*|*,none,*)
          echo "Unsupported mixed --tool value: $tool_mode" >&2
          exit 1
          ;;
      esac

      case "$rel_dst" in
        .cursor/commands/*)
          [[ "$selected_tools" == *",cursor,"* ]] && return 0 || return 1
          ;;
        .github/prompts/*)
          [[ "$selected_tools" == *",copilot,"* ]] && return 0 || return 1
          ;;
        .claude/prompts/*)
          [[ "$selected_tools" == *",claude,"* ]] && return 0 || return 1
          ;;
        .krio/prompts/*)
          [[ "$selected_tools" == *",krio,"* ]] && return 0 || return 1
          ;;
      esac
      return 0
      ;;
  esac
}

while IFS=$'\t' read -r src rel_dst; do
  [[ -z "$src" ]] && continue
  if ! should_install_path "$rel_dst"; then
    continue
  fi
  src_path="$root_dir/$src"
  dst_path="$target_dir/$rel_dst"

  if [[ ! -f "$src_path" ]]; then
    echo "Missing source file: $src_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$dst_path")"
  cp "$src_path" "$dst_path"
  case "$dst_path" in
    *.sh)
      chmod +x "$dst_path"
      ;;
  esac
done < "$manifest"

mkdir -p "$target_dir/docs/changes/archive"

cat <<EOF
Initialized Speclawd profile:
  profile: $profile
  tools: $tool_mode
  target: $target_dir

Installed:
  - docs/templates/*
  - docs/specs/README.md
  - docs/changes/README.md
  - .cursor/rules/speclawd-spec.mdc
  - .cursor/commands/speclawd-*.md
  - .github/prompts/speclawd-*.prompt.md
  - .claude/prompts/speclawd-*.md
  - .krio/prompts/speclawd-*.md
  - scripts/speclawd-*.sh
  - scripts/specld-*.sh

Next:
  1. review installed files
  2. install global adapters if needed
  3. create your first change
EOF
