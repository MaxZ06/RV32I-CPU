vlib work
vmap work work

vlog src/single_cycle_cpu_src/instruction_mem.v
vlog src/single_cycle_cpu_src/regFile.v
vlog src/single_cycle_cpu_src/ALU.v
vlog src/single_cycle_cpu_src/single_cycle_CPU.v
vlog tb/single_cycle_cpu_add_tb.v

vsim work.single_cycle_cpu_add_tb

add wave sim:/single_cycle_cpu_add_tb/clk
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/RASel
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/RBSel
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/RA
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/RB
add wave -radix binary sim:/single_cycle_cpu_add_tb/dut/ALUop
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/ALUout
add wave sim:/single_cycle_cpu_add_tb/dut/RegWEn
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/RegWSel
add wave -radix unsigned sim:/single_cycle_cpu_add_tb/dut/rf/rfReg(3)

run -all
wave zoom full
