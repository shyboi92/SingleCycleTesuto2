module PC_Mux( pc_in, pc_branch, pc_select, pc_out );
    input [31:0] pc_in;     
    input [31:0] pc_branch;   
    input pc_select;          
    output reg[31:0] pc_out;  

   always @(*) begin
        if (pc_select==1'b0) begin
            pc_out = pc_in;  
        end else begin
            pc_out = pc_branch;      
        end
    end

endmodule