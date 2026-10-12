M117 Printing Finished

G91 ; Set to Relative Positioning
G1 E-2 F2700 ; Quick retraction to break the melt
G1 E-4 Z0.2 F2400 ; Deep retraction (total 6mm) and tiny Z-hop
G1 X5 Y5 F3000 ; Small wipe move
G1 Z10 ; Raise Z 10mm for nozzle clearance
G90 ; Set back to Absolute Positioning

M117 Presenting Print
G1 X0 Y300 ; Move bed all the way forward (presenting)
M106 S0 ; Turn off part cooling fan
M104 S0 ; Turn off hotend
M140 S0 ; Turn off bed

M84 X Y E ; Disable X, Y, and E steppers (Keep Z locked to prevent sagging)
M225 ; Turn off LED light
M117 Print Complete.
