module Data_Mem(
    input         clk,
    input  [31:0] addr,
    input  [31:0] write_data,
    input         mem_write,
    output logic [31:0] read_data
);
    logic [31:0] memory [0:1023];

    always_ff @(posedge clk) begin
        if (mem_write)
            memory[addr >> 2] <= write_data;  // ✅ shift bằng tay
    end

    assign read_data = memory[addr >> 2];     // ✅ shift bằng tay
endmodule
