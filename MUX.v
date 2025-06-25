module MUX ( input0, input1, select, out );
    input [31:0] input0;  
    input [31:0] input1;   
    input select;          
    output [31:0] out;      


    assign out = (select) ? input1 : input0;  

endmodule