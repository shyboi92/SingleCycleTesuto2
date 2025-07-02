module ALU(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  alu_control,
    output logic [31:0] result,
    output logic zero
);
    always_comb begin
        result = 32'b0;   // Gán mặc định!
        zero   = 1'b0;    // Gán mặc định!
        case (alu_control)
            4'b0000: result = a & b;
            4'b0001: result = a | b;
            4'b0010: result = a + b;
            4'b0110: result = a - b;
            4'b0111: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            default: result = 32'b0;
        endcase
        zero = (result == 0);
    end
endmodule
