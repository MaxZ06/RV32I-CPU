vlib work
vmap work work

vlog src/single_cycle_cpu_src/regFile.v
vlog tb/regFile_tb.v

vsim regFile_tb

add wave *

run -all

wave zoom full
