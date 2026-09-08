module imm_handler (
    input wire [24:0]instruction,
    // instruction is bits [31:7] of the instruction, containing the immediate information
    input wire [2:0] imm_sel,
    output reg [31:0] se_imm
);

    localparam TYPE_I = 3'b000, TYPE_S = 3'b001, TYPE_U = 3'b010, TYPE_B = 3'b011, TYPE_J = 3'b100;

    always @(*) begin

        case (imm_sel)
            TYPE_I: se_imm = {{20{instruction[24]}}, instruction[24:13]};
            TYPE_S: se_imm = {{20{instruction[24]}}, instruction[24:18], instruction[4:0]};
            TYPE_U: se_imm = {instruction[24:5], 12'b0};
            TYPE_B: se_imm = {{19{instruction[24]}}, instruction[24], instruction[0], instruction[23:18], instruction[4:1], 1'b0};
            TYPE_J: se_imm = {{11{instruction[24]}}, instruction[24], instruction[12:5], instruction[13], instruction[23:14], 1'b0};
            default: se_imm = 32'hxxxxxxxx;
        endcase
    end
endmodule
