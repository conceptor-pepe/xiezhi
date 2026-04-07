#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: speclawd/scripts/speclawd-check-pr.sh <base-sha> <head-sha> [pr-body-file]" >&2
  exit 1
fi

base_sha="$1"
head_sha="$2"
body_file="${3:-}"
body=""

if [[ -n "$body_file" ]]; then
  body="$(cat "$body_file")"
elif [[ -n "${PR_BODY:-}" ]]; then
  body="${PR_BODY}"
fi

mapfile -t changed_files < <(git diff --name-only --diff-filter=ACMR "$base_sha" "$head_sha")
requires_change=0

for file in "${changed_files[@]}"; do
  case "$file" in
    internal/*|cmd/*|docs/api/*|scripts/migration/*)
      requires_change=1
      break
      ;;
  esac
done

if [[ $requires_change -eq 0 ]]; then
  echo "No high-risk scoped file changes detected."
  exit 0
fi

for file in "${changed_files[@]}"; do
  case "$file" in
    docs/changes/*)
      echo "Change artifacts detected."
      exit 0
      ;;
  esac
done

if [[ "$body" == *"speclawd spec waiver:"* ]] || [[ "$body" == *"Speclawd Spec 豁免："* ]]; then
  echo "Waiver found."
  exit 0
fi

echo "Missing change artifacts or waiver." >&2
exit 1
