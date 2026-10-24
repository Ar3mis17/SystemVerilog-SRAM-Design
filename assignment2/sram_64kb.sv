
`timescale 1ns/1ps

module sram_64kb (
    input  logic        clk,
    input  logic        write_en,
    input  logic [9:0]  addr,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    // 1024 locations, each 32 bits wide
    logic [31:0] mem [0:1023];

    always_ff @(posedge clk) begin
        if (write_en)
            mem[addr] <= write_data;

        read_data <= mem[addr];
    end

endmodule
