#!/usr/bin/env bash

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Not inside a Git repository" >&2
  exit 1
}

project_name="$(basename "$repo_root")"
remote_url="$(git -C "$repo_root" config --get remote.origin.url 2>/dev/null || true)"

if [[ -n "$remote_url" ]]; then
  remote_name="${remote_url##*/}"
  remote_name="${remote_name##*:}"
  remote_name="${remote_name%.git}"

  if [[ -n "$remote_name" && "$remote_name" != "." && "$remote_name" != ".." ]]; then
    project_name="$remote_name"
  fi
fi

if [[ "$project_name" == *"/"* || "$project_name" == *$'\n'* || "$project_name" == *$'\r'* ]]; then
  echo "Unsafe project name derived from Git repository" >&2
  exit 1
fi

printf 'project=%s\n' "$project_name"
printf 'root=%s\n' "$repo_root"
