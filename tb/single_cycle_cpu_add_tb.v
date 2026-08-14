/* testbench to simulate add instruction before implementation of control path
*/


`timescale 1ns/1ps




module single_cycle_cpu_add_tb;

    reg clk;
    reg reset;

    integer errors;

    single_cycle_CPU dut (
        .clk   (clk),
        .reset (reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        errors = 0;

        // Initialize source registers at t = 0 ns.
        dut.rf.rfReg[1] = 32'd2006;
        dut.rf.rfReg[2] = 32'd1222;


        // At t = 10 ns, select x1 and x2, perform ADD, and enable
        // writing the result into x3.
        #10;
        force dut.RASel  = 5'd1;
        force dut.RBSel  = 5'd2;
        force dut.ALUop  = 4'b0000;
        force dut.RegWEn = 1'b1;
        force dut.RegWSel = 5'd3;

        // Allow the combinational read and ALU result to settle.
        #1;
        if (dut.RA !== 32'd2006 ||
            dut.RB !== 32'd1222 ||
            dut.ALUout !== 32'd3228) begin
            $display("ERROR: RA=%0d RB=%0d ALUout=%0d",
                     dut.RA, dut.RB, dut.ALUout);
            errors = errors + 1;
        end else begin
            $display("PASS: ALU computed 2006 + 1222 = %0d", dut.ALUout);
        end

        // The register file commits x3 on the next rising clock edge.
        @(posedge clk);
        #1;
        if (dut.rf.rfReg[3] !== 32'd3228) begin
            $display("ERROR: x3 expected=3228 actual=%0d", dut.rf.rfReg[3]);
            errors = errors + 1;
        end else begin
            $display("PASS: x3=%0d after the rising edge", dut.rf.rfReg[3]);
        end

        release dut.RASel;
        release dut.RBSel;
        release dut.ALUop;
        release dut.RegWEn;
        release dut.RegWSel;

        if (errors == 0)
            $display("single_cycle_cpu_add_tb PASSED");
        else
            $display("single_cycle_cpu_add_tb FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
