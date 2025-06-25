module PC( clk, rst, pc_in, pc_out );
    input clk;               
    input rst;                
    input [31:0] pc_in;       
    output reg [31:0] pc_out; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'b00;  
        end else begin
            pc_out <= pc_in;  
        end
    end
endmodule