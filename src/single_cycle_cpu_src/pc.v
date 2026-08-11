module pc (
	input wire pc_load,
	input wire clk,
	input wire is_jump,
	input wire [31:0] jump_offset,
	input wire reset,
	output reg  [31:0] curr_pc
	);
	
	wire [31:0] pcin;
	wire [31:0] pc_update;
	
	pc_adder_mux mux2to1 (is_jump, jump_offset, pc_update);
	assign pcin = curr_pc + pc_update;

	
	// initialize PC output to 0
	initial begin
		curr_pc = 0;
	end
	
	
	always@(posedge clk) begin
		if (reset == 1) begin
			curr_pc <= 32'd0;
		end
		
		else if (pc_load == 1) begin
			curr_pc <= pcin;
		end
	
	end



endmodule


module pc_adder_mux(
	input wire sel,
	input wire [31:0] offset,
	output reg [31:0] out
	);
	
	wire [31:0] std_jump;
	assign std_jump = 32'd4;
	
	always@(*) begin
		if (sel == 0)
			out = std_jump;
		else 
			out = offset;
		end

endmodule
