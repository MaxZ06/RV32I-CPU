`timescale 1ns/1ps

module pc_tb;

    reg         clk;
    reg         reset;
    reg  [31:0] next_pc;
    wire [31:0] out;

    integer errors;

    pc dut (
        .clk     (clk),
        .reset   (reset),
        .next_pc (next_pc),
        .out     (out)
    );

    always #5 clk = ~clk;

    task check_out;
        input [31:0] expected;
        begin
            if (out !== expected) begin
                $display("ERROR: expected=%h actual=%h time=%0t",
                         expected, out, $time);
                errors = errors + 1;
            end else begin
                $display("PASS:  out=%h time=%0t", out, $time);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        next_pc = 32'h12345678;
        errors = 0;

        // Reset is synchronous, so out becomes zero at a rising edge.
        @(posedge clk);
        #1;
        check_out(32'h00000000);

        // next_pc must not affect out before the following rising edge.
        @(negedge clk);
        reset = 1'b0;
        next_pc = 32'h00000004;
        #1;
        check_out(32'h00000000);

        @(posedge clk);
        #1;
        check_out(32'h00000004);

        // Verify another ordinary PC update.
        @(negedge clk);
        next_pc = 32'h00000120;
        @(posedge clk);
        #1;
        check_out(32'h00000120);

        // Synchronous reset takes priority over next_pc.
        @(negedge clk);
        reset = 1'b1;
        next_pc = 32'hffffffff;
        @(posedge clk);
        #1;
        check_out(32'h00000000);

        if (errors == 0)
            $display("pc_tb PASSED");
        else
            $display("pc_tb FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
