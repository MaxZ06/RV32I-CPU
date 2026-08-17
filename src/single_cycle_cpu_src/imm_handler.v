module imm_handler(
	input wire [24:0]instruction,
	// instruction is bits [31:7] of the instruction, containing the immediate information
	input wire [1:0] imm_sel,
	output reg [31:0] SE_imm
	);
	
	localparam TYPE_I = 2'b00, TYPE_S = 2'b01, TYPE_U = 2'b10;
	
	always@(*) begin
	
		case(imm_sel)
			TYPE_I: SE_imm = {{20{instruction[24]}}, instruction[24:13]};
			TYPE_S: SE_imm = {{20{instruction[24]}}, instruction[24:18], instruction[4:0]};
			TYPE_U: SE_imm = {instruction[24:5], 12'b0};
			default: SE_imm = 32'hxxxxxxxx;
		endcase
	end
	
endmodule
			
