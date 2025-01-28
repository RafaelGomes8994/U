// Memória
module DataMemory(
    input clk, MemRead, MemWrite,
    input [31:0] address, writeData,
    output [31:0] readData
);
    reg [31:0] memory [0:255];

    assign readData = (MemRead) ? memory[address[7:0]] : 0;

    always @(posedge clk) begin
        if (MemWrite) memory[address[7:0]] <= writeData;
    end
endmodule
// PC
module PC(
    input clk, rst,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else
            pc <= next_pc;
    end
endmodule

// Memória de Instruções
module InstructionMemory(
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] memory [0:255];

    initial begin
        // Carregar instruções de exemplo (simulação)
        $readmemh("instructions.mem", memory);
    end

    assign instruction = memory[address[7:0]];
endmodule

// Extensão de Sinal
module SignExtend(
    input [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule
