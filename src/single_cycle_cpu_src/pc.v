module pc (
    input wire clk,
    input wire reset,
    input wire [31:0] next_pc,
    output reg [31:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'd0;
        end
        else begin
            out <= next_pc;
        end
    end
endmodule
