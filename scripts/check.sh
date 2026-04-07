#!/usr/bin/env bash

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Checking shell scripts..."
mapfile -t shell_files < <(find "$root_dir" -type f \( -name '*.sh' \) | sort)
if [[ ${#shell_files[@]} -gt 0 ]]; then
  bash -n "${shell_files[@]}"
fi

echo "Checking profile manifests..."
for manifest in "$root_dir"/profiles/*/manifest.tsv; do
  [[ -f "$manifest" ]] || continue
  while IFS=$'\t' read -r src rel_dst; do
    [[ -z "$src" ]] && continue
    if [[ ! -f "$root_dir/$src" ]]; then
      echo "Missing manifest source: $manifest -> $src" >&2
      exit 1
    fi
    if [[ -z "$rel_dst" ]]; then
      echo "Missing manifest destination: $manifest -> $src" >&2
      exit 1
    fi
  done < "$manifest"
done

echo "Checking init flows..."
for profile in minimal go-service backend-brownfield; do
  tmpdir="$(mktemp -d)"
  "$root_dir/install/init.sh" --target "$tmpdir" --profile "$profile" >/dev/null
  if [[ ! -d "$tmpdir/docs" ]]; then
    echo "Init failed for profile: $profile" >&2
    exit 1
  fi
done

echo "Checking example verify and archive flows..."
example_change="$root_dir/examples/go-backend/docs/changes/2026-04-04-add-team-join-audit"
"$root_dir/scripts/speclawd-verify.sh" "$example_change" >/dev/null
"$root_dir/scripts/speclawd-archive.sh" "$example_change" >/dev/null

echo "Checking required root files..."
for file in README.md VERSION CHANGELOG.md LICENSE; do
  if [[ ! -f "$root_dir/$file" ]]; then
    echo "Missing root file: $file" >&2
    exit 1
  fi
done

echo "Speclawd checks passed."
