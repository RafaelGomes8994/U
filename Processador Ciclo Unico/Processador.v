// Processador Principal (Single Cycle MIPS)
module SingleCycleMIPS(
    input clk,                   // Sinal de clock
    input rst,                   // Sinal de reset
    output [31:0] pc,            // Program Counter
    output [31:0] instruction,   // Instrução atual
    output RegWrite,             // Sinal de escrita no registrador
    output ALUSrc,               // Sinal de seleção da fonte do segundo operando da ALU
    output Branch,               // Sinal de desvio condicional
    output Jump                  // Sinal de salto incondicional
);
    // Fios (conexões internas)
    wire [31:0] next_pc, readData1, readData2, alu_result, mem_data, sign_ext_imm;
    wire [4:0] writeReg;
    wire [3:0] alu_control;
    wire zero, MemtoReg, MemRead, MemWrite;
    wire [1:0] ALUOp;

    // Instâncias dos módulos

    // PC (Program Counter)
    PC pc_reg(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Memória de Instruções
    InstructionMemory inst_mem(
        .address(pc),
        .instruction(instruction)
    );

    // Unidade de Controle
    ControlUnit control(
        .opcode(instruction[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // Banco de Registradores
    Registradores reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(writeReg),
        .writeData((MemtoReg) ? mem_data : alu_result),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Extensão de Sinal
    SignExtend sign_ext(
        .in(instruction[15:0]),
        .out(sign_ext_imm)
    );

    // Controle da ALU
    ALUControl alu_ctrl(
        .ALUOp(ALUOp),
        .funct(instruction[5:0]),
        .alu_control(alu_control)
    );

    // ALU (Unidade Lógica e Aritmética)
    ALU alu(
        .input1(readData1),
        .input2(ALUSrc ? sign_ext_imm : readData2),
        .ALUControl(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // Memória de Dados
    DataMemory data_mem(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_result),
        .writeData(readData2),
        .readData(mem_data)
    );

    // Lógica para selecionar o registrador de escrita
    assign writeReg = RegDst ? instruction[15:11] : instruction[20:16];

    // Lógica para calcular o próximo PC
    wire [31:0] jump_address = {pc[31:28], instruction[25:0], 2'b00}; // Calcula o endereço de JUMP
    assign next_pc = Jump ? jump_address : (Branch & zero) ? pc + 4 + (sign_ext_imm << 2) : pc + 4;
endmodule