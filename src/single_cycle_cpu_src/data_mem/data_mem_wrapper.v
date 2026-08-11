module data_mem_wrapper (
    input  wire        clk,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    input  wire [3:0]  byte_enable,
    input  wire        read_enable,
    input  wire        write_enable,
    output wire [31:0] read_data
);

    // data_mem contains 512 32-bit words. The CPU supplies a byte address,
    // so address[1:0] selects a byte lane and address[10:2] selects a word.
    wire [8:0] word_address;

    assign word_address = address[10:2];

    data_mem data_mem_inst (
        .address (word_address),
        .byteena (byte_enable),
        .clock   (clk),
        .data    (write_data),
        .rden    (read_enable),
        .wren    (write_enable),
        .q       (read_data)
    );

endmodule
