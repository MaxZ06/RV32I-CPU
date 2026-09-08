module control_unit (
    input wire comp_result,
    input wire [31:0] instruction,
    output reg pc_sel,
    output reg reg_write_en,
    output reg [1:0] data_in_sel, alu_a_sel, alu_b_sel,
    output reg [2:0] alu_op, comp_sel, imm_sel,
    output reg set_lsb_zero_en,
    output reg dmem_write_en,
    output reg [1:0] din_byte_sel,
    output reg [2:0] dout_byte_sel,
    output reg comp_b_sel
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    localparam R_TYPE_ALU = 7'b0110011,
        I_TYPE_ALU = 7'b0010011,
        I_TYPE_LOAD = 7'b0000011,
        I_TYPE_JALR = 7'b1100111,
        S_TYPE_STORE = 7'b0100011,
        B_TYPE_BRANCH = 7'b1100011,
        U_TYPE_LUI = 7'b0110111,
        U_TYPE_AUIPC = 7'b0010111,
        J_TYPE_JAL = 7'b1101111,
        MEMORY_FENCE = 7'b0001111;

    always @(*) begin
        // Default controls advance the PC without register or memory writes.
        pc_sel = 1'b0;
        reg_write_en = 1'b0;
        data_in_sel = 2'b00;
        alu_a_sel = 2'b00;
        alu_b_sel = 2'b00;
        alu_op = 3'b000;
        comp_sel = 3'b000;
        imm_sel = 3'b000;
        set_lsb_zero_en = 1'b0;
        dmem_write_en = 1'b0;
        din_byte_sel = 2'b00;
        dout_byte_sel = 3'b000;
        comp_b_sel = 1'b0;

        // Instruction decoding

        case (opcode)

            // Register arithmetic and logic
            R_TYPE_ALU: begin
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: begin // ADD
                                alu_op = 3'b000;
                                reg_write_en = 1'b1;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b00;
                                data_in_sel = 2'b00;
                            end
                            7'b0100000: begin // SUB
                                alu_op = 3'b001;
                                reg_write_en = 1'b1;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b00;
                                data_in_sel = 2'b00;
                            end
                            default: begin end // Keep default controls for unsupported encodings.
                        endcase
                    end

                    3'b001: begin // SLL
                        alu_op = 3'b101;
                        reg_write_en = 1'b1;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b00;
                        data_in_sel = 2'b00;
                    end
                    3'b010: begin // SLT
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                        alu_a_sel = 2'b10;
                        alu_b_sel = 2'b10;
                        alu_op = 3'b000;
                        comp_sel = 3'b001;
                        comp_b_sel = 1'b0;
                    end
                    3'b011: begin // SLTU
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                        alu_a_sel = 2'b10;
                        alu_b_sel = 2'b10;
                        alu_op = 3'b000;
                        comp_sel = 3'b011;
                        comp_b_sel = 1'b0;
                    end
                    3'b100: begin // XOR
                        alu_op = 3'b100;
                        reg_write_en = 1'b1;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b00;
                        data_in_sel = 2'b00;
                    end
                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin // SRL
                                alu_op = 3'b110;
                                reg_write_en = 1'b1;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b00;
                                data_in_sel = 2'b00;
                            end
                            7'b0100000: begin // SRA
                                alu_op = 3'b111;
                                reg_write_en = 1'b1;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b00;
                                data_in_sel = 2'b00;
                            end
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b110: begin // OR
                        alu_op = 3'b011;
                        reg_write_en = 1'b1;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b00;
                        data_in_sel = 2'b00;
                    end
                    3'b111: begin // AND
                        alu_op = 3'b010;
                        reg_write_en = 1'b1;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b00;
                        data_in_sel = 2'b00;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_ALU: begin
                case (funct3)
                    3'b000: begin // ADDI
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                    end
                    3'b001: begin
                        case (funct7)
                            7'b0000000: begin // SLLI
                                imm_sel = 3'b000;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b01;
                                alu_op = 3'b101;
                                reg_write_en = 1'b1;
                                data_in_sel = 2'b00;
                            end
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b010: begin // SLTI
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                        alu_a_sel = 2'b10;
                        alu_b_sel = 2'b10;
                        alu_op = 3'b000;
                        comp_sel = 3'b001;
                        comp_b_sel = 1'b1;
                        imm_sel = 3'b000;
                    end
                    3'b011: begin // SLTIU
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                        alu_a_sel = 2'b10;
                        alu_b_sel = 2'b10;
                        alu_op = 3'b000;
                        comp_sel = 3'b011;
                        comp_b_sel = 1'b1;
                        imm_sel = 3'b000;
                    end
                    3'b100: begin // XORI
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b100;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                    end
                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin // SRLI
                                imm_sel = 3'b000;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b01;
                                alu_op = 3'b110;
                                reg_write_en = 1'b1;
                                data_in_sel = 2'b00;
                            end
                            7'b0100000: begin // SRAI
                                imm_sel = 3'b000;
                                alu_a_sel = 2'b00;
                                alu_b_sel = 2'b01;
                                alu_op = 3'b111;
                                reg_write_en = 1'b1;
                                data_in_sel = 2'b00;
                            end
                            default: begin end // Reserved/unsupported
                        endcase
                    end
                    3'b110: begin // ORI
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b011;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                    end
                    3'b111: begin // ANDI
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b010;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b00;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_LOAD: begin
                case (funct3)
                    3'b000: begin // LB
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b01;
                        dmem_write_en = 1'b0;
                        dout_byte_sel = 3'b010;
                    end
                    3'b001: begin // LH
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b01;
                        dmem_write_en = 1'b0;
                        dout_byte_sel = 3'b001;
                    end
                    3'b010: begin // LW
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b01;
                        dmem_write_en = 1'b0;
                        dout_byte_sel = 3'b000;
                    end
                    3'b100: begin // LBU
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b01;
                        dmem_write_en = 1'b0;
                        dout_byte_sel = 3'b100;
                    end
                    3'b101: begin // LHU
                        imm_sel = 3'b000;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b01;
                        dmem_write_en = 1'b0;
                        dout_byte_sel = 3'b011;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            I_TYPE_JALR: begin
                case (funct3)
                    3'b000: begin // JALR
                        pc_sel = 1'b1;
                        reg_write_en = 1'b1;
                        data_in_sel = 2'b10;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        imm_sel = 3'b000;
                        set_lsb_zero_en = 1'b1;
                        dmem_write_en = 1'b0;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            S_TYPE_STORE: begin
                case (funct3)
                    3'b000: begin // SB
                        imm_sel = 3'b001;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b0;
                        dmem_write_en = 1'b1;
                        din_byte_sel = 2'b10;
                    end
                    3'b001: begin // SH
                        imm_sel = 3'b001;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b0;
                        dmem_write_en = 1'b1;
                        din_byte_sel = 2'b01;
                    end
                    3'b010: begin // SW
                        imm_sel = 3'b001;
                        alu_a_sel = 2'b00;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        reg_write_en = 1'b0;
                        dmem_write_en = 1'b1;
                        din_byte_sel = 2'b00;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            B_TYPE_BRANCH: begin
                case (funct3)
                    3'b000: begin // BEQ
                        pc_sel = comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b000;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    3'b001: begin // BNE
                        pc_sel = ~comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b000;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    3'b100: begin // BLT
                        pc_sel = comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b001;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    3'b101: begin // BGE
                        pc_sel = comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b010;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    3'b110: begin // BLTU
                        pc_sel = comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b011;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    3'b111: begin // BGEU
                        pc_sel = comp_result;
                        reg_write_en = 1'b0;
                        alu_a_sel = 2'b01;
                        alu_b_sel = 2'b01;
                        alu_op = 3'b000;
                        comp_sel = 3'b100;
                        imm_sel = 3'b011;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    default: begin end // Reserved/unsupported
                endcase
            end

            U_TYPE_LUI: begin // LUI
                reg_write_en = 1'b1;
                data_in_sel = 2'b11;
                imm_sel = 3'b010;
            end
            U_TYPE_AUIPC: begin // AUIPC
                reg_write_en = 1'b1;
                data_in_sel = 2'b00;
                alu_a_sel = 2'b01;
                alu_b_sel = 2'b01;
                alu_op = 3'b000;
                imm_sel = 3'b010;
            end
            J_TYPE_JAL: begin // JAL
                pc_sel = 1'b1;
                reg_write_en = 1'b1;
                data_in_sel = 2'b10;
                alu_a_sel = 2'b01;
                alu_b_sel = 2'b01;
                alu_op = 3'b000;
                imm_sel = 3'b100;
                set_lsb_zero_en = 1'b0;
                dmem_write_en = 1'b0;
            end
            MEMORY_FENCE: begin
                case (funct3)
                    // FENCE: fm[31:28], pred[27:24], succ[23:20],
                    // rs1=x0, funct3=000, rd=x0, opcode=0001111.
                    // This single-cycle core completes memory accesses in order,
                    // so FENCE requires no datapath action and advances PC by 4.
                    3'b000: begin
                        pc_sel = 1'b0;
                        reg_write_en = 1'b0;
                        set_lsb_zero_en = 1'b0;
                        dmem_write_en = 1'b0;
                    end
                    default: begin end // Reserved or unsupported MISC-MEM instruction
                endcase
            end
            default: begin end // Reserved or currently unsupported opcode
        endcase
    end
endmodule
