#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./specClawd-workflow-lib.sh
source "$script_dir/specClawd-workflow-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  scripts/specClawd-continue.sh <change-dir>
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

change_dir="${1%/}"
workflow_require_change_dir "$change_dir"
state_file="$(workflow_state_file "$change_dir")"

change_id="$(workflow_get_string "$state_file" "change_id")"
current_stage="$(workflow_get_string "$state_file" "current_stage")"
waiting="$(workflow_get_bool "$state_file" "waiting_for_confirmation")"
completed="$(workflow_get_completed_stages "$state_file")"
today="$(workflow_today)"

if [[ "$waiting" == "true" ]]; then
  echo "Workflow is waiting for confirmation: $(workflow_get_string "$state_file" "pending_confirmation_for")" >&2
  echo "Use specClawd:approve or specld:approve first." >&2
  exit 1
fi

case "$current_stage" in
  implementation)
    workflow_require_stage_files_ready "$change_dir" change.md spec-delta.md design.md tasks.md
    completed="$(workflow_append_stage "$completed" "implementation")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "review-pack" \
      "waiting-confirmation" \
      "verify" \
      "true" \
      "verify" \
      "$completed" \
      "specClawd:approve" \
      "specld:approve" \
      "$today"
    ;;
  verify)
    "$script_dir/specClawd-verify.sh" "$change_dir" >/dev/null
    completed="$(workflow_append_stage "$completed" "verify")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "commit-summary" \
      "waiting-confirmation" \
      "archive" \
      "true" \
      "commit-summary" \
      "$completed" \
      "specClawd:approve" \
      "specld:approve" \
      "$today"
    ;;
  commit-summary)
    workflow_require_stage_files_ready "$change_dir" commit-summary.md
    completed="$(workflow_append_stage "$completed" "commit-summary")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "archive" \
      "waiting-confirmation" \
      "" \
      "true" \
      "archive" \
      "$completed" \
      "specClawd:approve" \
      "specld:approve" \
      "$today"
    ;;
  archive)
    "$script_dir/specClawd-archive.sh" "$change_dir" >/dev/null
    completed="$(workflow_append_stage "$completed" "archive")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "archive" \
      "completed" \
      "" \
      "false" \
      "" \
      "$completed" \
      "" \
      "" \
      "$today"
    ;;
  *)
    echo "No continue transition defined for stage: $current_stage" >&2
    exit 1
    ;;
esac

echo "Continued workflow: $change_dir"
echo "Current stage: $(workflow_get_string "$state_file" "current_stage")"
echo "Recommended command: $(workflow_get_string "$state_file" "recommended_command")"
