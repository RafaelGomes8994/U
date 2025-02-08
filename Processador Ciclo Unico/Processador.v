// Processador Principal (Single Cycle MIPS)
module Processador(
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
    wire [31:0] pc_plus4, branch_target, jump_target, pc_next_temp, write_data;
    wire [4:0] writeReg;
    wire [3:0] alu_control;
    wire zero, MemtoReg, MemRead, MemWrite, RegDst;
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

    // MUX para RegDst (seleção do registrador de escrita)
    MUX2to1 #(5) reg_dst_mux (
        .in0(instruction[20:16]), // rt
        .in1(instruction[15:11]), // rd
        .sel(RegDst),
        .out(writeReg)
    );

    // Banco de Registradores
    Registradores reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(writeReg),
        .writeData(write_data),
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

    // MUX para MemtoReg
    MUX2to1 mem_to_reg_mux (
        .in0(alu_result),
        .in1(mem_data),
        .sel(MemtoReg),
        .out(write_data)
    );

    // Cálculo do branch target
    assign branch_target = pc_plus4 + (sign_ext_imm << 2);

    // MUX para PCSrc
    MUX2to1 pc_src_mux (
        .in0(pc_plus4),
        .in1(branch_target),
        .sel(Branch & zero),
        .out(pc_next_temp)
    );

    // Cálculo do jump target
    assign jump_target = {pc_plus4[31:28], instruction[25:0] << 2};

    // MUX para Jump
    MUX2to1 jump_mux (
        .in0(pc_next_temp),
        .in1(jump_target),
        .sel(Jump),
        .out(next_pc)
    );

    // Cálculo de PC+4
    assign pc_plus4 = pc + 4;
endmodule