module Alu32bit (
    input [31:0] A, B,
    input [2:0] F,
    output [31:0] R,
    output Cout 
);

    wire [31:0] carry; // Carries entre slices

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: alu_slices
            if (i == 0) begin
                // Primeiro bit (LSB)
                ALU_bit_slice slice (
                    .A(A[i]),
                    .B(B[i]),
                    .Cin(1'b0),
                    .F(F),
                    .R(R[i]),
                    .Cout(carry[i])
                );
            end else begin
                // Demais bits
                ALU_bit_slice slice (
                    .A(A[i]),
                    .B(B[i]),
                    .Cin(carry[i-1]),
                    .F(F),
                    .R(R[i]),
                    .Cout(carry[i])
                );
            end
        end
    endgenerate
        // Conectar o carry-out final ao último carry gerado
    assign Cout = carry[31];
    
endmodule
