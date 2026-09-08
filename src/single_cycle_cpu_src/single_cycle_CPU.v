// Single-cycle CPU: connects the control unit, datapath, and memories.

module single_cycle_CPU (
    input wire clk,
    input wire reset
);

    // signals

    // pc signals
    wire [31:0] pc_next;
    wire [31:0] pc_out;
    wire [31:0] pc_add_4; // intermediate signal

    // declare the memory addresses
    wire [7:0] instruction_mem_addr;
    wire [31:0] current_instruction; // imem out

    // reg file signals
    wire [31:0] rf_data_in;
    wire [4:0] ra_sel, rb_sel, reg_write_sel;
    wire [31:0] ra, rb;

    // comparator unit signals
    wire [31:0] lhs;
    wire [31:0] rhs;
    wire comp_result; // connects to control unit

    // alu signals
    wire [31:0] alu_port_a;
    wire [31:0] alu_port_b;
    wire [31:0] alu_out;
    wire [31:0] comp_mux_result;

    // imm handler signals
    wire [2:0] imm_sel;
    wire [31:0] imm_out;

    // data memory signals
    wire [31:0] dmem_data_in;
    wire [31:0] dmem_data_out;
    wire [8:0] dmem_addr_sel;

    // control signals

    // pc control
    wire pc_sel;

    // comparator control
    wire [2:0] comp_sel;
    wire comp_b_sel;

    // alu control
    wire [2:0] alu_op;
    wire [1:0] alu_a_sel;
    wire [1:0] alu_b_sel;

    // regfile controls
    wire [1:0] data_in_sel;
    wire reg_write_en;

    // data mem controls
    wire [1:0] din_byte_sel;
    wire [2:0] dout_byte_sel;
    wire dmem_write_en;

    // data_path signals
    wire set_lsb_zero_en;
    wire [31:0] lsb_0;

    // datapath connections

    assign instruction_mem_addr = pc_out[9:2];
    assign ra_sel = current_instruction[19:15];
    assign rb_sel = current_instruction[24:20];
    assign reg_write_sel = current_instruction[11:7];
    assign dmem_addr_sel = alu_out[8:0];
    assign dmem_data_in = rb;
    assign lhs = ra;

    set_lsb_zero slz (.in(alu_out), .enable(set_lsb_zero_en), .out(lsb_0));
    pc_adder pc_a (.curr_pc(pc_out), .pc_next(pc_add_4));

    mux2to1 comp_slt (.sel(comp_result), .a(32'b0), .b(32'b1), .y(comp_mux_result));
    mux2to1 comp_b_mux (.sel(comp_b_sel), .a(rb), .b(imm_out), .y(rhs));
    mux2to1 mux_pc_next (.sel(pc_sel), .a(pc_add_4), .b(lsb_0), .y(pc_next));
    mux3to1 mux_alu_a (.sel(alu_a_sel), .a(ra), .b(pc_out), .c(32'd0),
        .y(alu_port_a));
    mux3to1 mux_alu_b (.sel(alu_b_sel), .a(rb), .b(imm_out), .c(comp_mux_result),
        .y(alu_port_b));
    mux4to1 mux_rf_data_in (.sel(data_in_sel), .a(alu_out), .b(dmem_data_out), .c(pc_add_4),
        .d(imm_out), .y(rf_data_in));

    // module instantiation

    control_unit cu (
        .comp_result(comp_result),
        .instruction(current_instruction),
        .pc_sel(pc_sel),
        .reg_write_en(reg_write_en),
        .data_in_sel(data_in_sel),
        .alu_a_sel(alu_a_sel),
        .alu_b_sel(alu_b_sel),
        .alu_op(alu_op),
        .comp_sel(comp_sel),
        .imm_sel(imm_sel),
        .set_lsb_zero_en(set_lsb_zero_en),
        .dmem_write_en(dmem_write_en),
        .din_byte_sel(din_byte_sel),
        .dout_byte_sel(dout_byte_sel),
        .comp_b_sel(comp_b_sel)
    );

    pc program_counter (.clk(clk), .reset(reset), .next_pc(pc_next), .out(pc_out));

    reg_file rf (.clk(clk), .reg_write_sel(reg_write_sel), .reg_write_en(reg_write_en),
        .ra_sel(ra_sel), .rb_sel(rb_sel), .data_in(rf_data_in), .ra(ra), .rb(rb));

    comparator_unit comp_u (.lhs(lhs), .rhs(rhs), .comp_sel(comp_sel), .result(comp_result));

    alu alu (.a(alu_port_a), .b(alu_port_b), .sel(alu_op), .y(alu_out));

    imm_handler imm (.instruction(current_instruction[31:7]), .imm_sel(imm_sel), .se_imm(imm_out));

    instruction_mem imem(.address(instruction_mem_addr), .instruction(current_instruction));

    data_mem dmem (.clk(clk), .write_enable(dmem_write_en), .byte_in_format_sel(din_byte_sel),
        .byte_out_format_sel(dout_byte_sel), .address(dmem_addr_sel), .write_data(dmem_data_in), .read_data(dmem_data_out));
endmodule
