
`timescale 1ns/1ps

module tb_sram_64kb;

    logic clk;
    logic write_en;
    logic [9:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;

    logic [9:0] test_addr [0:7];
    logic [31:0] expected [0:7];

    integer i;
    integer errors;

    sram_64kb dut (
        .clk(clk),
        .write_en(write_en),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // 10 ns clock period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        write_en = 0;
        addr = 0;
        write_data = 0;
        errors = 0;

        test_addr[0] = 5;
        test_addr[1] = 17;
        test_addr[2] = 100;
        test_addr[3] = 250;
        test_addr[4] = 511;
        test_addr[5] = 700;
        test_addr[6] = 900;
        test_addr[7] = 1023;

        expected[0] = 32'h11111111;
        expected[1] = 32'h22222222;
        expected[2] = 32'h33333333;
        expected[3] = 32'h44444444;
        expected[4] = 32'h55555555;
        expected[5] = 32'h66666666;
        expected[6] = 32'h77777777;
        expected[7] = 32'h88888888;

        // Write to eight memory locations
        $display("Starting SRAM write phase");

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            write_en = 1;
            addr = test_addr[i];
            write_data = expected[i];

            @(posedge clk);
            #1;
            $display("WRITE: address=%0d data=%h",
                     test_addr[i], expected[i]);
        end

        @(negedge clk);
        write_en = 0;

        // Read back and verify all eight locations
        $display("Starting SRAM read/verify phase");

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            addr = test_addr[i];

            @(posedge clk);
            #1;

            if (read_data !== expected[i]) begin
                $display("FAIL: address=%0d expected=%h actual=%h",
                         test_addr[i], expected[i], read_data);
                errors = errors + 1;
            end
            else begin
                $display("PASS: address=%0d data=%h",
                         test_addr[i], read_data);
            end
        end

        if (errors == 0)
            $display("SRAM 64KB TEST PASS");
        else
            $display("SRAM 64KB TEST FAIL: %0d errors", errors);

        $finish;
    end

endmodule
