module ALU(
	input [31:0] a, 
	input [31:0] b, 
	input [3:0] sel,
	output reg [31:0] y);
	
	wire signed [31:0] signed_a = $signed(a);
	wire signed [31:0] signed_b = $signed(b);
	
	always@(*) begin
		case(sel)
			4'b0000 	: y = a + b;				// add
			4'b0001 	: y = a - b;				// sub
			4'b0010	: y = a & b;				// and
			4'b0011	: y = a | b;				// or
			4'b0100	: y = a ^ b;				// xor
			4'b0101  : y = a <<  b[4:0]; 		// sll for bottom 5 bits of b
			4'b0110  : y = a >>  b[4:0]; 		// srl for bottom 5 bits of b
			4'b0111  : y = signed_a >>> b[4:0];		// sra for bottom 5 bits of b
			4'b1000  : begin 
						  y[31:1] = 0;
						  y[0] = signed_a < signed_b; // slt
						  end
			4'b1001  : begin
						  y[31:1] = 0;
						  y[0] = a < b;					//sltu
						  end
		   default  : y = 4'bxxxx;
		endcase
	end

endmodule




















