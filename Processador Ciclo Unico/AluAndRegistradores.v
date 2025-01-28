// ALU
module ALU(
    input [31:0] input1, input2,
    input [3:0] ALUControl,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (ALUControl)
            4'b0010: result = input1 + input2; // ADD
            4'b0110: result = input1 - input2; // SUB
            4'b0000: result = input1 & input2; // AND
            4'b0001: result = input1 | input2; // OR
            4'b0111: result = (input1 < input2) ? 1 : 0; // SLT
            default: result = 0;
        endcase
        zero = (result == 0) ? 1 : 0;
    end
endmodule

// Registradores
module Registers(
    input clk, RegWrite,
    input [4:0] readReg1, readReg2, writeReg,
    input [31:0] writeData,
    output [31:0] readData1, readData2
);
    reg [31:0] regFile [31:0];

    // Inicializar registradores (opcional para simulação)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) regFile[i] = 0;
    end

    assign readData1 = regFile[readReg1];
    assign readData2 = regFile[readReg2];

    always @(posedge clk) begin
        if (RegWrite) regFile[writeReg] <= writeData;
    end
endmodule

// Controle da ALU
module ALUControl(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [3:0] alu_control
);
    always @(*) begin
        case (ALUOp)
            2'b00: alu_control = 4'b0010; // LW/SW (ADD)
            2'b01: alu_control = 4'b0110; // BEQ (SUB)
            2'b10: begin
                case (funct)
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    6'b101010: alu_control = 4'b0111; // SLT
                    default: alu_control = 4'b0000;
                endcase
            end
            default: alu_control = 4'b0000;
        endcase
    end
endmodule


