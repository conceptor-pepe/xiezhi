#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: scripts/specledger-verify.sh <change-dir>" >&2
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

task_gate_ok() {
  local tasks_file="$1"
  awk '
    /^## 4\. Archive/ { in_archive=1 }
    !in_archive && /- \[ \]/ { found=1 }
    END { exit(found ? 1 : 0) }
  ' "$tasks_file"
}

extract_status() {
  local file="$1"
  local key="$2"
  local result
  result="$(
    awk -F': ' -v wanted="$key" '
    $0 ~ "^- " wanted ":" {
      print $2
      exit
    }
  ' "$file"
  )"
  if [[ -z "$result" ]]; then
    return 1
  fi
  printf '%s\n' "$result"
}

extract_commit_validation_status() {
  local file="$1"
  local key="$2"
  local line

  line="$(grep -m 1 '^\*\*验证结果\*\*：' "$file" || true)"
  if [[ -z "$line" ]]; then
    return 1
  fi

  case "$key" in
    build)
      [[ "$line" == *"编译通过 ✅"* ]] && printf 'pass\n' && return 0
      [[ "$line" == *"编译通过 ❌"* ]] && printf 'fail\n' && return 0
      ;;
    lint)
      [[ "$line" == *"Lint 清洁 ✅"* ]] && printf 'pass\n' && return 0
      [[ "$line" == *"Lint 清洁 ❌"* ]] && printf 'fail\n' && return 0
      ;;
    test)
      [[ "$line" == *"测试通过 ✅"* ]] && printf 'pass\n' && return 0
      [[ "$line" == *"测试通过 ❌"* ]] && printf 'fail\n' && return 0
      ;;
    audit)
      [[ "$line" == *"编码规范审计 ✅"* ]] && printf 'pass\n' && return 0
      [[ "$line" == *"编码规范审计 ❌"* ]] && printf 'fail\n' && return 0
      ;;
  esac

  return 1
}

extract_audit_status() {
  local file="$1"
  local key="$2"
  local legacy

  legacy="$(extract_status "$file" "$key" || true)"
  if [[ -n "$legacy" ]]; then
    printf '%s\n' "$legacy"
    return 0
  fi

  case "$key" in
    status)
      if rg -n '^## go-audit$' "$file" >/dev/null 2>&1; then
        if rg -n 'result: pass|结果：通过|结果：未通过|result: fail' "$file" >/dev/null 2>&1; then
          if rg -n 'result: pass|结果：通过' "$file" >/dev/null 2>&1; then
            printf 'pass\n'
          else
            printf 'fail\n'
          fi
          return 0
        fi
      fi
      ;;
    build)
      if rg -n '编译通过|build: pass' "$file" >/dev/null 2>&1; then
        printf 'pass\n'
        return 0
      fi
      ;;
    lint)
      if rg -n 'lint: pass|Lint 清洁 ✅' "$file" >/dev/null 2>&1; then
        printf 'pass\n'
        return 0
      fi
      if rg -n 'lint: fail|Lint 清洁 ❌' "$file" >/dev/null 2>&1; then
        printf 'fail\n'
        return 0
      fi
      ;;
    test)
      if rg -n '测试通过|test: pass' "$file" >/dev/null 2>&1; then
        printf 'pass\n'
        return 0
      fi
      if rg -n 'test: fail' "$file" >/dev/null 2>&1; then
        printf 'fail\n'
        return 0
      fi
      ;;
  esac

  return 1
}

warn_status() {
  local label="$1"
  local status="$2"
  if [[ "$status" == "not-run" ]]; then
    echo "Warning: $label is marked not-run" >&2
  fi
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

change_dir="${1%/}"
if [[ ! -d "$change_dir" ]]; then
  echo "Change directory not found: $change_dir" >&2
  exit 1
fi

repo_root="$(repo_root_from_change "$change_dir" || true)"
if [[ -z "$repo_root" ]]; then
  echo "Unable to determine repository root from change dir: $change_dir" >&2
  exit 1
fi

required=(
  change.md
  spec-delta.md
  design.md
  tasks.md
  review.md
  audit.md
  test-review.md
  commit-summary.md
)

for file in "${required[@]}"; do
  if [[ ! -f "$change_dir/$file" ]]; then
    echo "Missing file: $change_dir/$file" >&2
    exit 1
  fi
done

for file in "${required[@]}"; do
  require_no_placeholders "$change_dir/$file"
done

if ! task_gate_ok "$change_dir/tasks.md"; then
  echo "Unchecked tasks remain before archive stage: $change_dir/tasks.md" >&2
  exit 1
fi

go_audit_status="$(extract_audit_status "$change_dir/audit.md" "status" || true)"
build_status="$(extract_audit_status "$change_dir/audit.md" "build" || true)"
lint_status="$(extract_audit_status "$change_dir/audit.md" "lint" || true)"
test_status="$(extract_audit_status "$change_dir/audit.md" "test" || true)"

if [[ "$go_audit_status" != "pass" ]]; then
  echo "Go audit must be pass, got: ${go_audit_status:-missing}" >&2
  exit 1
fi

for item in "build:$build_status" "lint:$lint_status" "test:$test_status"; do
  name="${item%%:*}"
  status="${item#*:}"
  if [[ "$status" == "fail" ]]; then
    echo "$name is marked fail in audit.md" >&2
    exit 1
  fi
  warn_status "$name" "$status"
done

if ! rg -n '^\|.*\|.*\|.*\|.*\|.*\|$' "$change_dir/test-review.md" >/dev/null 2>&1; then
  echo "Test review must include a case table: $change_dir/test-review.md" >&2
  exit 1
fi

if ! rg -n '^## (Review Summary|Conclusion|测试功能结论|Must Fix \(Critical\)|Optional Improvements)$' "$change_dir/test-review.md" >/dev/null 2>&1; then
  echo "Test review must include summary and conclusion sections: $change_dir/test-review.md" >&2
  exit 1
fi

summary_build="$(extract_commit_validation_status "$change_dir/commit-summary.md" "build" || extract_status "$change_dir/commit-summary.md" "build" || true)"
summary_lint="$(extract_commit_validation_status "$change_dir/commit-summary.md" "lint" || extract_status "$change_dir/commit-summary.md" "lint" || true)"
summary_test="$(extract_commit_validation_status "$change_dir/commit-summary.md" "test" || extract_status "$change_dir/commit-summary.md" "test" || true)"
summary_audit="$(extract_commit_validation_status "$change_dir/commit-summary.md" "audit" || extract_status "$change_dir/commit-summary.md" "audit" || true)"

for item in "build:$summary_build" "lint:$summary_lint" "test:$summary_test" "audit:$summary_audit"; do
  name="${item%%:*}"
  status="${item#*:}"
  if [[ -z "$status" ]]; then
    echo "Missing $name validation status in commit-summary.md" >&2
    exit 1
  fi
  if [[ "$status" == "fail" ]]; then
    echo "commit-summary.md marks $name as fail" >&2
    exit 1
  fi
  warn_status "commit-summary $name" "$status"
done

if [[ "$summary_audit" != "pass" ]]; then
  echo "commit-summary.md must record audit as pass, got: $summary_audit" >&2
  exit 1
fi

echo "Verify passed: $change_dir"
echo "Repository root: $repo_root"
