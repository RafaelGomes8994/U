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

// PC (Program Counter)
module PC(
    input clk,                   // Sinal de clock
    input rst,                   // Sinal de reset
    input [31:0] next_pc,        // Próximo valor do PC
    output reg [31:0] pc         // Valor atual do PC
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0; // Reseta o PC para zero se o sinal de reset estiver ativo
        else
            pc <= next_pc; // Atualiza o PC com o próximo valor
    end
endmodule

// Memória de Instruções
module InstructionMemory(
    input [31:0] address,        // Endereço da instrução
    output [31:0] instruction    // Instrução lida
);
    reg [31:0] memory [0:255];   // Memória de instruções com 256 posições de 32 bits
    
    initial begin
        // Carregar instruções de exemplo (simulação)
        $readmemh("Test.mem", memory); // Carrega as instruções de um arquivo
    end

    // Leitura da memória de instruções
    assign instruction = memory[address[7:0]];
endmodule

// Extensão de Sinal
module SignExtend(
    input [15:0] in,             // Entrada de 16 bits
    output [31:0] out            // Saída de 32 bits com extensão de sinal
);
    assign out = {{16{in[15]}}, in}; // Estende o sinal do bit mais significativo
endmodule   