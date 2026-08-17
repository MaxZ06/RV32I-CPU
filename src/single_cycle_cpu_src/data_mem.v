module data_mem (
    input  wire        clk,
    input  wire        write_enable,
    input  wire [1:0]  byte_in_format_sel,
    input  wire [2:0]  byte_out_format_sel,
    input  wire [8:0]  address,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

localparam SW = 2'd0, SH = 2'd1, SB = 2'd2;
localparam LW = 3'd0, LH = 3'd1, LB = 3'd2, LHU = 3'd3, LBU = 3'd4;

    // 512 words, 32 bits per word.
    reg [31:0] memory [0:511];

    // Asynchronous read: read_data changes combinationally with address.
    // read bytes specified by byte_out_format_sel
    always@(*) begin
        case(byte_out_format_sel)
            LW:  read_data = memory[address];
            LH:  read_data = {{16{memory[address][15]}}, memory[address][15:0]};
            LB:  read_data = {{24{memory[address][7]}}, memory[address][7:0]};
            LHU: read_data = {16'd0, memory[address][15:0]};
            LBU: read_data = {24'd0, memory[address][7:0]};
            default: read_data = 32'hxxxxxxxx;
        endcase
    end

    // Synchronous write: memory is updated on the rising clock edge.
    always @(posedge clk) begin
        if (write_enable) begin
            case(byte_in_format_sel)
                SW: memory[address]        <= write_data;
                SH: memory[address][15:0]  <= write_data[15:0];
                SB: memory[address][7:0]   <= write_data[7:0];
            endcase
        end
    end

endmodule
