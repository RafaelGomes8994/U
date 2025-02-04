// Memória de Dados
module DataMemory(
    input clk,                   // Sinal de clock
    input MemRead,               // Sinal para habilitar leitura da memória
    input MemWrite,              // Sinal para habilitar escrita na memória
    input [31:0] address,        // Endereço de memória
    input [31:0] writeData,      // Dado a ser escrito na memória
    output [31:0] readData       // Dado lido da memória
);
    reg [31:0] memory [0:255];   // Memória com 256 posições de 32 bits

    // Leitura da memória
    assign readData = (MemRead) ? memory[address[7:0]] : 0; // Lê o dado se MemRead estiver ativo

    // Escrita na memória (sincronizada com o clock)
    always @(posedge clk) begin
        if (MemWrite) memory[address[7:0]] <= writeData; // Escreve na memória se MemWrite estiver ativo
    end
endmodule
