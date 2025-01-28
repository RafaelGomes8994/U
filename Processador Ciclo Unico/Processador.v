// Processador Principal
module SingleCycleMIPS(
    input clk, rst
);
    // Fios
    wire [31:0] pc, next_pc, instruction, readData1, readData2, alu_result, mem_data, sign_ext_imm;
    wire [4:0] writeReg;
    wire [3:0] alu_control;
    wire zero, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [1:0] ALUOp;

    // Instâncias
    PC pc_reg(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    InstructionMemory inst_mem(
        .address(pc),
        .instruction(instruction)
    );

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

    Registers reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(writeReg),
        .writeData(mem_data),
        .readData1(readData1),
        .readData2(readData2)
    );

    SignExtend sign_ext(
        .in(instruction[15:0]),
        .out(sign_ext_imm)
    );

    ALUControl alu_ctrl(
        .ALUOp(ALUOp),
        .funct(instruction[5:0]),
        .alu_control(alu_control)
    );

    ALU alu(
        .input1(readData1),
        .input2(ALUSrc ? sign_ext_imm : readData2),
        .ALUControl(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    DataMemory data_mem(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_result),
        .writeData(readData2),
        .readData(mem_data)
    );

    assign writeReg = RegDst ? instruction[15:11] : instruction[20:16];
    assign next_pc = (Branch & zero) ? pc + 4 + (sign_ext_imm << 2) : pc + 4;
endmodule