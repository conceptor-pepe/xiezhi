#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./speclawd-workflow-lib.sh
source "$script_dir/speclawd-workflow-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  scripts/speclawd-start.sh <change-name> [--date YYYY-MM-DD]
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

change_name="$1"
shift
change_date="$(workflow_today)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --date)
      shift
      change_date="${1:-}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift
done

"$script_dir/speclawd-new-change.sh" "$change_name" --date "$change_date"

root_dir="$(workflow_root_dir)"
change_id="${change_date}-${change_name}"
change_dir="$root_dir/docs/changes/$change_id"
state_file="$(workflow_state_file "$change_dir")"

workflow_write_state \
  "$state_file" \
  "$change_id" \
  "spec-brief" \
  "waiting-confirmation" \
  "implementation" \
  "true" \
  "design-review" \
  "change-init" \
  "speclawd:approve" \
  "specld:approve" \
  "$(workflow_today)"

echo "Started workflow: $change_dir"
echo "Current stage: spec-brief"
echo "Waiting for confirmation: design-review"
echo "Next command: speclawd:approve (alias: specld:approve)"
