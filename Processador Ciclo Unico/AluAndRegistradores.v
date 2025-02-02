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

// Registradores (Banco de Registradores)''
module Registers(
    input clk,                   // Sinal de clock
    input RegWrite,              // Sinal para habilitar escrita no registrador
    input [4:0] readReg1,        // Endereço do primeiro registrador a ser lido
    input [4:0] readReg2,        // Endereço do segundo registrador a ser lido
    input [4:0] writeReg,        // Endereço do registrador a ser escrito
    input [31:0] writeData,      // Dado a ser escrito no registrador
    output [31:0] readData1,     // Dado lido do primeiro registrador
    output [31:0] readData2      // Dado lido do segundo registrador
);
    reg [31:0] regFile [31:0];   // Banco de registradores com 32 registradores de 32 bits

    // Inicializar registradores (opcional para simulação)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) regFile[i] = 0; // Inicializa todos os registradores com zero
    end

    // Leitura dos registradores
    assign readData1 = regFile[readReg1];
    assign readData2 = regFile[readReg2];

    // Escrita no registrador (sincronizada com o clock)
    always @(posedge clk) begin
        if (RegWrite) regFile[writeReg] <= writeData; // Escreve no registrador se RegWrite estiver ativo
    end
endmodule

// Controle da ALU (Unidade de Controle da ALU)
module ALUControl(
    input [1:0] ALUOp,           // Sinal de controle da ALU (vem da unidade de controle principal)
    input [5:0] funct,           // Campo funct da instrução (usado para instruções do tipo R)
    output reg [3:0] alu_control // Sinal de controle para a ALU
);
    always @(*) begin
        case (ALUOp)
            2'b00: alu_control = 4'b0010; // LW/SW: operação de ADD (soma)
            2'b01: alu_control = 4'b0110; // BEQ: operação de SUB (subtração)
            2'b10: begin
                case (funct)
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    6'b101010: alu_control = 4'b0111; // SLT
                    default: alu_control = 4'b0000; // Caso padrão
                endcase
            end
            default: alu_control = 4'b0000; // Caso padrão
        endcase
    end
endmodule