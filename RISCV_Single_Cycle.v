module RISCV_Single_Cycle(
    // Clock signal
    input logic clk,
    // Active-low reset signal
    input logic rst_n,
    // Current PC output for external observation (e.g., testbench)
    output logic [31:0] PC_out_top,
    // Instruction fetched from instruction memory
    output logic [31:0] Instruction_out_top
);

    // Next value of the Program Counter (PC)
    logic [31:0] PC_next;

    // Decoded instruction fields: rs1, rs2, rd register addresses
    logic [4:0] rs1, rs2, rd;
    // funct3 field of instruction
    logic [2:0] funct3;
    // opcode and funct7 fields for instruction decoding
    logic [6:0] opcode, funct7;

    // Immediate value generated by Imm_Gen
    logic [31:0] Imm;

    // Data read from the register file for rs1 and rs2, and write data
    logic [31:0] ReadData1, ReadData2, WriteData;

    // ALU second operand and result
    logic [31:0] ALU_in2, ALU_result;
    // Zero flag from ALU (for branch decision)
    logic ALUZero;

    // Data read from data memory
    logic [31:0] MemReadData;

    // Control signals generated by the control unit
    logic [1:0] ALUSrc;       // Selects ALU second operand
    logic [3:0] ALUCtrl;      // ALU operation selector
    logic Branch;             // Branch control signal
    logic MemRead;            // Enable reading from data memory
    logic MemWrite;           // Enable writing to data memory
    logic MemToReg;           // Selects data for register write-back
    logic RegWrite;           // Enable writing to register file
    logic PCSel;              // Selects next PC: sequential or branch

    // Program Counter update: synchronous with clk, asynchronous reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC_out_top <= 32'b0;    // Reset PC to 0
        else
            PC_out_top <= PC_next;  // Update PC with next value
    end

    // Instruction Memory (IMEM): fetch instruction based on current PC
    Inst_Mem IMEM_inst(
        .addr(PC_out_top),
        .Instruction(Instruction_out_top)
    );

    // Instruction decoding: split instruction fields for control and datapath
    assign opcode = Instruction_out_top[6:0];
    assign rd     = Instruction_out_top[11:7];
    assign funct3 = Instruction_out_top[14:12];
    assign rs1    = Instruction_out_top[19:15];
    assign rs2    = Instruction_out_top[24:20];
    assign funct7 = Instruction_out_top[31:25];

    // Immediate Generator: produces immediate value from instruction
    Imm_Gen imm_gen(
        .inst(Instruction_out_top),
        .imm_out(Imm)
    );

    // Register File: provides two read ports and one write port
    // NOTE: instance name 'Reg_inst' must match testbench expectations
    Reg_File Reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // ALU input selection: choose between ReadData2 or Immediate as ALU operand B
    assign ALU_in2 = (ALUSrc[0]) ? Imm : ReadData2;

    // ALU: performs arithmetic/logic operations
    ALU alu(
        .A(ReadData1),
        .B(ALU_in2),
        .ALUOp(ALUCtrl),
        .Result(ALU_result),
        .Zero(ALUZero)
    );

    // Data Memory (DMEM): supports read/write based on control signals
    Data_Mem DMEM_inst(
        .clk(clk),
        .rst_n(rst_n),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(ALU_result),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );

    // Write-back mux: selects data to write back to register file
    assign WriteData = (MemToReg) ? MemReadData : ALU_result;

    // Control Unit: generates control signals based on instruction fields
    Control_Unit ctrl(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUCtrl),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite)
    );

    // Branch comparator: determines whether to take the branch
    Branch_Adder comp(
        .A(ReadData1),
        .B(ReadData2),
        .Branch(Branch),
        .funct3(funct3),
        .BrTaken(PCSel)
    );

    // Next PC logic: PC+4 for sequential execution or PC+Imm for branch
    assign PC_next = (PCSel) ? PC_out_top + Imm : PC_out_top + 4;

endmodule
