vlib work
vmap work work

vlog src/single_cycle_cpu_src/data_mem/data_mem.v
vlog src/single_cycle_cpu_src/data_mem/data_mem_wrapper.v
vlog tb/data_mem_tb.v

vsim -L altera_mf_ver work.data_mem_tb

add wave sim:/data_mem_tb/clk
add wave -radix decimal sim:/data_mem_tb/address
add wave -radix decimal sim:/data_mem_tb/write_data
add wave sim:/data_mem_tb/rden
add wave sim:/data_mem_tb/wren
add wave -radix decimal sim:/data_mem_tb/out_data

run -all
wave zoom full