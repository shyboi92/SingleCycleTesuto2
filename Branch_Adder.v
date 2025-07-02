module Branch_Adder(
    input  [31:0] a,
    input  [31:0] b,
    output logic zero
);
    assign zero = (a == b);
endmodule
