// Memória de Instruções
module InstructionMemory(
    input [31:0] address,        // Endereço da instrução
    output [31:0] instruction    // Instrução lida
);
    reg [31:0] memory [0:255];   // Memória de instruções com 256 posições de 32 bits
    initial begin
        // Carregar instruções de exemplo (simulação)
       // $readmemh("Test.mem", memory); // Carrega as instruções de um arquivo
        memory[0] = 32'b000000_00000_00000000000000000100; // Instrução 0
        memory[1] = 32'b000000_00000_00000000000000000001; // Instrução 1
        memory[2] = 32'b000000_00000_00000000000000000010; // Instrução 2
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