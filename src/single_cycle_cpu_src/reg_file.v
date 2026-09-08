module reg_file (
    input wire clk,
    input wire [4:0] reg_write_sel,
    input wire reg_write_en,
    input wire [4:0] ra_sel,
    input wire [4:0] rb_sel,
    input wire [31:0] data_in,
    output wire [31:0] ra,
    output wire [31:0] rb
);

    // 32 general-purpose registers; values are undefined until written.
    reg [31:0] registers [31:0];

    // Write the selected register on a rising clock edge when enabled.
    always @(posedge clk) begin
        if (reg_write_en) begin
            registers[reg_write_sel] <= data_in;
        end
    end

    // Two asynchronous read ports select the source registers.
    // Reads of x0 always return zero.
    assign ra = (ra_sel != 5'b0) ? registers[ra_sel] : 32'b0;
    assign rb = (rb_sel != 5'b0) ? registers[rb_sel] : 32'b0;
endmodule
