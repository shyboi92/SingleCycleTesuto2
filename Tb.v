module Tb;
    reg clk, rst;   
    Top UUT (
        .clk(clk), 
        .rst(rst)
    );

    initial begin
        clk = 0;
    end
    always #50 clk = ~clk; 

    initial begin
        rst = 1'b1;
        #50;
        rst = 1'b0; 
        #5200; 
        $finish; 
    end

endmodule