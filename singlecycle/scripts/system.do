onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/PC
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/RF/register
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group ram_if /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group datapath_if /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group pc_if /system_tb/DUT/CPU/DP/pcif/ihit
add wave -noupdate -group pc_if /system_tb/DUT/CPU/DP/pcif/dhit
add wave -noupdate -group pc_if /system_tb/DUT/CPU/DP/pcif/nextPC
add wave -noupdate -group pc_if /system_tb/DUT/CPU/DP/pcif/PC
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group register_file_if /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/ihit
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/dhit
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/dREN
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/dWEN
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/imemREN
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/dmemREN
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/dmemWEN
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/halt
add wave -noupdate -group request_unit_if /system_tb/DUT/CPU/DP/ruif/MemWr
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/output_port
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/negative
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/overflow
add wave -noupdate -group alu_if /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/RegWr
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/MemWr
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/Halt
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/imemREN
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/dmemWEN
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/dmemREN
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/RegDst
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/PCSrc
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/ExtOp
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/MemToReg
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/ALUOp
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/Equal
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/Instr
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/rs
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/rt
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/rd
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/funct
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/shamt
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/imm
add wave -noupdate -group control_unit_if /system_tb/DUT/CPU/DP/cuif/addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {353267 ps} 0}
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
WaveRestoreZoom {12 ns} {949 ns}
