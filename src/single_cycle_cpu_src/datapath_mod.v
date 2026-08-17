module mux2to1(
	input wire         sel,
	input wire  [31:0] a,
	input wire  [31:0] b,
	output reg [31:0] y
	);
	
	always@(*) begin
		if (sel == 0)
			y = a;
		else
			y = b;
	end
	
endmodule

	
