`timescale 1ns/1ps

module regFile_tb;

    reg         clk;
    reg  [4:0]  RegWSel;
    reg         RegWEn;
    reg  [4:0]  RASel;
    reg  [4:0]  RBSel;
    reg  [31:0] DataIn;
    wire [31:0] RA;
    wire [31:0] RB;

    regFile dut (
        .clk(clk),
        .RegWSel(RegWSel),
        .RegWEn(RegWEn),
        .RASel(RASel),
        .RBSel(RBSel),
        .DataIn(DataIn),
        .RA(RA),
        .RB(RB)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        RegWSel = 5'd0;
        RegWEn = 1'b0;
        RASel = 5'd0;
        RBSel = 5'd0;
        DataIn = 32'd0;

        #10;

        RegWSel = 5'd1;
        DataIn = 32'd25;
        RegWEn = 1'b1;

        #10;

        RegWSel = 5'd2;
        DataIn = 32'd12;

        #10;

        RegWEn = 1'b0;
        RASel = 5'd1;
        RBSel = 5'd2;

        #10;

        RASel = 5'd0;
        RBSel = 5'd2;

        #10;

        DataIn = 32'd114;
        RegWSel = 5'd12;
        RegWEn = 1;

        RBSel = 5'd4;

        #1
        RASel = 5'd0;
        DataIn = 32'd255;

        #9
        RegWEn = 1'b1;
        RegWSel = 5'd4;

        #10
        RASel = 5'd12;

        #10

        $finish;

    end

endmodule
