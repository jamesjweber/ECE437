onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/PROG/#ublk#502948#49/OP
add wave -noupdate /control_unit_tb/PROG/#ublk#502948#49/funct
add wave -noupdate /control_unit_tb/PROG/check/error
add wave -noupdate /control_unit_tb/PROG/cuif/RegWr
add wave -noupdate /control_unit_tb/PROG/check/eRegWr
add wave -noupdate /control_unit_tb/PROG/cuif/MemWr
add wave -noupdate /control_unit_tb/PROG/check/eMemWr
add wave -noupdate /control_unit_tb/PROG/cuif/imemREN
add wave -noupdate /control_unit_tb/PROG/check/eimemREN
add wave -noupdate /control_unit_tb/PROG/cuif/dmemWEN
add wave -noupdate /control_unit_tb/PROG/check/edmemWEN
add wave -noupdate /control_unit_tb/PROG/cuif/dmemREN
add wave -noupdate /control_unit_tb/PROG/check/edmemREN
add wave -noupdate /control_unit_tb/PROG/cuif/Halt
add wave -noupdate /control_unit_tb/PROG/check/eHalt
add wave -noupdate /control_unit_tb/PROG/cuif/RegDst
add wave -noupdate /control_unit_tb/PROG/check/eRegDst
add wave -noupdate /control_unit_tb/PROG/cuif/PCSrc
add wave -noupdate /control_unit_tb/PROG/check/ePCSrc
add wave -noupdate /control_unit_tb/PROG/cuif/ALUSrc
add wave -noupdate /control_unit_tb/PROG/check/eALUSrc
add wave -noupdate /control_unit_tb/PROG/cuif/ExtOp
add wave -noupdate /control_unit_tb/PROG/check/eExtOp
add wave -noupdate /control_unit_tb/PROG/cuif/MemToReg
add wave -noupdate /control_unit_tb/PROG/check/eMemToReg
add wave -noupdate /control_unit_tb/PROG/cuif/ALUOp
add wave -noupdate /control_unit_tb/PROG/check/eALUOp
add wave -noupdate /control_unit_tb/PROG/cuif/Equal
add wave -noupdate /control_unit_tb/PROG/cuif/Instr
add wave -noupdate /control_unit_tb/PROG/cuif/funct
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3920 ns} 0}
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
WaveRestoreZoom {3830 ns} {4525 ns}
