module ALU_bit_slice (
    input A, B, Cin,
    input [2:0] F,
    output Cout,  
    output reg R
);

    wire sum, sub, and_out, or_out, xor_out, not_a, not_b, pass_a;;
    wire add_cout, sub_cout;

    // Soma
    FullAdder ADD (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(sum),
        .Cout(add_cout)
    );

    // Subtração
    Subtractor SUB (
        .A(A),
        .B(B),
        .Cin(1'b1),
        .S(sub),
        .Cout(sub_cout)
    );

    // Operações Lógicas
    AND_gate AND1 (
        .A(A),
        .B(B),
        .R(and_out)
    );

    OR_gate OR1 (
        .A(A),
        .B(B),
        .R(or_out)
    );

    XOR_gate XOR1 (
        .A(A),
        .B(B),
        .R(xor_out)
    );

    NOT_gate NOT1 (
        .A(A),
        .R(not_a)
    );

    NOT_gate NOT2 (
        .A(B),
        .R(not_b)
    );

  PassThrough PT (
        .A(A), 
        .R(pass_a)
    );
// Multiplexador para selecionar operação e definir Cout
    reg cout_internal; // Cout interno para evitar conflito
    assign Cout = cout_internal; // Cout final atribuído externamente

   always @(*) begin
    case (F)
        3'b000: begin
            R = sum;     // Soma
            cout_internal = add_cout;
        end
        3'b001: begin
            R = sub;     // Subtração
            cout_internal = sub_cout;
        end
        3'b010: begin
            R = and_out; // AND
            cout_internal = 1'b0; // Não gera carry
        end
        3'b011: begin
            R = or_out;  // OR
            cout_internal = 1'b0; // Não gera carry
        end
        3'b100: begin
            R = xor_out; // XOR
            cout_internal = 1'b0; // Não gera carry
        end
        3'b101: begin
            R = not_a;   // NOT A
            cout_internal = 1'b0; // Não gera carry
        end
        3'b110: begin
            R = pass_a;  // Passagem direta
            cout_internal = 1'b0; // Não gera carry
        end
        3'b111: begin
            R = not_b;   // NOT B
            cout_internal = 1'b0; // Não gera carry
        end
        default: begin
            R = 1'b0;    // Valor padrão
            cout_internal = 1'b0; // Valor padrão
        end
    endcase
end


endmodule
