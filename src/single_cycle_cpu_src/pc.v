module pc (
	input wire pc_load,
	input wire clk,
	output reg  [31:0] curr_pc
	);
	
	wire [31:0] pcin;
	assign pcin = curr_pc + 4;

	
	// initialize PC output to 0
	initial begin
		curr_pc = 0;
	end
	
	
	always@(posedge clk, posedge pc_load) begin
	
		if (pc_load == 1) begin
			curr_pc <= pcin;
		end
	
	end



endmodule

