`timescale 1ns/1ns

module ALU32bit_tb;
    // Declaração de sinais
    reg [31:0] A, B;     // Entradas
    reg [2:0] F;         // Seletor de função
    wire [31:0] R;       // Saída
    wire Cout;           // Carry-out da última operação

    // Instanciação do DUT
    Alu32bit DUT (
        .A(A),
        .B(B),
        .F(F),
        .R(R),
        .Cout(Cout)
    );

    // Bloco para dump de ondas
    initial begin
        $dumpfile("ALU32bit_tb.vcd");
        $dumpvars(0, ALU32bit_tb);
    end

    // Variável para armazenar o resultado esperado
    reg [31:0] expected_result;
    reg expected_cout;

    // Bloco always para verificar o resultado esperado
    always @(A, B, F) begin
        case (F)
            3'b000: begin
                expected_result = A + B;
                expected_cout = A + B >= 32'hFFFFFFFF ? 1 : 0;
            end
            3'b001: begin
                expected_result = A - B;
                expected_cout =  B > A ? 1 : 0;
            end
            3'b010: begin
                expected_result = A & B;
                expected_cout = 0;
            end
            3'b011: begin
                expected_result = A | B;
                expected_cout = 0;
            end
            3'b100: begin
                expected_result = ~(A ^ B);
                expected_cout = 0;
            end
            3'b101: begin
                expected_result = ~A;
                expected_cout = 0;
            end
            3'b110: begin
                expected_result = A;
                expected_cout = 0;
            end
            3'b111: begin
                expected_result = ~B;
                expected_cout = 0;
            end
            default: begin
                expected_result = 0;
                expected_cout = 0;
            end
        endcase

        #1; // Aguardar tempo suficiente para o DUT processar os sinais

        if (R !== expected_result || Cout !== expected_cout) begin
            $display("ERRO: F=%b | A=%h | B=%h | Esperado=%h | Obtido=%h | Cout esperado=%b | Cout obtido=%b",
                F, A, B, expected_result, R, expected_cout, Cout);
        end
    end

    /*****************
    *  TESTES ALEATÓRIOS
    ******************/
    integer i; // Iterador local
    initial begin
        $display("** Testando valores aleatórios **");
        for (i = 0; i < 20; i = i + 1) begin
            A = $random;
            B = $random;
            for (F = 3'b000; F <= 3'b111; F = F + 1) begin
                #10;
                $display("F=%b | A=%h | B=%h | R=%h | Cout=%b", F, A, B, R, Cout);
            end
        end
    end

    /*****************
    *  TESTES DE OVERFLOW
    ******************/
    initial begin
        #100; // Aguardar término dos testes aleatórios
        $display("** Testando casos de overflow **");

        // Testes de soma
        A = 32'h7FFFFFFF; B = 32'h00000001; F = 3'b000; #10;
        $display("Soma Overflow: A=%h | B=%h | R=%h | Cout=%b", A, B, R, Cout);

        A = 32'hFFFFFFFF; B = 32'h00000001; F = 3'b000; #10;
        $display("Soma Overflow: A=%h | B=%h | R=%h | Cout=%b", A, B, R, Cout);

        // Testes de subtração
        A = 32'h80000000; B = 32'h00000001; F = 3'b001; #10;
        $display("Subtração Underflow: A=%h | B=%h | R=%h | Cout=%b", A, B, R, Cout);

        A = 32'h00000000; B = 32'hFFFFFFFF; F = 3'b001; #10;
        $display("Subtração Overflow: A=%h | B=%h | R=%h | Cout=%b", A, B, R, Cout);
    end

    /*****************
    *  TESTES CRÍTICOS
    ******************/
    initial begin
        #200; // Aguardar término dos testes anteriores
        $display("** Testando casos críticos **");

        // Teste com valores zero
        A = 32'h00000000; B = 32'h00000000; F = 3'b000; #10;
        $display("F=%b | A=%h | B=%h | R=%h | Cout=%b", F, A, B, R, Cout);

        // Teste com maior valor positivo
        A = 32'h7FFFFFFF; B = 32'h7FFFFFFF; F = 3'b011; #10;
        $display("F=%b | A=%h | B=%h | R=%h | Cout=%b", F, A, B, R, Cout);

        // Teste com menor valor negativo
        A = 32'h80000000; B = 32'h80000000; F = 3'b010; #10;
        $display("F=%b | A=%h | B=%h | R=%h | Cout=%b", F, A, B, R, Cout);
    end

    // Finalizar a simulação
    initial begin
        #300;
        $finish;
    end

endmodule
