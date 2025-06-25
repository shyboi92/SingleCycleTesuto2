module Reg_File(clk, rst, RegWrite,Rs1,Rs2, Rd,Write_data,read_data1, read_data2);

input clk, rst, RegWrite;
input [4:0] Rs1,Rs2, Rd;
input [31:0] Write_data;
output [31:0] read_data1, read_data2;

reg [31:0] Registers [31:0];

 initial begin
Registers[0]  = 0;   
Registers[1]  = 81;
Registers[2]  = 57;
Registers[3]  = 12;
Registers[4]  = 73;
Registers[5]  = 39;
Registers[6]  = 5;
Registers[7]  = 66;
Registers[8]  = 28;
Registers[9]  = 94;
Registers[10] = 18;
Registers[11] = 3;
Registers[12] = 91;
Registers[13] = 24;
Registers[14] = 49;
Registers[15] = 37;
Registers[16] = 63;
Registers[17] = 44;
Registers[18] = 72;
Registers[19] = 87;
Registers[20] = 16;
Registers[21] = 55;
Registers[22] = 99;
Registers[23] = 13;
Registers[24] = 60;
Registers[25] = 11;
Registers[26] = 90;
Registers[27] = 35;
Registers[28] = 4;
Registers[29] = 76;
Registers[30] = 8;
Registers[31] = 100;

end

integer k;
always @(posedge clk) begin
if (rst) 
begin
      for (k = 0; k < 32; k = k + 1) begin
        Registers[k] = 32'b00;
      end
    end

    else if (RegWrite ) begin
      Registers[Rd] = Write_data;
    end
  end

  assign read_data1 = Registers[Rs1];
  assign read_data2 = Registers[Rs2];
endmodule