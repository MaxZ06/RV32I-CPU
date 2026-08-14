vlib work
vmap work work

vlog src/single_cycle_cpu_src/pc.v
vlog tb/pc_tb.v

vsim work.pc_tb

add wave sim:/pc_tb/clk
add wave sim:/pc_tb/reset
add wave -radix hexadecimal sim:/pc_tb/next_pc
add wave -radix hexadecimal sim:/pc_tb/out

run -all
wave zoom full
