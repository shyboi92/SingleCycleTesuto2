module Inst_Mem(
    input  [29:0] addr,
    output logic [31:0] instruction
);
    logic [31:0] memory [0:1023];

    assign instruction = memory[addr];
endmodule