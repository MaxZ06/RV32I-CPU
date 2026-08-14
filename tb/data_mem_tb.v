`timescale 1ns/1ps

module data_mem_tb;

    reg         clk;
    reg         write_enable;
    reg  [8:0]  address;
    reg  [31:0] write_data;
    wire [31:0] read_data;

    integer errors;

    behavioral_data_mem dut (
        .clk          (clk),
        .write_enable (write_enable),
        .address      (address),
        .write_data   (write_data),
        .read_data    (read_data)
    );

    always #5 clk = ~clk;

    task check_read;
        input [8:0]  test_address;
        input [31:0] expected_data;
        begin
            address = test_address;
            #1;

            if (read_data !== expected_data) begin
                $display("ERROR: address=%0d expected=%h actual=%h",
                         test_address, expected_data, read_data);
                errors = errors + 1;
            end else begin
                $display("PASS:  address=%0d read_data=%h",
                         test_address, read_data);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        write_enable = 1'b0;
        address = 9'd0;
        write_data = 32'b0;
        errors = 0;

        // Initialize selected locations directly for this unit test.
        dut.memory[2]   = 32'h12345678;
        dut.memory[5]   = 32'haaaaaaaa;
        dut.memory[511] = 32'hdeadbeef;

        // Verify asynchronous reads, including the highest valid address.
        check_read(9'd2,   32'h12345678);
        check_read(9'd511, 32'hdeadbeef);

        // A pending write must not change memory before the rising edge.
        @(negedge clk);
        address = 9'd5;
        write_data = 32'hcafebabe;
        write_enable = 1'b1;
        #1;
        if (read_data !== 32'haaaaaaaa) begin
            $display("ERROR: memory changed before the rising edge");
            errors = errors + 1;
        end else begin
            $display("PASS:  write did not occur before the rising edge");
        end

        // The write commits on the next rising edge.
        @(posedge clk);
        #1;
        check_read(9'd5, 32'hcafebabe);

        // With write_enable low, a rising edge must not modify memory.
        @(negedge clk);
        write_enable = 1'b0;
        write_data = 32'hffffffff;
        @(posedge clk);
        #1;
        check_read(9'd5, 32'hcafebabe);

        if (errors == 0)
            $display("data_mem_tb PASSED");
        else
            $display("data_mem_tb FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
