#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: scripts/specClawd-archive.sh [--move] <change-dir>" >&2
}

repo_root_from_change() {
  local dir="$1"
  local abs_dir
  abs_dir="$(cd "$dir" && pwd)"

  case "$abs_dir" in
    */docs/changes/*)
      printf '%s\n' "${abs_dir%%/docs/changes/*}"
      return 0
      ;;
  esac

  if git -C "$abs_dir" rev-parse --show-toplevel >/dev/null 2>&1; then
    git -C "$abs_dir" rev-parse --show-toplevel
    return 0
  fi

  return 1
}

require_no_placeholders() {
  local path="$1"
  if rg -n '<[^>]+>' "$path" >/dev/null 2>&1; then
    echo "Placeholders remain in: $path" >&2
    return 1
  fi
  return 0
}

require_heading() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  if ! rg -n "$pattern" "$path" >/dev/null 2>&1; then
    echo "$message: $path" >&2
    exit 1
  fi
}

extract_ids() {
  local path="$1"
  local prefix="$2"
  rg -o "${prefix}-[0-9]{3}" "$path" | sort -u
}

require_ids_referenced() {
  local source_path="$1"
  local target_path="$2"
  local prefix="$3"
  local label="$4"
  local ids
  ids="$(extract_ids "$source_path" "$prefix" || true)"
  if [[ -z "$ids" ]]; then
    echo "Missing ${prefix} ids in $source_path" >&2
    exit 1
  fi

  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    if ! rg -n "$id" "$target_path" >/dev/null 2>&1; then
      echo "$label is missing reference to $id from $source_path: $target_path" >&2
      exit 1
    fi
  done <<<"$ids"
}

move_after_check=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --move)
      move_after_check=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "${change_dir:-}" ]]; then
        change_dir="${1%/}"
      else
        usage
        exit 1
      fi
      ;;
  esac
  shift
done

if [[ -z "${change_dir:-}" ]]; then
  usage
  exit 1
fi

if [[ ! -d "$change_dir" ]]; then
  echo "Change directory not found: $change_dir" >&2
  exit 1
fi

repo_root="$(repo_root_from_change "$change_dir" || true)"
if [[ -z "$repo_root" ]]; then
  echo "Unable to determine repository root from change dir: $change_dir" >&2
  exit 1
fi

"$script_dir/specClawd-verify.sh" "$change_dir"

for file in spec-delta.md audit.md test-review.md commit-summary.md archive.md error-memory.md; do
  if [[ ! -f "$change_dir/$file" ]]; then
    echo "Missing file: $change_dir/$file" >&2
    exit 1
  fi
  require_no_placeholders "$change_dir/$file"
done

require_heading "$change_dir/archive.md" '^## Traceability Summary$' "archive.md must include traceability summary"
require_heading "$change_dir/error-memory.md" '^## New Lessons$' "error-memory.md must include new lessons"
require_heading "$change_dir/error-memory.md" '^## Reused Lessons$' "error-memory.md must include reused lessons"

require_ids_referenced "$change_dir/spec-delta.md" "$change_dir/archive.md" "REQ" "archive.md"
require_ids_referenced "$change_dir/design.md" "$change_dir/archive.md" "DES" "archive.md"
require_ids_referenced "$change_dir/tasks.md" "$change_dir/archive.md" "TASK" "archive.md"
require_ids_referenced "$change_dir/review.md" "$change_dir/archive.md" "REV" "archive.md"
require_ids_referenced "$change_dir/test-review.md" "$change_dir/archive.md" "CASE" "archive.md"
require_ids_referenced "$change_dir/error-memory.md" "$change_dir/archive.md" "MEM" "archive.md"

mapfile -t spec_targets < <(grep -o '`docs/specs/[^`]*`' "$change_dir/archive.md" | tr -d '`')
if [[ ${#spec_targets[@]} -eq 0 ]]; then
  echo "archive.md must list at least one spec target under docs/specs/" >&2
  exit 1
fi

for rel_path in "${spec_targets[@]}"; do
  if [[ ! -f "$repo_root/$rel_path" ]]; then
    echo "Spec target does not exist: $repo_root/$rel_path" >&2
    exit 1
  fi
done

completion_status="$(awk -F': ' '/^- status:/ { print $2; exit }' "$change_dir/archive.md")"
if [[ -z "$completion_status" ]]; then
  echo "archive.md must include completion status" >&2
  exit 1
fi

archive_root="$repo_root/docs/changes/archive"
archive_target="$archive_root/$(basename "$change_dir")"

echo "Archive checks passed: $change_dir"
echo "Repository root: $repo_root"
echo "Spec targets:"
printf '  - %s\n' "${spec_targets[@]}"

if [[ $move_after_check -eq 0 ]]; then
  echo "Next: update specs if needed, set archive status, then rerun with --move to move the change."
  exit 0
fi

if [[ "$completion_status" != "done" ]]; then
  echo "archive status must be done before --move, got: $completion_status" >&2
  exit 1
fi

mkdir -p "$archive_root"
if [[ -e "$archive_target" ]]; then
  echo "Archive target already exists: $archive_target" >&2
  exit 1
fi

mv "$change_dir" "$archive_target"
echo "Archived change moved to: $archive_target"
