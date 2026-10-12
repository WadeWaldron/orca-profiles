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
GCODE_DIR="$(dirname "$REPO_DIR")/gcode"
rm -rf "$GCODE_DIR"
for f in "$REPO_DIR"/*/*.json; do
  folder="$(basename "$(dirname "$f")")"
  profile="$(basename "$f" .json)"
  for key in $(jq -r 'to_entries[] | select((.key | endswith("gcode")) and .value != "") | .key' "$f"); do
    mkdir -p "$GCODE_DIR/$folder/$profile"
    jq -r --arg k "$key" '.[$k]' "$f" > "$GCODE_DIR/$folder/$profile/$key.gcode"
  done
done

git -C "$(dirname "$0")" status --short
