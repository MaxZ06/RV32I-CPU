vlib work
vmap work work

vlog src/single_cycle_cpu_src/ALU.v
vlog tb/ALU_tb.v

vsim ALU_tb

add wave *

run -all

wave zoom full