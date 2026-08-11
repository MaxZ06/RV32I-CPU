module instruction_memory_wrapper (
    input  wire        clk,
    input  wire [31:0] pc,
    output wire [31:0] instruction
);

    wire [8:0] word_address;

    assign word_address = pc[10:2];

    instruction_ram instruction_ram_inst (
        .address (word_address),
        .clock   (clk),
        .data    (32'b0),
        .wren    (1'b0),
        .q       (instruction)
    );

endmodule