#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./specClawd-workflow-lib.sh
source "$script_dir/specClawd-workflow-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  scripts/specClawd-approve.sh <change-dir>
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
pending="$(workflow_get_string "$state_file" "pending_confirmation_for")"
completed="$(workflow_get_completed_stages "$state_file")"
today="$(workflow_today)"

if [[ "$(workflow_get_bool "$state_file" "waiting_for_confirmation")" != "true" ]]; then
  echo "Workflow is not waiting for confirmation: $change_dir" >&2
  exit 1
fi

case "$pending" in
  design-review)
    workflow_require_stage_files_ready "$change_dir" change.md spec-delta.md design.md tasks.md
    completed="$(workflow_append_stage "$completed" "design-review")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "implementation" \
      "in-progress" \
      "review-pack" \
      "false" \
      "" \
      "$completed" \
      "specClawd:continue" \
      "specld:next" \
      "$today"
    ;;
  verify)
    workflow_require_stage_files_ready "$change_dir" review.md audit.md test-review.md error-memory.md
    completed="$(workflow_append_stage "$completed" "review-pack")"
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "verify" \
      "in-progress" \
      "commit-summary" \
      "false" \
      "" \
      "$completed" \
      "specClawd:continue" \
      "specld:next" \
      "$today"
    ;;
  commit-summary)
    workflow_require_stage_files_ready "$change_dir" commit-summary.md
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "commit-summary" \
      "in-progress" \
      "archive" \
      "false" \
      "" \
      "$completed" \
      "specClawd:continue" \
      "specld:next" \
      "$today"
    ;;
  archive)
    workflow_require_stage_files_ready "$change_dir" archive.md
    workflow_write_state \
      "$state_file" \
      "$change_id" \
      "archive" \
      "in-progress" \
      "" \
      "false" \
      "" \
      "$completed" \
      "specClawd:continue" \
      "specld:next" \
      "$today"
    ;;
  *)
    echo "No approval transition defined for pending stage: $pending" >&2
    exit 1
    ;;
esac

echo "Approved workflow stage: $pending"
echo "Current stage: $(workflow_get_string "$state_file" "current_stage")"
echo "Recommended command: $(workflow_get_string "$state_file" "recommended_command")"
