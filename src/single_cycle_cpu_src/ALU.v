module ALU(
	input [31:0] a, 
	input [31:0] b, 
	input [2:0] sel,
	output reg [31:0] y);

	localparam ADD = 3'b000,
	           SUB = 3'b001,
	           AND = 3'b010,
	           OR  = 3'b011,
	           XOR = 3'b100,
	           SLL = 3'b101,
	           SRL = 3'b110,
	           SRA = 3'b111;
	
	wire signed [31:0] signed_a = $signed(a);
	wire signed [31:0] signed_b = $signed(b);
	
	always@(*) begin
		case(sel)
			ADD: y = a + b;					// add
			SUB: y = a - b;					// sub
			AND: y = a & b;					// and
			OR:  y = a | b;					// or
			XOR: y = a ^ b;					// xor
			SLL: y = a << b[4:0];			// sll for bottom 5 bits of b
			SRL: y = a >> b[4:0];			// srl for bottom 5 bits of b
			SRA: y = signed_a >>> b[4:0];	// sra for bottom 5 bits of b
			default: y = 32'hxxxxxxxx;
		endcase
	end

endmodule




















