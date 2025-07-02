module Reg_File(
    input         clk,
    input  [4:0]  rs1,
    input  [4:0]  rs2,
    input  [4:0]  rd,
    input  [31:0] rd_data,
    input         reg_write,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
    logic [31:0] regs [0:31];

    // Gán mặc định (reset tất cả về 0 nếu cần)
    initial begin
        for (int i = 0; i < 32; i++) regs[i] = 32'b0;
    end

    // Đọc
    always_comb begin
        rs1_data = regs[rs1];
        rs2_data = regs[rs2];
    end

    // Ghi
    always_ff @(posedge clk) begin
        if (reg_write && rd != 0)
            regs[rd] <= rd_data;
    end
endmodule
