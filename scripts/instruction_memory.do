vlib work
vmap work work

vlog src/single_cycle_cpu_src/instruction_mem.v
vlog tb/instruction_memory_tb.v

vsim work.instruction_memory_tb

add wave -radix unsigned sim:/instruction_memory_tb/address
add wave -radix hexadecimal sim:/instruction_memory_tb/instruction

run -all
wave zoom full
