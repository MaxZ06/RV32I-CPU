vlib work
vmap work work

vlog src/single_cycle_cpu_src/instruction_mem/instruction_ram.v
vlog src/single_cycle_cpu_src/instruction_mem/instruction_memory_wrapper.v
vlog tb/instruction_memory_tb.v

vsim -L altera_mf_ver work.instruction_memory_tb

add wave -radix decimal sim:/instruction_memory_tb/pc
add wave sim:/instruction_memory_tb/clk
add wave -radix decimal sim:/instruction_memory_tb/instruction

run -all
wave zoom full