// Unidade de Controle
module ControlUnit(
    input [5:0] opcode,          // Campo opcode da instrução
    output reg RegDst,           // Sinal para selecionar o registrador de destino
    output reg ALUSrc,           // Sinal para selecionar a fonte do segundo operando da ALU
    output reg MemtoReg,         // Sinal para selecionar a fonte do dado a ser escrito no registrador
    output reg RegWrite,         // Sinal para habilitar escrita no banco de registradores
    output reg MemRead,          // Sinal para habilitar leitura da memória de dados
    output reg MemWrite,         // Sinal para habilitar escrita na memória de dados
    output reg Branch,           // Sinal para habilitar o desvio condicional (BEQ)
    output reg Jump,             // Sinal para habilitar o salto incondicional (JUMP)
    output reg [1:0] ALUOp       // Sinal de controle para a ALU
);
    always @(*) begin
        case (opcode)
            6'b000000: begin // Instrução do tipo R
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b10;
            end
            6'b100011: begin // LW (Load Word)
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead = 1;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b00;
            end
            6'b101011: begin // SW (Store Word)
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 1;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b00;
            end
            6'b000100: begin // BEQ (Branch if Equal)
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;
                Jump = 0;
                ALUOp = 2'b01;
            end
            6'b000010: begin // JUMP
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 1;
                ALUOp = 2'b00;
            end
            default: begin // Caso padrão
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b00;
            end
        endcase
    end
endmodule