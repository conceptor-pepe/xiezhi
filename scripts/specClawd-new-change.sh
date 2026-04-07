#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  specClawd/scripts/specClawd-new-change.sh <change-name>
  specClawd/scripts/specClawd-new-change.sh <change-name> --date YYYY-MM-DD
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

change_name="$1"
shift
change_date="$(date +%F)"

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

if [[ ! "$change_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "change-name must use kebab-case" >&2
  exit 1
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
change_dir="$root_dir/docs/changes/${change_date}-${change_name}"
if [[ -d "$root_dir/docs/templates" ]]; then
  template_dir="$root_dir/docs/templates"
else
  template_dir="$root_dir/templates/backend-brownfield"
fi

mkdir -p "$change_dir"

for name in change spec-delta design tasks review audit test-review commit-summary archive error-memory; do
  sed "s/<change-name>/${change_date}-${change_name}/g" "$template_dir/$name.md" >"$change_dir/$name.md"
done

cat >"$change_dir/workflow-state.json" <<EOF
{
  "change_id": "${change_date}-${change_name}",
  "current_stage": "change-init",
  "stage_status": "completed",
  "next_stage": "spec-brief",
  "waiting_for_confirmation": false,
  "pending_confirmation_for": "",
  "completed_stages": [
    "change-init"
  ],
  "recommended_command": "specClawd:start",
  "recommended_alias": "specld:start",
  "updated_at": "${change_date}"
}
EOF

echo "Created change: $change_dir"
