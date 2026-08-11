`timescale 1ns/1ps

module ALU_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  sel;
    wire [31:0] y;

    integer tests_run;
    integer errors;

    ALU dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );


    initial begin
	a = 32'b0011;
	b = 32'd2;
	sel = 4'b0101;
	
	#10;

	a = 32'b0111;
	b = 32'd1;
	sel = 4'b0110;

	#20;
	
	a = 32'd12;
	b = 32'd20;
	sel = 4'b0000;

	#10;
	
	$finish;
	
   end

endmodule
