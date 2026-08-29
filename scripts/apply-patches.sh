#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
device_root="$(dirname "$script_dir")"
source_root="${1:?usage: $0 TWRP_SOURCE_ROOT}"
bases_file="$device_root/patches/bases.conf"

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

[ -d "$source_root" ] || die "TWRP source root not found: $source_root"
[ -f "$bases_file" ] || die "patch base list not found: $bases_file"

# Validate every complete ordered series against an isolated temporary index
# before changing any source worktree.
while IFS='|' read -r project expected_head patch_dir; do
  case "$project" in ''|'#'*) continue ;; esac
  project_tree="$source_root/$project"
  patch_root="$device_root/$patch_dir"
  git -C "$project_tree" rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
    die "project checkout not found: $project_tree"
  [ -d "$patch_root" ] || die "patch directory not found: $patch_root"
  [ "$(git -C "$project_tree" rev-parse HEAD)" = "$expected_head" ] ||
    die "base revision mismatch: $project"
  [ -z "$(git -C "$project_tree" status --porcelain --untracked-files=all)" ] ||
    die "project worktree is not clean: $project"

  patch_index="$(mktemp)"
  trap 'unlink "$patch_index" 2>/dev/null || true' EXIT
  GIT_INDEX_FILE="$patch_index" git -C "$project_tree" read-tree HEAD
  for patch in "$patch_root"/*.patch; do
    [ -f "$patch" ] || die "empty patch directory: $patch_root"
    GIT_INDEX_FILE="$patch_index" git -C "$project_tree" apply --cached --check "$patch"
    GIT_INDEX_FILE="$patch_index" git -C "$project_tree" apply --cached "$patch"
  done
  unlink "$patch_index"
  trap - EXIT
done < "$bases_file"

while IFS='|' read -r project expected_head patch_dir; do
  case "$project" in ''|'#'*) continue ;; esac
  project_tree="$source_root/$project"
  for patch in "$device_root/$patch_dir"/*.patch; do
    git -C "$project_tree" apply "$patch"
    printf 'applied: %s -> %s\n' "$project" "$(basename "$patch")"
  done
done < "$bases_file"

echo "PAR TWRP source patches applied successfully."
