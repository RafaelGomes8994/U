module FullAdder (
    input A, B, Cin,
    output S, Cout
);
    wire xor1_out, and1_out, and2_out;

    xor (xor1_out, A, B);      
    xor (S, xor1_out, Cin);     
    and (and1_out, xor1_out, Cin); 
    and (and2_out, A, B);      
    or (Cout, and1_out, and2_out);
endmodule

module Subtractor (
    input A, B, Cin,
    output S, Cout
);
    FullAdder FA (
        .A(A),
        .B(~B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
    );
   
endmodule


module AND_gate (
    input A, B,
    output R
);
    and (R, A, B);
endmodule

module OR_gate (
    input A, B,
    output R
);
    or (R, A, B);
endmodule

module XOR_gate (
    input A, B,
    output R
);
    xor (R, A, B);
endmodule

module NOT_gate (
    input A,
    output R
);
    not (R, A);
endmodule

module PassThrough (
    input A,
    output R
);
    assign R = A;
endmodule
