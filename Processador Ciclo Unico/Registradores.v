// Registradores (Banco de Registradores)''
module Registradores(
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
