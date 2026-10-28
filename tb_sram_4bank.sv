
`timescale 1ns/1ps

module tb_sram_4bank;

    logic clk;
    logic write_en;
    logic [1:0] bank_sel;
    logic [7:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;

    logic [31:0] expected [0:3];
    integer i;
    integer errors;

    sram_4bank dut (
        .clk(clk),
        .write_en(write_en),
        .bank_sel(bank_sel),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        write_en = 0;
        bank_sel = 0;
        addr = 10;
        write_data = 0;
        errors = 0;

        expected[0] = 32'h11111111;
        expected[1] = 32'h22222222;
        expected[2] = 32'h33333333;
        expected[3] = 32'h44444444;

        // Write different values to address 10 in all four banks
        $display("Starting four-bank SRAM write phase");

        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            write_en = 1;
            bank_sel = i;
            addr = 10;
            write_data = expected[i];

            @(posedge clk);
            #1;
            $display("WRITE: bank=%0d address=10 data=%h",
                     i, expected[i]);
        end

        @(negedge clk);
        write_en = 0;

        // Read back each bank's address 10
        $display("Starting four-bank SRAM read/verify phase");

        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            bank_sel = i;
            addr = 10;

            @(posedge clk);
            #1;

            if (read_data !== expected[i]) begin
                $display("FAIL: bank=%0d expected=%h actual=%h",
                         i, expected[i], read_data);
                errors = errors + 1;
            end
            else begin
                $display("PASS: bank=%0d data=%h",
                         i, read_data);
            end
        end

        if (errors == 0)
            $display("FOUR-BANK SRAM TEST PASS");
        else
            $display("FOUR-BANK SRAM TEST FAIL: %0d errors", errors);

        $finish;
    end

endmodule
