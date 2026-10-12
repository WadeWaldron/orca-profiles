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
[[ "${1:-}" != "restore" ]] && git -C "$(dirname "$0")" status --short
