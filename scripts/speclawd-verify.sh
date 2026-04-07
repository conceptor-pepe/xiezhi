#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: scripts/speclawd-verify.sh <change-dir>" >&2
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

require_ids_present() {
  local path="$1"
  local prefix="$2"
  local message="$3"
  if ! extract_ids "$path" "$prefix" >/dev/null 2>&1; then
    echo "$message: $path" >&2
    exit 1
  fi
}

count_ids() {
  local path="$1"
  local prefix="$2"
  extract_ids "$path" "$prefix" | sed '/^$/d' | wc -l | tr -d ' '
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

require_no_filler_text() {
  local path="$1"
  local label="$2"
  if rg -n -i '\b(tbd|todo|fixme|xxx)\b|same as above|see above|待补充|待确认|待定|自行补充' "$path" >/dev/null 2>&1; then
    echo "$label contains filler or unresolved text: $path" >&2
    exit 1
  fi
}

require_nontrivial_value() {
  local path="$1"
  local prefix="$2"
  local label="$3"
  local value
  value="$(awk -F': ' -v wanted="$prefix" '$0 ~ "^- " wanted ":" { print $2; exit }' "$path")"
  if [[ -z "$value" ]]; then
    echo "$label is missing: $path" >&2
    exit 1
  fi

  case "${value,,}" in
    none|n/a|na|ok|pass|done|yes|no|partial|missing|weak|covered|acceptable)
      echo "$label is too shallow: $path" >&2
      exit 1
      ;;
  esac

  value="$(printf '%s' "$value" | tr -d '[:space:]')"
  if [[ ${#value} -lt 8 ]]; then
    echo "$label is too short: $path" >&2
    exit 1
  fi
}

require_result_table_matches_cases() {
  local path="$1"
  local case_ids result_ids missing
  case_ids="$(
    sed -n '/^## 测试用例设计$/,/^## 按用例评审结果$/p' "$path" \
      | rg -o 'CASE-[0-9][0-9][0-9]' \
      | sort -u
  )"
  result_ids="$(
    sed -n '/^## 按用例评审结果$/,/^## 白盒覆盖检查$/p' "$path" \
      | rg -o 'CASE-[0-9][0-9][0-9]' \
      | sort -u
  )"

  if [[ -z "$case_ids" || -z "$result_ids" ]]; then
    echo "test-review case design and result tables must both contain CASE ids: $path" >&2
    exit 1
  fi

  missing="$(comm -3 <(printf '%s\n' "$case_ids") <(printf '%s\n' "$result_ids") || true)"
  if [[ -n "$missing" ]]; then
    echo "test-review case design and result tables must cover the same CASE ids: $path" >&2
    exit 1
  fi
}

validate_test_review_issues() {
  local test_review_path="$1"
  local review_path="$2"
  local row_count=0

  while IFS= read -r line; do
    [[ "$line" =~ ^\|\ \`CASE-[0-9]{3}\` ]] || continue
    row_count=$((row_count + 1))

    IFS='|' read -r _ case_raw result_raw evidence_raw issues_raw _rest <<<"$line"
    local case_id result issues
    case_id="$(trim "$case_raw")"
    result="$(printf '%s' "$(trim "$result_raw")" | tr -d '`' | tr '[:upper:]' '[:lower:]')"
    issues="$(trim "$issues_raw")"

    if [[ "$result" != "pass" && "$result" != "fail" && "$result" != "risk" ]]; then
      echo "Test review result must be pass, fail, or risk: $test_review_path -> $case_id" >&2
      exit 1
    fi

    if [[ "$issues" == "none" ]]; then
      if [[ "$result" == "fail" || "$result" == "risk" ]]; then
        echo "Risky or failed case cannot use 'none' in Issues Found: $test_review_path -> $case_id" >&2
        exit 1
      fi
      continue
    fi

    if ! printf '%s' "$issues" | rg -q 'REV-[0-9]{3}|TEST-RISK-[0-9]{3}'; then
      echo "Issues Found must reference REV-* or TEST-RISK-* ids: $test_review_path -> $case_id" >&2
      exit 1
    fi

    while IFS= read -r issue_id; do
      [[ -z "$issue_id" ]] && continue
      case "$issue_id" in
        REV-*)
          if ! rg -n "$issue_id" "$review_path" >/dev/null 2>&1; then
            echo "Issues Found references missing review finding $issue_id: $test_review_path -> $case_id" >&2
            exit 1
          fi
          ;;
        TEST-RISK-*)
          if ! rg -n "$issue_id" "$test_review_path" >/dev/null 2>&1; then
            echo "Issues Found references missing test risk $issue_id: $test_review_path -> $case_id" >&2
            exit 1
          fi
          ;;
      esac
    done < <(printf '%s' "$issues" | rg -o 'REV-[0-9]{3}|TEST-RISK-[0-9]{3}' || true)
  done < <(sed -n '/^## 按用例评审结果$/,/^## 白盒覆盖检查$/p' "$test_review_path")

  if [[ $row_count -eq 0 ]]; then
    echo "test-review results table must contain at least one CASE row: $test_review_path" >&2
    exit 1
  fi
}

require_risk_coverage_mapping() {
  local design_path="$1"
  local review_path="$2"
  local test_review_path="$3"
  local risk_count task_count
  local risk_ids

  risk_ids="$(extract_ids "$design_path" "RISK" || true)"
  if [[ -z "$risk_ids" ]]; then
    echo "design.md must define RISK ids: $design_path" >&2
    exit 1
  fi

  while IFS= read -r risk_id; do
    [[ -z "$risk_id" ]] && continue
    if ! rg -n "$risk_id" "$design_path" >/dev/null 2>&1; then
      echo "Risk id missing from design.md: $design_path -> $risk_id" >&2
      exit 1
    fi
    if ! rg -n "$risk_id" "$review_path" >/dev/null 2>&1; then
      echo "review.md must reference risk id: $review_path -> $risk_id" >&2
      exit 1
    fi
    if ! rg -n "$risk_id" "$test_review_path" >/dev/null 2>&1; then
      echo "test-review.md must reference risk id: $test_review_path -> $risk_id" >&2
      exit 1
    fi
  done <<<"$risk_ids"

  risk_count="$(count_ids "$design_path" "RISK")"
  task_count="$(count_ids "$design_path" "TASK")"
  if [[ "$risk_count" -gt 1 && "$task_count" -lt 2 ]]; then
    echo "design.md has multiple risk points but fewer than two TASK ids; split risk ownership more clearly: $design_path" >&2
    exit 1
  fi
}

trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

validate_tasks_table() {
  local path="$1"
  local row_count=0
  local task_ids=""

  while IFS= read -r line; do
    [[ "$line" =~ ^\|\ \`TASK-[0-9]{3}\` ]] || continue
    row_count=$((row_count + 1))

    IFS='|' read -r _ task_id_raw goal_raw req_raw des_raw dep_raw files_raw acc_raw case_raw commit_raw status_raw _ <<<"$line"
    local task_id goal req_ids des_ids dep files acc case_ids committable status
    task_id="$(trim "$task_id_raw")"
    goal="$(trim "$goal_raw")"
    req_ids="$(trim "$req_raw")"
    des_ids="$(trim "$des_raw")"
    dep="$(trim "$dep_raw")"
    files="$(trim "$files_raw")"
    acc="$(trim "$acc_raw")"
    case_ids="$(trim "$case_raw")"
    committable="$(printf '%s' "$(trim "$commit_raw")" | tr '[:upper:]' '[:lower:]')"
    status="$(printf '%s' "$(trim "$status_raw")" | tr '[:upper:]' '[:lower:]')"

    task_ids="${task_ids}${task_id}"$'\n'

    if [[ -z "$goal" || ${#goal} -lt 8 ]]; then
      echo "Task goal is too short: $path -> $task_id" >&2
      exit 1
    fi
    if [[ -z "$files" || ${#files} -lt 8 ]]; then
      echo "Task files/modules entry is too short: $path -> $task_id" >&2
      exit 1
    fi
    if [[ -z "$acc" || ${#acc} -lt 12 ]]; then
      echo "Task acceptance criteria is too short: $path -> $task_id" >&2
      exit 1
    fi
    if [[ "$committable" != "yes" && "$committable" != "no" ]]; then
      echo "Task independently committable must be yes or no: $path -> $task_id" >&2
      exit 1
    fi
    if [[ "$status" != "todo" && "$status" != "in-progress" && "$status" != "done" ]]; then
      echo "Task status must be todo, in-progress, or done: $path -> $task_id" >&2
      exit 1
    fi
    if [[ "$dep" != "none" ]] && ! printf '%s' "$dep" | rg -q 'TASK-[0-9]{3}'; then
      echo "Task dependency must be none or reference TASK ids: $path -> $task_id" >&2
      exit 1
    fi
    if ! printf '%s' "$req_ids" | rg -q 'REQ-[0-9]{3}'; then
      echo "Task row must reference REQ ids: $path -> $task_id" >&2
      exit 1
    fi
    if ! printf '%s' "$des_ids" | rg -q 'DES-[0-9]{3}'; then
      echo "Task row must reference DES ids: $path -> $task_id" >&2
      exit 1
    fi
    if ! printf '%s' "$case_ids" | rg -q 'CASE-[0-9]{3}'; then
      echo "Task row must reference CASE ids: $path -> $task_id" >&2
      exit 1
    fi
  done <"$path"

  if [[ $row_count -eq 0 ]]; then
    echo "tasks.md must contain at least one TASK row: $path" >&2
    exit 1
  fi

  if [[ "$(printf '%s' "$task_ids" | sed '/^$/d' | sort | uniq -d)" != "" ]]; then
    echo "tasks.md contains duplicate TASK ids: $path" >&2
    exit 1
  fi
}

require_task_cases_referenced() {
  local tasks_path="$1"
  local test_review_path="$2"
  while IFS= read -r line; do
    [[ "$line" =~ ^\|\ \`TASK-[0-9]{3}\` ]] || continue
    IFS='|' read -r _ task_id_raw _ _ _ _ _ _ case_raw _ _ <<<"$line"
    local task_id case_ids
    task_id="$(trim "$task_id_raw")"
    case_ids="$(trim "$case_raw")"
    while IFS= read -r case_id; do
      [[ -z "$case_id" ]] && continue
      if ! rg -n "$case_id" "$test_review_path" >/dev/null 2>&1; then
        echo "Task case mapping is missing $case_id for $task_id: $test_review_path" >&2
        exit 1
      fi
    done < <(printf '%s' "$case_ids" | rg -o 'CASE-[0-9]{3}' || true)
  done <"$tasks_path"
}

task_gate_ok() {
  local tasks_file="$1"
  awk '
    /^## 5\. Archive Gate/ { in_archive=1 }
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

extract_heading_section() {
  local file="$1"
  local heading="$2"
  awk -v wanted="$heading" '
    $0 == wanted { in_section=1; next }
    /^## / && in_section { exit }
    in_section { print }
  ' "$file"
}

extract_audit_status() {
  local file="$1"
  local key="$2"
  local legacy
  local go_audit_section

  legacy="$(extract_status "$file" "$key" || true)"
  if [[ -n "$legacy" ]]; then
    printf '%s\n' "$legacy"
    return 0
  fi

  go_audit_section="$(extract_heading_section "$file" "## go-audit" || true)"

  case "$key" in
    status)
      if [[ -n "$go_audit_section" ]]; then
        if printf '%s\n' "$go_audit_section" | rg -q 'result: fail|结果：未通过'; then
          printf 'fail\n'
          return 0
        fi
        if printf '%s\n' "$go_audit_section" | rg -q 'result: pass|结果：通过'; then
          printf 'pass\n'
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

audit_rule_row_count() {
  local file="$1"
  rg -c '^\| `?AUDIT-[A-Z-]+[0-9]+`? \|' "$file" 2>/dev/null || true
}

require_file_if_present_parent() {
  local file="$1"
  local message="$2"
  if [[ ! -f "$file" ]]; then
    echo "$message: $file" >&2
    exit 1
  fi
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
  error-memory.md
)

for file in "${required[@]}"; do
  if [[ ! -f "$change_dir/$file" ]]; then
    echo "Missing file: $change_dir/$file" >&2
    exit 1
  fi
done

for file in "${required[@]}"; do
  require_no_placeholders "$change_dir/$file"
  require_no_filler_text "$change_dir/$file" "$file"
done

require_heading "$change_dir/design.md" '^## Step 1: Data Structure Design$' "design.md must include Step 1"
require_heading "$change_dir/design.md" '^## Step 2: API Contract Definition$' "design.md must include Step 2"
require_heading "$change_dir/design.md" '^## Step 3: Module Coupling Analysis$' "design.md must include Step 3"
require_heading "$change_dir/design.md" '^## Step 4: Task Split$' "design.md must include Step 4"
require_heading "$change_dir/design.md" '^### 4\.4 Review And Test Mapping$' "design.md must include review and test mapping"
require_heading "$change_dir/design.md" '^### 4\.5 Risk Coverage Mapping$' "design.md must include risk coverage mapping"

require_heading "$change_dir/tasks.md" '^## 2\. Task Breakdown$' "tasks.md must include task breakdown"
require_heading "$change_dir/tasks.md" '^## 4\. Verification Gate$' "tasks.md must include verification gate"
require_heading "$change_dir/tasks.md" '^## 5\. Archive Gate$' "tasks.md must include archive gate"
validate_tasks_table "$change_dir/tasks.md"

require_heading "$change_dir/review.md" '^## (Product Review|产品经理审计记录)$' "review.md must include product review"
require_heading "$change_dir/review.md" '^## (Architecture Review|架构师审计记录)$' "review.md must include architecture review"
require_heading "$change_dir/review.md" '^## (Senior Engineer Review|资深程序员审计记录)$' "review.md must include senior engineer review"
require_heading "$change_dir/review.md" '^## (Test Review Readiness|测试专家审计记录)$' "review.md must include test readiness"
require_heading "$change_dir/review.md" '^### 架构 Gate 结论$' "review.md must include architecture gate summary"
require_heading "$change_dir/review.md" '^### 架构检查矩阵$' "review.md must include architecture review matrix"
require_heading "$change_dir/review.md" '^### 架构关键判断$' "review.md must include architecture key judgments"
require_heading "$change_dir/review.md" '^### 代码 Gate 结论$' "review.md must include code gate summary"
require_heading "$change_dir/review.md" '^### 代码检查矩阵$' "review.md must include code review matrix"
require_heading "$change_dir/review.md" '^### 代码关键判断$' "review.md must include code key judgments"

require_heading "$change_dir/test-review.md" '^## 测试用例设计$' "test-review.md must include test case design"
require_heading "$change_dir/test-review.md" '^## 按用例评审结果$' "test-review.md must include case-by-case results"
require_heading "$change_dir/test-review.md" '^## 白盒覆盖检查$' "test-review.md must include white-box coverage"
require_heading "$change_dir/test-review.md" '^## 需修复（Critical）$' "test-review.md must include critical issues"
require_heading "$change_dir/test-review.md" '^## 可选优化（Suggestion）$' "test-review.md must include optional improvements"
require_heading "$change_dir/test-review.md" '^## 测试功能结论$' "test-review.md must include test conclusion"

require_heading "$change_dir/audit.md" '^## Scope$' "audit.md must include scope"
require_heading "$change_dir/audit.md" '^## Policy Sources$' "audit.md must include policy sources"
require_heading "$change_dir/audit.md" '^## Validation Summary$' "audit.md must include validation summary"
require_heading "$change_dir/audit.md" '^## Go Audit Execution$' "audit.md must include go audit execution"
require_heading "$change_dir/audit.md" '^## Audit Rule Checklist$' "audit.md must include audit rule checklist"
require_heading "$change_dir/audit.md" '^## Test Functionality Review Gate$' "audit.md must include test functionality gate"
require_heading "$change_dir/audit.md" '^## Additional Verification$' "audit.md must include additional verification"
require_heading "$change_dir/audit.md" '^## Blocking Issues$' "audit.md must include blocking issues"
require_heading "$change_dir/audit.md" '^## Current Conclusion$' "audit.md must include current conclusion"

require_heading "$change_dir/review.md" '^## Policy Sources$' "review.md must include policy sources"
require_heading "$change_dir/test-review.md" '^## Policy Sources$' "test-review.md must include policy sources"

require_ids_present "$change_dir/spec-delta.md" "REQ" "spec-delta.md must define REQ ids"
require_ids_present "$change_dir/design.md" "DES" "design.md must define DES ids"
require_ids_present "$change_dir/design.md" "RISK" "design.md must define RISK ids"
require_ids_present "$change_dir/tasks.md" "TASK" "tasks.md must define TASK ids"
require_ids_present "$change_dir/review.md" "REV" "review.md must define REV ids"
require_ids_present "$change_dir/test-review.md" "CASE" "test-review.md must define CASE ids"
require_ids_present "$change_dir/error-memory.md" "MEM" "error-memory.md must define MEM ids"

require_ids_referenced "$change_dir/spec-delta.md" "$change_dir/design.md" "REQ" "design.md"
require_ids_referenced "$change_dir/spec-delta.md" "$change_dir/tasks.md" "REQ" "tasks.md"
require_ids_referenced "$change_dir/design.md" "$change_dir/tasks.md" "DES" "tasks.md"
require_ids_referenced "$change_dir/design.md" "$change_dir/review.md" "RISK" "review.md"
require_ids_referenced "$change_dir/design.md" "$change_dir/test-review.md" "RISK" "test-review.md"
require_ids_referenced "$change_dir/tasks.md" "$change_dir/review.md" "TASK" "review.md"
require_ids_referenced "$change_dir/tasks.md" "$change_dir/test-review.md" "TASK" "test-review.md"
require_ids_referenced "$change_dir/spec-delta.md" "$change_dir/test-review.md" "REQ" "test-review.md"
require_task_cases_referenced "$change_dir/tasks.md" "$change_dir/test-review.md"
require_risk_coverage_mapping "$change_dir/design.md" "$change_dir/review.md" "$change_dir/test-review.md"
validate_test_review_issues "$change_dir/test-review.md" "$change_dir/review.md"

require_nontrivial_value "$change_dir/review.md" 'requirement coverage' "review product requirement coverage"
require_nontrivial_value "$change_dir/review.md" 'scope fit' "review product scope fit"
require_nontrivial_value "$change_dir/review.md" 'user-visible behavior' "review product user-visible behavior"
require_nontrivial_value "$change_dir/review.md" 'module boundary' "review architecture module boundary"
require_nontrivial_value "$change_dir/review.md" 'coupling decision' "review architecture coupling decision"
require_nontrivial_value "$change_dir/review.md" 'data consistency' "review architecture data consistency"
require_nontrivial_value "$change_dir/review.md" 'observability' "review architecture observability"
require_nontrivial_value "$change_dir/review.md" 'release architecture verdict' "review architecture verdict"
require_nontrivial_value "$change_dir/review.md" 'shallow module risk' "review shallow module risk"
require_nontrivial_value "$change_dir/review.md" 'coupling hotspot' "review coupling hotspot"
require_nontrivial_value "$change_dir/review.md" 'migration / script safety' "review migration safety"
require_nontrivial_value "$change_dir/review.md" 'code path correctness' "review engineer code path correctness"
require_nontrivial_value "$change_dir/review.md" 'edge cases checked' "review engineer edge cases"
require_nontrivial_value "$change_dir/review.md" 'failure handling' "review engineer failure handling"
require_nontrivial_value "$change_dir/review.md" 'maintainability' "review engineer maintainability"
require_nontrivial_value "$change_dir/review.md" 'release code verdict' "review engineer verdict"
require_nontrivial_value "$change_dir/review.md" 'silent failure risk' "review silent failure risk"
require_nontrivial_value "$change_dir/review.md" 'hidden branching risk' "review hidden branching risk"
require_nontrivial_value "$change_dir/review.md" 'maintainability debt' "review maintainability debt"
require_nontrivial_value "$change_dir/review.md" 'unit / integration coverage sufficiency' "review test readiness coverage"
require_nontrivial_value "$change_dir/review.md" 'white-box weak spots' "review test readiness white-box weak spots"
require_nontrivial_value "$change_dir/review.md" 'regressions to watch' "review test readiness regressions"

require_nontrivial_value "$change_dir/test-review.md" 'branch coverage focus' "test-review branch coverage"
require_nontrivial_value "$change_dir/test-review.md" 'error path focus' "test-review error path coverage"
require_nontrivial_value "$change_dir/test-review.md" 'boundary value focus' "test-review boundary value coverage"
require_nontrivial_value "$change_dir/test-review.md" 'observability focus' "test-review observability coverage"
require_nontrivial_value "$change_dir/test-review.md" 'product conclusion' "test-review product conclusion"
require_nontrivial_value "$change_dir/test-review.md" 'architect conclusion' "test-review architect conclusion"
require_nontrivial_value "$change_dir/test-review.md" 'senior engineer conclusion' "test-review engineer conclusion"
require_nontrivial_value "$change_dir/test-review.md" 'tester conclusion' "test-review tester conclusion"

require_nontrivial_value "$change_dir/audit.md" 'delivery status' "audit delivery status"
require_nontrivial_value "$change_dir/audit.md" 'audit gate' "audit gate status"
require_nontrivial_value "$change_dir/audit.md" 'release recommendation' "audit release recommendation"
require_nontrivial_value "$change_dir/audit.md" 'summary' "audit summary"

audit_rule_rows="$(audit_rule_row_count "$change_dir/audit.md")"
if [[ "$audit_rule_rows" -lt 1 ]]; then
  echo "audit.md must include at least one project-defined audit rule row: $change_dir/audit.md" >&2
  exit 1
fi

if [[ -d "$repo_root/docs/speclawd/policies" ]]; then
  require_file_if_present_parent "$repo_root/docs/speclawd/policies/audit-policy.md" "Missing repository audit policy"
  require_file_if_present_parent "$repo_root/docs/speclawd/policies/coding-standards.md" "Missing repository coding standards policy"
  require_file_if_present_parent "$repo_root/docs/speclawd/policies/test-review-policy.md" "Missing repository test review policy"
fi

require_result_table_matches_cases "$change_dir/test-review.md"

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

if ! rg -n '^\|.*\|.*\|.*\|.*\|.*\|.*\|.*\|.*\|$' "$change_dir/test-review.md" >/dev/null 2>&1; then
  echo "Test review must include a case table: $change_dir/test-review.md" >&2
  exit 1
fi

if ! rg -n '^## (测试功能结论|需修复（Critical）|可选优化（Suggestion）)$' "$change_dir/test-review.md" >/dev/null 2>&1; then
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
