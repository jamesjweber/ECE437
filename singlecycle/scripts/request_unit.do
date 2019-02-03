onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /request_unit_tb/CLK
add wave -noupdate /request_unit_tb/nRST
add wave -noupdate /request_unit_tb/PROG/check/error
add wave -noupdate /request_unit_tb/PROG/ruif/dmemREN
add wave -noupdate /request_unit_tb/PROG/check/edmemREN
add wave -noupdate /request_unit_tb/PROG/ruif/dmemWEN
add wave -noupdate /request_unit_tb/PROG/check/edmemWEN
add wave -noupdate /request_unit_tb/PROG/ruif/ihit
add wave -noupdate /request_unit_tb/PROG/ruif/dhit
add wave -noupdate /request_unit_tb/PROG/ruif/dREN
add wave -noupdate /request_unit_tb/PROG/ruif/dWEN
add wave -noupdate /request_unit_tb/PROG/ruif/halt
add wave -noupdate /request_unit_tb/PROG/ruif/MemWr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {127 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
