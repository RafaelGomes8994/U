module adder4bits(
    input [3:0] a,
    input [3:0] b,
    output [4:0] s
);
    // descricao mais simples. A diversao (abaixo) fica contigo.
    // assign s = a + b;

     assign s[4] = cout[3];

    // Agora faz a descricao hierarquica, instanciando 4 full_adders
    // e ligando os respectivos fios. Vou fazer o primeiro, e voce termina.
    
    wire[3:0] cout;
    fulladder fa0( .s(s[0]), .cout(cout[0]), .a(a[0]), .b(b[0]), .cin(1'b0));

    fulladder fa1( .s(s[1]),     .cout(cout[1]),        .a(a[1]),     .b(b[1]),     .cin(cout[0]));

    fulladder fa2( .s(s[2]),     .cout(cout[2]),        .a(a[2]),     .b(b[2]),     .cin(cout[1])       );

    fulladder fa3( .s(s[3]),     .cout(cout[3]),        .a(a[3]),     .b(b[3]),     .cin(cout[2])       );
    
    
    // comenta a linha 7 e habilita somente a descricao estrutural.
    // Roda o testebench para garantir que voce fez certo.
endmodule