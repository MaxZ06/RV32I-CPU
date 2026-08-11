`timescale 1ns/1ps

module pc_tb;
    reg pc_load;
    reg clk;
    reg is_jump;
    reg [31:0] jump_offset;
    reg reset;
    wire [31:0] curr_pc;

    pc dut (
        .pc_load(pc_load),
        .clk(clk),
        .is_jump(is_jump),
        .jump_offset(jump_offset),
        .reset(reset),
        .curr_pc(curr_pc)
    );

    always #20 clk = ~ clk;
    
    initial begin
    clk = 0;
    is_jump = 0;
    pc_load = 0;

    #20
    pc_load = 1;
    #20
    pc_load = 0;
    
    #10
    jump_offset = 32'd12;
    is_jump = 1;
    #10
    pc_load = 1;
    #20
    pc_load = 0;

    #20
    reset = 1;
    #20
    reset = 0;
    pc_load = 1;
    is_jump = 1;
    #40
    pc_load = 0;




    #20 
    $finish;
    end

endmodule
