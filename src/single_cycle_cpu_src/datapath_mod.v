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

module mux3to1(
	input  wire [1:0]  sel,
	input  wire [31:0] a,
	input  wire [31:0] b,
	input  wire [31:0] c,
	output reg  [31:0] y
);

	always@(*) begin
		case(sel)
			2'b00:   y = a;
			2'b01:   y = b;
			2'b10:   y = c;
			default: y = 32'hxxxxxxxx;
		endcase
	end
endmodule


module mux4to1(
	input  wire [1:0]  sel,
	input  wire [31:0] a,
	input  wire [31:0] b,
	input  wire [31:0] c,
	input  wire [31:0] d,
	output reg  [31:0] y
);

	always@(*) begin
		case(sel)
			2'b00:   y = a;
			2'b01:   y = b;
			2'b10:   y = c;
			2'b11:   y = d;
			default: y = 32'hxxxxxxxx;
		endcase
	end
endmodule


module set_lsb_zero (
	input  wire [31:0] in,
	input  wire        enable,
	output reg  [31:0] out
);
	always@(*) begin
		if (enable)
			out = {in[31:1], 1'b0};
		else 
			out = in;
	end
endmodule

	
module pc_adder(
	input  wire [31:0] curr_pc,
	output wire [31:0] pc_next
);

	assign pc_next = curr_pc + 4;

endmodule

