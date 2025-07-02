`timescale 1ns/1ps

module RISCV_Single_Cycle(
    input clk,
    input rst_n
);

    logic [31:0] pc_current, pc_next;
    logic [31:0] instruction;
    logic [31:0] imm_out;
    logic [31:0] rs1_data, rs2_data, alu_result;
    logic [31:0] dmem_data_out;
    logic [3:0] alu_control;
    logic [1:0] alu_src;
    logic [2:0] imm_src;
    logic mem_write, reg_write, branch;
    logic zero;
    logic [31:0] write_data;
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic pc_src;
    logic [1:0] alu_op;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign opcode = instruction[6:0];

    // PC
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_current <= 0;
        else
            pc_current <= pc_next;
    end

    assign pc_src = branch & zero;
    assign pc_next = pc_src ? (pc_current + imm_out) : (pc_current + 4);

    // Instruction Memory
    Inst_Mem IMEM_inst (
        .addr(pc_current[31:2]),
        .instruction(instruction)
    );

    // Instruction output for testbench
    logic [31:0] Instruction_out_top;
    assign Instruction_out_top = instruction;

    // Register File
    Reg_File RF (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .rd_data(write_data),
        .reg_write(reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Immediate Generator
    Imm_Gen IG (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_out(imm_out)
    );

    // ALU Decoder
    alu_control ALUdec (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7b5(instruction[30]),
        .alu_control(alu_control)
    );

    // ALU
    ALU alu (
        .a(rs1_data),
        .b(alu_src[0] ? imm_out : rs2_data),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    Data_Mem DMEM_inst (
        .clk(clk),
        .addr(alu_result),
        .write_data(rs2_data),
        .mem_write(mem_write),
        .read_data(dmem_data_out)
    );

    // Write-back Mux
    assign write_data = (opcode == 7'b0000011) ? dmem_data_out : alu_result;

    // Control Unit
    Control_Unit CU (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .branch(branch),
        .alu_src(alu_src),
        .imm_src(imm_src),
	.alu_op(alu_op)
    );

endmodule
