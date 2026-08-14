vlib work
vmap work work

vlog src/single_cycle_cpu_src/data_mem.v
vlog tb/data_mem_tb.v

vsim work.data_mem_tb

add wave sim:/data_mem_tb/clk
add wave sim:/data_mem_tb/write_enable
add wave -radix unsigned sim:/data_mem_tb/address
add wave -radix hexadecimal sim:/data_mem_tb/write_data
add wave -radix hexadecimal sim:/data_mem_tb/read_data

run -all
wave zoom full
