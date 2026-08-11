vlib work
vmap work work

vlog src/single_cycle_cpu_src/pc.v
vlog tb/pc_tb.v

vsim pc_tb

add wave sim:/pc_tb/clk
add wave sim:/pc_tb/pc_load
add wave -radix decimal sim:/pc_tb/curr_pc
add wave sim:/pc_tb/is_jump
add wave -radix decimal sim:/pc_tb/jump_offset
add wave sim:/pc_tb/reset


run -all

wave zoom full