`timescale 1ns/1ps

module instruction_memory_tb;

    reg  [7:0]  address;
    wire [31:0] instruction;

    integer errors;

    instruction_mem dut (
        .address     (address),
        .instruction (instruction)
    );

    task check_read;
        input [7:0]  test_address;
        input [31:0] expected_instruction;
        begin
            address = test_address;
            #1;

            if (instruction !== expected_instruction) begin
                $display("ERROR: address=%0d expected=%h actual=%h",
                         test_address, expected_instruction, instruction);
                errors = errors + 1;
            end else begin
                $display("PASS:  address=%0d instruction=%h",
                         test_address, instruction);
            end
        end
    endtask

    initial begin
        errors = 0;
        address = 8'd0;

        // Initialize a few words directly for this unit test.
        dut.memory[0]   = 32'h00500093;
        dut.memory[1]   = 32'h00a00113;
        dut.memory[3]   = 32'h002081b3;
        dut.memory[255] = 32'h00000013;

        check_read(8'd0,   32'h00500093);
        check_read(8'd1,   32'h00a00113);
        check_read(8'd3,   32'h002081b3);
        check_read(8'd255, 32'h00000013);

        if (errors == 0)
            $display("instruction_memory_tb PASSED");
        else
            $display("instruction_memory_tb FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
