module Imm_Gen(
    input  [31:0] instruction,
    input  [2:0]  imm_src,
    output logic [31:0] imm_out
);
    wire [31:0] imm_i = {{20{instruction[31]}}, instruction[31:20]};
    wire [31:0] imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    wire [31:0] imm_b = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    always_comb begin
        imm_out = 32'b0;
        case (imm_src)
            3'b000: imm_out = imm_i;
            3'b001: imm_out = imm_s;
            3'b010: imm_out = imm_b;
            default: imm_out = 32'b0;
        endcase
    end
endmodule
