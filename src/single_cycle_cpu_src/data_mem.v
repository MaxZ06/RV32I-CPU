module behavioral_data_mem (
    input  wire        clk,
    input  wire        write_enable,
    input  wire [8:0]  address,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    // 512 words, 32 bits per word.
    reg [31:0] memory [0:511];

    // Asynchronous read: read_data changes combinationally with address.
    assign read_data = memory[address];

    // Synchronous write: memory is updated on the rising clock edge.
    always @(posedge clk) begin
        if (write_enable)
            memory[address] <= write_data;
    end

endmodule
