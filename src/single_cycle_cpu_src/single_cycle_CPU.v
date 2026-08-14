/*	top level file for the single cycle CPU
*  connects the modules together
*
*
*
*
*/



module single_cycle_CPU(
	input wire clk,
	input wire reset
	
	);
	
	// declare PC parameters
	wire [31:0] pc_out;
	
	// declare the memory addresses
	wire [7:0] instruction_mem_addr;
	
	// instruction
	wire [31:0] current_instruction;
	
	// reg file controls
	wire [4:0] RASel, RBSel, RegWSel;
	wire RegWEn;
	wire [31:0] RA,RB;
	
	// ALU control signals
	wire [3:0]  ALUop;
	
	wire [31:0] ALUout;

	
	assign instruciton_mem_addr = pc_out[9:2];
	



	instruction_mem imem(.address(instruction_mem_addr), .instruction(current_instruction));
	
	regFile rf (.clk(clk), .RegWSel(RegWSel), .RegWEn(RegWEn), 
		.RASel(RASel), .RBSel(RBSel), .DataIn(ALUout), .RA(RA), .RB(RB));
		
	ALU alu (.a(RA), .b(RB), .sel(ALUop), .y(ALUout));
	
	

endmodule








