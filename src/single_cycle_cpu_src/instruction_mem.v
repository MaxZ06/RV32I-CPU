module instruction_mem (
    input  wire [7:0]  address,
    output wire [31:0] instruction
);

    // 256 words, 32 bits per word.
    reg [31:0] memory [255:0];

    // Asynchronous read: instruction changes combinationally with address.
    assign instruction = memory[address];

endmodule
