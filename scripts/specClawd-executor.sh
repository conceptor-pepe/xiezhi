#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./specClawd-workflow-lib.sh
source "$script_dir/specClawd-workflow-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  scripts/specClawd-executor.sh <change-dir>
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

change_dir="${1%/}"
workflow_require_change_dir "$change_dir"
state_file="$(workflow_state_file "$change_dir")"
stage="$(workflow_get_string "$state_file" "current_stage")"
root_dir="$(workflow_root_dir)"
if [[ -f "$root_dir/docs/specClawd/adapters/workflow-actions.json" ]]; then
  actions_file="$root_dir/docs/specClawd/adapters/workflow-actions.json"
else
  actions_file="$root_dir/adapters/shared/workflow-actions.json"
fi

workflow_require_file "$actions_file"

python3 - "$actions_file" "$stage" "$change_dir" "$state_file" <<'PY'
import json
import sys

actions_path, stage, change_dir, state_file = sys.argv[1:]
with open(actions_path, "r", encoding="utf-8") as f:
    data = json.load(f)

stage_def = data["stages"].get(stage)
if stage_def is None:
    print(json.dumps({
        "change_dir": change_dir,
        "state_file": state_file,
        "current_stage": stage,
        "error": f"no action definition for stage: {stage}"
    }, ensure_ascii=False, indent=2))
    sys.exit(1)

print(json.dumps({
    "change_dir": change_dir,
    "state_file": state_file,
    "current_stage": stage,
    "artifacts_to_update": stage_def.get("artifacts_to_update", []),
    "agent_actions": stage_def.get("agent_actions", []),
    "completion_gate": stage_def.get("completion_gate", ""),
    "confirmation_prompt": stage_def.get("confirmation_prompt", ""),
    "next_stage_on_approve": stage_def.get("next_stage_on_approve", "")
}, ensure_ascii=False, indent=2))
PY
