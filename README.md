# Orca Slicer Profiles

My Orca Slicer printer, filament, and process profiles (CR-10 Smart Pro).

- `./sync.sh` copies the current profiles from Orca Slicer into `profiles/`. Then commit and push.
- `gcode/` has each profile's custom G-code (start, end, layer change) as readable `.gcode` files. G-code that's the same in every profile is saved once; if profiles differ, each gets its own file in a subfolder. These are created by `./sync.sh` for easy reading only, so edit G-code in Orca, not here.
- `./sync.sh restore` copies them back into Orca Slicer (close Orca first). Useful on a new computer.
