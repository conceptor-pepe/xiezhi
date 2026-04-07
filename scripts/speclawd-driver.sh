#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./speclawd-workflow-lib.sh
source "$script_dir/speclawd-workflow-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  scripts/speclawd-driver.sh start <change-name> [--date YYYY-MM-DD]
  scripts/speclawd-driver.sh status <change-dir>
  scripts/speclawd-driver.sh exec <change-dir>
  scripts/speclawd-driver.sh approve <change-dir>
  scripts/speclawd-driver.sh next <change-dir>
EOF
}

print_status() {
  local change_dir="${1%/}"
  workflow_require_change_dir "$change_dir"
  local state_file current_stage stage_status next_stage waiting pending cmd alias
  state_file="$(workflow_state_file "$change_dir")"
  current_stage="$(workflow_get_string "$state_file" "current_stage")"
  stage_status="$(workflow_get_string "$state_file" "stage_status")"
  next_stage="$(workflow_get_string "$state_file" "next_stage")"
  waiting="$(workflow_get_bool "$state_file" "waiting_for_confirmation")"
  pending="$(workflow_get_string "$state_file" "pending_confirmation_for")"
  cmd="$(workflow_get_string "$state_file" "recommended_command")"
  alias="$(workflow_get_string "$state_file" "recommended_alias")"

  cat <<EOF
change_dir: $change_dir
current_stage: $current_stage
stage_status: $stage_status
next_stage: $next_stage
waiting_for_confirmation: $waiting
pending_confirmation_for: $pending
recommended_command: $cmd
recommended_alias: $alias
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

subcmd="$1"
shift

case "$subcmd" in
  start)
    if [[ $# -lt 1 ]]; then
      usage
      exit 1
    fi
    change_name="$1"
    shift
    "$script_dir/speclawd-start.sh" "$change_name" "$@"
    root_dir="$(workflow_root_dir)"
    if [[ $# -ge 2 && "$1" == "--date" ]]; then
      change_dir="$root_dir/docs/changes/${2}-${change_name}"
    else
      change_dir="$root_dir/docs/changes/$(workflow_today)-${change_name}"
    fi
    echo
    "$script_dir/speclawd-executor.sh" "$change_dir"
    ;;
  status)
    if [[ $# -ne 1 ]]; then
      usage
      exit 1
    fi
    print_status "$1"
    ;;
  exec)
    if [[ $# -ne 1 ]]; then
      usage
      exit 1
    fi
    "$script_dir/speclawd-executor.sh" "$1"
    ;;
  approve)
    if [[ $# -ne 1 ]]; then
      usage
      exit 1
    fi
    "$script_dir/speclawd-approve.sh" "$1"
    echo
    print_status "$1"
    echo
    "$script_dir/speclawd-executor.sh" "$1" || true
    ;;
  next)
    if [[ $# -ne 1 ]]; then
      usage
      exit 1
    fi
    "$script_dir/speclawd-continue.sh" "$1"
    echo
    print_status "$1"
    echo
    "$script_dir/speclawd-executor.sh" "$1" || true
    ;;
  *)
    usage
    exit 1
    ;;
esac
