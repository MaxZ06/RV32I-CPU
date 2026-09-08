// CSR support is under development and is not integrated into the core.

module csr_regs (
    input wire clk,
    input wire csr_write_en,
    input wire [11:0] csr_write_sel,
    input wire [11:0] csr_read_sel,
    input wire [31:0] csr_write_data,
    output reg [31:0] csr_read
);

    localparam [11:0] CSR_MSTATUS = 12'h300,
        CSR_MIE = 12'h304,
        CSR_MTVEC = 12'h305,
        CSR_MEPC = 12'h341,
        CSR_MCAUSE = 12'h342,
        CSR_MIP = 12'h344;

    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mstatus;
    reg [31:0] mcause;
    reg [31:0] mie;
    reg [31:0] mip;

    // Registers retain their values unless selected for a rising-edge write.
    // As with reg_file, values are uninitialized until written.
    always @(posedge clk) begin
        if (csr_write_en) begin
            case (csr_write_sel)
                CSR_MTVEC: mtvec <= csr_write_data;
                CSR_MEPC: mepc <= csr_write_data;
                CSR_MSTATUS: mstatus <= csr_write_data;
                CSR_MCAUSE: mcause <= csr_write_data;
                CSR_MIE: mie <= csr_write_data;
                CSR_MIP: mip <= csr_write_data;
                default: begin end
            endcase
        end
    end

    // Independent asynchronous read port; unsupported addresses read as zero.
    always @(*) begin
        case (csr_read_sel)
            CSR_MTVEC: csr_read = mtvec;
            CSR_MEPC: csr_read = mepc;
            CSR_MSTATUS: csr_read = mstatus;
            CSR_MCAUSE: csr_read = mcause;
            CSR_MIE: csr_read = mie;
            CSR_MIP: csr_read = mip;
            default: csr_read = 32'b0;
        endcase
    end
endmodule

module csr_handler (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] ctrl,
    output reg [31:0] out
);

    localparam [2:0] CSRRW = 3'b000,
        CSRRS = 3'b001,
        CSRRC = 3'b010;

    // a is the source mask/value; b is the current CSR value.
    always @(*) begin
        case (ctrl)
            CSRRW: out = a;
            CSRRS: out = a | b;
            CSRRC: out = b & ~a;
            default: out = b;
        endcase
    end
endmodule
