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
	
	// reg file signals
	wire [31:0] rf_dataIn;
	wire [4:0] RASel, RBSel, RegWSel;
	wire RegWEn;
	wire [31:0] RA,RB;
	
	// ALU signals
	wire [31:0] RS2;
	wire [31:0] ALUout;

	// imm handler signals
	wire [1:0]  imm_sel;
	wire [31:0] imm_out;
	
	// data memory signals
	wire dmem_wEn;
	wire [31:0] dmem_dataIn;
	wire [31:0] dmem_dataout;
	
	
	
	
	
////////////////////////// control signals/////////////////////////////////////////////////
	//ALU control
	wire [3:0]  ALUop;
	wire ALU_B_sel;
	
	// regfile controls
	wire dataInSel;
	
	// data mem controls
	wire [1:0] din_byte_sel;
	wire [2:0] dout_byte_sel;

	

/////////////////////// datapath connections //////////////////////////////////////////////


	assign instruciton_mem_addr = pc_out[9:2];
	
	assign dmem_dataIn = RB;
	mux2to1 mux_rs2 			(.sel(ALU_B_sel), .a(RB), .b(imm_out), .y(RS2));
	mux2to1 mux_rf_dataIn 	(.sel(dataInSel), .a(ALUout), .b(dmem_dataout), .y(rf_dataIn));
	
	
	
	
	// module instatiation
	
	regFile rf (.clk(clk), .RegWSel(RegWSel), .RegWEn(RegWEn), 
		.RASel(RASel), .RBSel(RBSel), .DataIn(rf_dataIn), .RA(RA), .RB(RB));
		
	ALU alu (.a(RA), .b(RS2), .sel(ALUop), .y(ALUout));
	
	imm_handler imm (.instruction(current_instruction[31:7]), .imm_sel(imm_sel), .SE_imm(imm_out));
	
	instruction_mem imem(.address(instruction_mem_addr), .instruction(current_instruction));
	
	data_mem dmem (.clk(clk), .write_enable(dmem_wEn), .byte_in_format_sel(din_byte_sel), 
					.byte_out_format_sel(dout_byte_sel), .address(ALUout[8:0]), .write_data(dmem_dataIn), .read_data(dmem_dataout));
	

endmodule








