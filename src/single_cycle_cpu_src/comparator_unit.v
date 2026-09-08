module comparator_unit (
    input wire [31:0] lhs, // rs1
    input wire [31:0] rhs, // rs2
    input wire [2:0] comp_sel,
    output reg result
);

    localparam EQ = 3'b000, LT = 3'b001, GE = 3'b010, LTU = 3'b011, GEU = 3'b100;

    wire signed [31:0] lhs_s;
    wire signed [31:0] rhs_s;

    assign lhs_s = $signed(lhs);
    assign rhs_s = $signed(rhs);

    always @(*) begin
        case (comp_sel)
            EQ: result = lhs == rhs;
            LT: result = lhs_s < rhs_s;
            GE: result = lhs_s >= rhs_s;
            LTU: result = lhs < rhs;
            GEU: result = lhs >= rhs;
            default: result = 1'bx;
        endcase
    end
endmodule
