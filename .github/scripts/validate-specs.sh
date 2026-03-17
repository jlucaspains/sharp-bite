#!/usr/bin/env bash
# Validate YAML frontmatter in SharpBite spec files.
# Usage: validate-specs.sh <file> [file ...]
# Required env: GITHUB_TOKEN

set -euo pipefail

REQUIRED_FIELDS=("title" "status" "version" "work-item-url")
VALID_STATUSES=("draft" "approved" "implemented")
GITHUB_ISSUE_URL_RE='^https://github\.com/([^/]+)/([^/]+)/issues/([0-9]+)$'

failed=0

# Extract a scalar value from flat YAML frontmatter
fm_get() {
  local file="$1" field="$2"
  # Match "field: value" or 'field: "value"' inside the frontmatter block
  sed -n '/^---$/,/^---$/p' "$file" \
    | grep -m1 "^${field}:" \
    | sed "s/^${field}:[[:space:]]*//" \
    | tr -d '"'"'"
}

# Return 0 if the frontmatter block (---...---) is present
has_frontmatter() {
  local file="$1"
  head -1 "$file" | grep -q '^---$'
}

issue_exists() {
  local url="$1"
  local http_status
  http_status=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$url")
  [[ "$http_status" == "200" ]]
}

validate_file() {
  local file="$1"
  local file_failed=0

  if [[ ! -f "$file" ]]; then
    echo "::warning file=${file}::File not found, skipping."
    return
  fi

  if ! has_frontmatter "$file"; then
    echo "::error file=${file}::Missing YAML frontmatter — file must start with ---"
    failed=1
    return
  fi

  for field in "${REQUIRED_FIELDS[@]}"; do
    local value
    value=$(fm_get "$file" "$field")
    if [[ -z "$value" ]]; then
      echo "::error file=${file}::Missing required field: '${field}'"
      file_failed=1
    fi
  done

  local status
  status=$(fm_get "$file" "status")
  if [[ -n "$status" ]]; then
    local valid=0
    for s in "${VALID_STATUSES[@]}"; do
      [[ "$status" == "$s" ]] && valid=1 && break
    done
    if [[ $valid -eq 0 ]]; then
      echo "::error file=${file}::Invalid status '${status}'. Must be one of: ${VALID_STATUSES[*]}"
      file_failed=1
    fi
  fi

  local work_item_url
  work_item_url=$(fm_get "$file" "work-item-url")
  if [[ -n "$work_item_url" ]]; then
    if [[ ! "$work_item_url" =~ $GITHUB_ISSUE_URL_RE ]]; then
      echo "::error file=${file}::'work-item-url' must be a valid GitHub issue URL (e.g. https://github.com/owner/repo/issues/123), got: ${work_item_url}"
      file_failed=1
    elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
      local api_url="https://api.github.com/repos/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/issues/${BASH_REMATCH[3]}"
      if ! issue_exists "$api_url"; then
        echo "::error file=${file}::Referenced issue does not exist: ${work_item_url}"
        file_failed=1
      fi
    fi
  fi

  if [[ $file_failed -eq 0 ]]; then
    echo "✅  ${file}: OK"
  else
    failed=1
  fi
}

if [[ $# -eq 0 ]]; then
  echo "No spec files to validate."
  exit 0
fi

for spec in "$@"; do
  validate_file "$spec"
done

exit $failed
