`timescale 1ns/1ps

module pc_tb;
    reg pc_load;
    reg clk;
    wire [31:0] curr_pc;

    pc dut (
        .pc_load(pc_load),
        .clk(clk),
        .curr_pc(curr_pc)
    );

    always #20 clk = ~ clk;
    
    initial begin
    clk = 0;
    pc_load = 0;

    #30 
    pc_load = 1;
    #5 
    pc_load = 0;

    #30 
    pc_load = 1;
    #5 
    pc_load = 0;

    #30 
    pc_load = 1;
    #5 
    pc_load = 0;


    #20 
    $finish;
    end

endmodule
