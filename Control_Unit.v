module Control_Unit(
    input  [6:0] opcode,
    output logic reg_write,
    output logic mem_write,
    output logic branch,
    output logic [1:0] alu_src,
    output logic [2:0] imm_src,
    output logic [1:0] alu_op
);
    always_comb begin
        // Gán mặc định tất cả output
        reg_write = 0;
        mem_write = 0;
        branch    = 0;
        alu_src   = 2'b00;
        imm_src   = 3'b000;
        alu_op    = 2'b00;

        case (opcode)
            7'b0110011: begin  // R-type
                reg_write = 1;
                alu_src   = 2'b00;
                alu_op    = 2'b10;
            end
            7'b0010011: begin  // I-type ALU
                reg_write = 1;
                alu_src   = 2'b01;
                alu_op    = 2'b10;
            end
            7'b0000011: begin  // Load
                reg_write = 1;
                alu_src   = 2'b01;
                alu_op    = 2'b00;
            end
            7'b0100011: begin  // Store
                mem_write = 1;
                alu_src   = 2'b01;
                imm_src   = 3'b001;
                alu_op    = 2'b00;
            end
            7'b1100011: begin  // Branch
                branch    = 1;
                alu_op    = 2'b01;
                imm_src   = 3'b010;
            end
        endcase
    end
endmodule
