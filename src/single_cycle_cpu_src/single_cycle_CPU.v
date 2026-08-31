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

///////////////////////// signals //////////////////////////////////////////////////////////

	// pc signals
	wire [31:0] pc_next;
	wire [31:0] pc_out;
	wire [31:0] pc_add_4; // intermediate signal
	
	// declare the memory addresses
	wire [7:0] instruction_mem_addr;
	wire [31:0] current_instruction;  // imem out
	 
	// reg file signals
	wire [31:0] rf_dataIn;
	wire [4:0] RASel, RBSel, RegWSel;
	wire [31:0] RA,RB;
	
	// comparitor unit signals
	wire [31:0] lhs;
	wire [31:0] rhs;
	wire        comp_result;           // connects to control unit
	
	// ALU signals
	wire [31:0] ALU_port_A;
	wire [31:0] ALU_port_B;
	wire [31:0] ALUout;
	wire [31:0] comp_mux_result;

	// imm handler signals
	wire [2:0]  imm_sel;
	wire [31:0] imm_out;
	
	// data memory signals
	wire [31:0] dmem_dataIn;
	wire [31:0] dmem_dataout;
	wire [8:0] dmem_addr_sel;
	
	
	
////////////////////////// control signals/////////////////////////////////////////////////
	
	// pc control
	wire pc_sel;

	// comparitor control
	wire [2:0]  comp_sel;
	wire 		comp_B_sel;
	
	// ALU control
	wire [2:0]  ALUop;
	wire [1:0]  ALU_A_sel;
	wire [1:0]  ALU_B_sel;
	
	// regfile controls
	wire [1:0] dataInSel;
	wire RegWEn;
	
	// data mem controls
	wire [1:0] din_byte_sel;
	wire [2:0] dout_byte_sel;
	wire dmem_wEn;

	// data_path signals
	wire set_lsb_zero_en;
	wire [31:0] lsb_0;

/////////////////////// datapath connections //////////////////////////////////////////////

	

	assign instruction_mem_addr = pc_out[9:2];
	assign RASel = current_instruction[19:15];
	assign RBSel = current_instruction[24:20];
	assign RegWSel = current_instruction[11:7];
	assign dmem_addr_sel = ALUout[8:0];
	assign dmem_dataIn = RB;
	assign lhs = RA;


	set_lsb_zero slz            (.in(ALUout),      .enable(set_lsb_zero_en),         .out(lsb_0));
	pc_adder pc_a 				(.curr_pc(pc_out), .pc_next(pc_add_4));

	mux2to1 comp_slt            (.sel(comp_result), .a(32'b0),        .b(32'b1),         .y(comp_mux_result));
	mux2to1 comp_b_mux          (.sel(comp_B_sel),  .a(RB),           .b(imm_out),       .y(rhs));
	mux2to1 mux_pc_next 		(.sel(pc_sel),      .a(pc_add_4),     .b(lsb_0),         .y(pc_next));
	mux3to1 mux_ALUA 			(.sel(ALU_A_sel),   .a(RA), 	      .b(pc_out), 	     .c(32'd0),          
								 .y(ALU_port_A));
	mux3to1 mux_ALUB 			(.sel(ALU_B_sel),   .a(RB), 	      .b(imm_out), 		 .c(comp_mux_result),
				                 .y(ALU_port_B));
	mux4to1 mux_rf_dataIn 		(.sel(dataInSel),   .a(ALUout), 	  .b(dmem_dataout),  .c(pc_add_4),   
								 .d(imm_out),     .y(rf_dataIn));
	
	
	
	
/////////////////////////////// module instatiation /////////////////////////////////////


	control_unit cu (
		.comp_result    (comp_result),
		.instruction    (current_instruction),
		.pc_sel         (pc_sel),
		.RegWEn         (RegWEn),
		.dataInSel      (dataInSel),
		.ALUA_sel       (ALU_A_sel),
		.ALUB_sel       (ALU_B_sel),
		.ALUop          (ALUop),
		.comp_sel       (comp_sel),
		.imm_sel        (imm_sel),
		.set_lsb_zero_en(set_lsb_zero_en),
		.dmem_wEn       (dmem_wEn),
		.din_byte_sel   (din_byte_sel),
		.dout_byte_sel  (dout_byte_sel),
		.comp_B_sel     (comp_B_sel)
	);

	pc program_counter (.clk(clk), .reset(reset), .next_pc(pc_next), .out(pc_out));
	
	regFile rf (.clk(clk), .RegWSel(RegWSel), .RegWEn(RegWEn), 
		.RASel(RASel), .RBSel(RBSel), .DataIn(rf_dataIn), .RA(RA), .RB(RB));
		
	comparitor_unit comp_u (.lhs(lhs), .rhs(rhs), .comp_sel(comp_sel), .result(comp_result));
		
	ALU alu (.a(ALU_port_A), .b(ALU_port_B), .sel(ALUop), .y(ALUout));
	
	imm_handler imm (.instruction(current_instruction[31:7]), .imm_sel(imm_sel), .SE_imm(imm_out));
	
	instruction_mem imem(.address(instruction_mem_addr), .instruction(current_instruction));
	
	data_mem dmem (.clk(clk), .write_enable(dmem_wEn), .byte_in_format_sel(din_byte_sel), 
					.byte_out_format_sel(dout_byte_sel), .address(dmem_addr_sel), .write_data(dmem_dataIn), .read_data(dmem_dataout));
	

endmodule








