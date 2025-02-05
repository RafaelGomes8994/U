// ALU (Unidade Lógica e Aritmética)
module ALU(
    input [31:0] input1, input2, // Dois operandos de 32 bits
    input [3:0] ALUControl,      // Sinal de controle para selecionar a operação
    output reg [31:0] result,    // Resultado da operação
    output reg zero              // Sinal que indica se o resultado é zero
);
    always @(*) begin
        case (ALUControl)
            4'b0010: result = input1 + input2; // Operação de ADD (soma)
            4'b0110: result = input1 - input2; // Operação de SUB (subtração)
            4'b0000: result = input1 & input2; // Operação de AND (bitwise AND)
            4'b0001: result = input1 | input2; // Operação de OR (bitwise OR)
            4'b0111: result = (input1 < input2) ? 1 : 0; // Operação de SLT (set less than)
            default: result = 0; // Caso padrão, resultado é zero
        endcase
        zero = (result == 0) ? 1 : 0; // Define o sinal zero como 1 se o resultado for zero
    end
endmodule


