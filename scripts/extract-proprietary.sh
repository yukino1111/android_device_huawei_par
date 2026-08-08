#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
device_root="$(dirname "$script_dir")"
firmware_root="${1:?usage: $0 EXTRACTED_EMUI_ROOT}"
list_file="$device_root/proprietary-files.txt"

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

[ -d "$firmware_root" ] || die "firmware root not found: $firmware_root"
[ -f "$list_file" ] || die "proprietary file list not found: $list_file"

while IFS=: read -r source_path destination; do
  case "$source_path" in
    ''|'#'*) continue ;;
  esac
  source_file="$firmware_root/$source_path"
  destination_file="$device_root/$destination"
  [ -f "$source_file" ] || die "missing firmware file: $source_file"
  install -Dm0755 "$source_file" "$destination_file"
  printf 'extracted: %s\n' "$destination"
done < "$list_file"

echo "Huawei recovery files extracted successfully."
