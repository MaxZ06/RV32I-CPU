module control_unit(
    input wire  comp_result, 
	 input wire  [31:0] instruction,
    output reg  pc_sel, 
	 output reg  RegWEn,
    output reg  [1:0] dataInSel, ALUA_sel, ALUB_sel,
    output reg  [2:0] ALUop, comp_sel, imm_sel,
    output reg  set_lsb_zero_en, 
	 output reg  dmem_wEn,
    output reg  [1:0] din_byte_sel,
	 output reg  [2:0] dout_byte_sel
    );

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    localparam R_TYPE_ALU    = 7'b0110011,
               I_TYPE_ALU    = 7'b0010011,
               I_TYPE_LOAD   = 7'b0000011,
               I_TYPE_JALR   = 7'b1100111,
               S_TYPE_STORE  = 7'b0100011,
               B_TYPE_BRANCH = 7'b1100011,
               U_TYPE_LUI    = 7'b0110111,
               U_TYPE_AUIPC  = 7'b0010111,
               J_TYPE_JAL    = 7'b1101111;

    // Decode only. The empty blocks intentionally do not implement controls;
    // each comment identifies the RV32I instruction for that encoding.
    always @(*) begin
	 // defaults:
	 pc_sel          = 0;
	 RegWEn          = 0;
    dataInSel       = 0;
	 ALUA_sel        = 0;
	 ALUB_sel        = 0;
	 ALUop 			  = 0;
	 comp_sel		  = 0;
	 imm_sel         = 0;
    set_lsb_zero_en = 0;
	 dmem_wEn 		  = 0;
    din_byte_sel 	  = 0;
	 dout_byte_sel	  = 0;
	 
	 
        case (opcode)
            R_TYPE_ALU: begin
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: begin // add
										ALUop  = 3'b000;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end // ADD
                            7'b0100000: begin // sub
										ALUop  = 3'b001;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end // ADD
                            default: begin end // do nothing
                        endcase
                    end
						  
                    3'b001: begin // sll
										ALUop  = 3'b101;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                    3'b010: begin // slt
										
									end 
                    3'b011: begin end // SLTU
                    3'b100: begin // xor
										ALUop  = 3'b100;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin // srl
										ALUop  = 3'b110;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                            7'b0100000: begin // sra
										ALUop  = 3'b111;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b110: begin // or
										ALUop  = 3'b011;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                    3'b111: begin // and
										ALUop  = 3'b010;
										RegWEn = 1'b1;
										ALUA_sel = 2'b00;
										ALUB_sel = 2'b00;
										dataInSel = 2'b00;
									end 
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_ALU: begin
                case (funct3)
                    3'b000: begin // addi
								imm_sel = 2'b00;
								ALUA_sel = 2'b00;
								ALUB_sel = 2'b01;
								ALUop = 3'b000;
								RegWEn = 1;
								dataInSel = 2'b00;
								end
                    3'b001: begin
                        case (funct7)
                            7'b0000000: begin end // SLLI
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b010: begin end // SLTI
                    3'b011: begin end // SLTIU
                    3'b100: begin // xori
								imm_sel = 2'b00;
								ALUA_sel = 2'b00;
								ALUB_sel = 2'b01;
								ALUop = 3'b100;
								RegWEn = 1;
								dataInSel = 2'b00;
								end
                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin end // SRLI
                            7'b0100000: begin end // SRAI
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b110: begin // ori
								imm_sel = 2'b00;
								ALUA_sel = 2'b00;
								ALUB_sel = 2'b01;
								ALUop = 3'b011;
								RegWEn = 1;
								dataInSel = 2'b00;
								end
                    3'b111: begin // andi
								imm_sel = 2'b00;
								ALUA_sel = 2'b00;
								ALUB_sel = 2'b01;
								ALUop = 3'b010;
								RegWEn = 1;
								dataInSel = 2'b00;
								end
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_LOAD: begin
                case (funct3)
                    3'b000: begin end // LB
                    3'b001: begin end // LH
                    3'b010: begin end // LW
                    3'b100: begin end // LBU
                    3'b101: begin end // LHU
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_JALR: begin
                case (funct3)
                    3'b000: begin end // JALR
                    default: begin end // Reserved/unsupported
                endcase
            end

            S_TYPE_STORE: begin
                case (funct3)
                    3'b000: begin end // SB
                    3'b001: begin end // SH
                    3'b010: begin end // SW
                    default: begin end // Reserved/unsupported
                endcase
            end

            B_TYPE_BRANCH: begin
                case (funct3)
                    3'b000: begin end // BEQ
                    3'b001: begin end // BNE
                    3'b100: begin end // BLT
                    3'b101: begin end // BGE
                    3'b110: begin end // BLTU
                    3'b111: begin end // BGEU
                    default: begin end // Reserved/unsupported
                endcase
            end

            U_TYPE_LUI: begin end   // LUI
            U_TYPE_AUIPC: begin end // AUIPC
            J_TYPE_JAL: begin end   // JAL
            default: begin end // Reserved or currently unsupported opcode
        endcase
    end
endmodule
