`timescale 1ns/1ps

module instruction_memory_tb;

    reg         clk;
    reg  [31:0] pc;
    wire [31:0] instruction;

    integer cycle;
    integer errors;

    instruction_memory_wrapper dut (
        .clk         (clk),
        .pc          (pc),
        .instruction (instruction)
    );


    always #20 clk = ~clk;


    initial begin

        pc = 32'd4;
        clk = 1'b0;

        # 220
        pc = 32'd12;

        #200
        pc = 32'd24;
	    #200;
	
	    $finish;
    end
endmodule



