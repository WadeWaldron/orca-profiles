M117 Warming Up
M224 ; Turn on LED light

; --- Machine Limits & Motion Settings ---
M201 X500 Y500 Z100 E5000 ; Set Maximum Acceleration (mm/s^2)
M203 X500 Y500 Z10 E50    ; Set Maximum Feedrate (mm/s)
M204 P500 R1000 T500      ; Set Printing (P), Retract (R), and Travel (T) acceleration
M205 X8 Y8 Z0.4 E5        ; Set Jerk (Advanced Move Settings)
M220 S100                 ; Reset Feedrate percentage to 100%
M221 S100                 ; Reset Flowrate percentage to 100%
M18 S0                    ; Disable stepper timeout (keeps motors engaged)

; --- Stage 1: Safe Heat (Prevents Oozing) ---
M140 S[bed_temperature_initial_layer_0] ; Start heating bed
M104 S160 ; Heat nozzle to 160C (Softens plastic but prevents drips)
M190 S[bed_temperature_initial_layer_0] ; Wait for bed to reach target

; --- Stage 2: Homing & Mesh ---
G28 ; Home all axes
; G29 ; <--- REMOVE the semicolon at the start of this line to run Auto-Leveling
M420 S1 ; Load the saved mesh from your last leveling session

; --- Stage 3: Final Heat  ---
G1 X5 Y5 Z10 F5000 ; Move to front corner, stay 10mm above bed
M117 Final Heating...
M109 S[nozzle_temperature_initial_layer] ; Heat nozzle to print temp

G1 Z0.28 F3000 ; Lower nozzle to bed height
M117 Printing

