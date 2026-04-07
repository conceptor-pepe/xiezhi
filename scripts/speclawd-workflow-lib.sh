#!/usr/bin/env bash

set -euo pipefail

workflow_usage_root() {
  cat <<'EOF'
Stateful workflow helpers for Speclawd.
EOF
}

workflow_root_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

workflow_state_file() {
  local change_dir="$1"
  printf '%s/workflow-state.json\n' "${change_dir%/}"
}

workflow_require_change_dir() {
  local change_dir="${1%/}"
  if [[ ! -d "$change_dir" ]]; then
    echo "Change directory not found: $change_dir" >&2
    exit 1
  fi
  if [[ ! -f "$(workflow_state_file "$change_dir")" ]]; then
    echo "workflow-state.json not found: $change_dir" >&2
    exit 1
  fi
}

workflow_trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

workflow_get_string() {
  local file="$1"
  local key="$2"
  sed -n "s/^[[:space:]]*\"$key\": \"\\([^\"]*\\)\".*/\\1/p" "$file" | head -n 1
}

workflow_get_bool() {
  local file="$1"
  local key="$2"
  sed -n "s/^[[:space:]]*\"$key\": \\(true\\|false\\).*/\\1/p" "$file" | head -n 1
}

workflow_get_completed_stages() {
  local file="$1"
  sed -n '/"completed_stages": \[/,/\]/p' "$file" | tail -n +2 | rg -o '"[^"]+"' | tr -d '"' | paste -sd, -
}

workflow_append_stage() {
  local csv="$1"
  local stage="$2"
  if [[ -z "$csv" ]]; then
    printf '%s\n' "$stage"
    return 0
  fi
  if printf '%s' "$csv" | tr ',' '\n' | rg -x "$stage" >/dev/null 2>&1; then
    printf '%s\n' "$csv"
    return 0
  fi
  printf '%s,%s\n' "$csv" "$stage"
}

workflow_write_state() {
  local file="$1"
  local change_id="$2"
  local current_stage="$3"
  local stage_status="$4"
  local next_stage="$5"
  local waiting_for_confirmation="$6"
  local pending_confirmation_for="$7"
  local completed_stages_csv="$8"
  local recommended_command="$9"
  local recommended_alias="${10}"
  local updated_at="${11}"

  local completed_json=""
  local first=1
  local stage
  while IFS= read -r stage || [[ -n "$stage" ]]; do
    [[ -z "$stage" ]] && continue
    if [[ $first -eq 0 ]]; then
      completed_json="${completed_json},"$'\n'
    fi
    completed_json="${completed_json}    \"${stage}\""
    first=0
  done < <(printf '%s' "$completed_stages_csv" | tr ',' '\n')

  cat >"$file" <<EOF
{
  "change_id": "${change_id}",
  "current_stage": "${current_stage}",
  "stage_status": "${stage_status}",
  "next_stage": "${next_stage}",
  "waiting_for_confirmation": ${waiting_for_confirmation},
  "pending_confirmation_for": "${pending_confirmation_for}",
  "completed_stages": [
${completed_json}
  ],
  "recommended_command": "${recommended_command}",
  "recommended_alias": "${recommended_alias}",
  "updated_at": "${updated_at}"
}
EOF
}

workflow_today() {
  date +%F
}

workflow_require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Required file not found: $path" >&2
    exit 1
  fi
}

workflow_require_no_placeholders() {
  local path="$1"
  workflow_require_file "$path"
  if rg -n '<[^>]+>' "$path" >/dev/null 2>&1; then
    echo "Placeholders remain in: $path" >&2
    exit 1
  fi
}

workflow_require_stage_files_ready() {
  local change_dir="$1"
  shift
  local rel
  for rel in "$@"; do
    workflow_require_no_placeholders "$change_dir/$rel"
  done
}

workflow_change_id_from_dir() {
  basename "${1%/}"
}
