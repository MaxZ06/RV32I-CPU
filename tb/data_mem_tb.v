`timescale 1ns/1ps

module data_mem_tb;

    reg         clk;
    reg  [31:0] address;
    reg  [31:0] write_data;
    reg  [3:0] byte_enable;
    reg        rden;
    reg        wren;
    wire [31:0] out_data;

    data_mem_wrapper dut (
        .clk         (clk),
        .address     (address),
        .write_data  (write_data),
        .byte_enable (byte_enable),
        .read_enable  (rden),
        .write_enable (wren),
        .read_data    (out_data)
    );

    always #10 clk = ~clk;


    initial begin
    // try reading some data
    clk = 0;
    rden = 0;
    wren = 0;
    byte_enable = 4'b1111;

    # 10
    // read mode, read from address 4
    rden = 1;
    address = 32'd4;

    #30
    wren = 1;
    rden = 0;
    write_data = 32'hffffffff;
    #10
    // 10 away from second posedge
    // try writing to address 8
    address = 32'd8;

    #10
    rden = 1;
    wren = 0;

    #20

    rden = 1;
    #20
	    $finish;
    end
endmodule



