
`timescale 1ns/1ps

module sram_4bank (
    input  logic        clk,
    input  logic        write_en,
    input  logic [1:0]  bank_sel,
    input  logic [7:0]  addr,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    // Four banks, each with 256 words of 32 bits
    logic [31:0] bank [0:3][0:255];

    always_ff @(posedge clk) begin
        if (write_en)
            bank[bank_sel][addr] <= write_data;

        read_data <= bank[bank_sel][addr];
    end

endmodule
