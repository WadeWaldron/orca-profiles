#!/bin/bash
# Copies Orca Slicer user profiles into this repo.
# Usage: ./sync.sh            Orca -> repo (backup)
#        ./sync.sh restore    repo -> Orca (close Orca first)
set -euo pipefail

ORCA_DIR="$HOME/Library/Application Support/OrcaSlicer/user/default"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)/profiles"

if [[ "${1:-}" == "restore" ]]; then
  src="$REPO_DIR"; dest="$ORCA_DIR"
else
  src="$ORCA_DIR"; dest="$REPO_DIR"
fi

for folder in machine filament process; do
  mkdir -p "$dest/$folder"
  rsync -a --delete "$src/$folder/" "$dest/$folder/"
done

echo "Copied profiles from $src to $dest"
[[ "${1:-}" == "restore" ]] && exit 0

# Save each G-code block as its own readable file (read-only copies; the JSON is what gets restored).
# If every profile in a folder has the same G-code for a field, it's saved once as gcode/<folder>/<field>.gcode.
# If they differ, each profile gets its own copy in gcode/<folder>/<field>/<profile>.gcode.
GCODE_DIR="$(dirname "$REPO_DIR")/gcode"
rm -rf "$GCODE_DIR"
for folder in machine filament process; do
  files=("$REPO_DIR/$folder"/*.json)
  [[ -e "${files[0]}" ]] || continue
  keys=$(jq -r 'to_entries[] | select((.key | endswith("gcode")) and .value != "") | .key' "${files[@]}" | sort -u)
  for key in $keys; do
    versions=$(for f in "${files[@]}"; do jq -r --arg k "$key" '.[$k] // empty' "$f" | shasum; done | grep -v "^$(printf '' | shasum)" | sort -u | wc -l)
    for f in "${files[@]}"; do
      [[ -n "$(jq -r --arg k "$key" '.[$k] // empty' "$f")" ]] || continue
      if (( versions == 1 )); then
        out="$GCODE_DIR/$folder/$key.gcode"
      else
        out="$GCODE_DIR/$folder/$key/$(basename "$f" .json).gcode"
      fi
      mkdir -p "$(dirname "$out")"
      jq -r --arg k "$key" '.[$k]' "$f" > "$out"
    done
  done
done

git -C "$(dirname "$0")" status --short
