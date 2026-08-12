module regFile(
	input wire 			  clk,
	input wire [4:0]    RegWSel,
	input wire          RegWEn,
	input wire [4:0]    RASel,
	input wire [4:0]    RBSel,
	input wire [31:0]   DataIn,
	output wire [31:0]  RA,
	output wire [31:0]  RB
	);
	
	// instantiate 32 regs in regfile
	reg [31:0] rfReg [31:0];
	
	
	// update on posedge only if regWen is high
	always@(posedge clk) begin
		
		if (RegWEn) begin
			rfReg[RegWSel] <= DataIn;
		end
		
	end
		
		
	// connect reg output to a mux to be selected by RA/RB Sel
	// register x0 is hardcoded to be 0
	assign RA = (RASel != 5'b0) ? rfReg[RASel] : 32'b0;
	assign RB = (RBSel != 5'b0) ? rfReg[RBSel] : 32'b0;
		
		
endmodule


