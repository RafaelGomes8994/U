`timescale 1ns / 1ps

module SingleCycleMIPS_Simulation;

    // Entradas da simulação
    reg clk;
    reg rst;

    // Fios de saída do processador
    wire [31:0] pc;
    wire [31:0] instruction;
    wire RegWrite, ALUSrc, Branch, Jump;

    reg [31:0] regBankState [31:0];

    integer iterator;
    integer iterator2;

    // Instância do processador
    SingleCycleMIPS uut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump)
    );

    // Gerador de clock
    initial begin
        // Inicializar reset
        clk = 0;
        rst = 1;
        #10; // Espera 10 ns
        rst = 0;

        $dumpfile("Processador.vcd");
        $dumpvars();

        for (iterator2 = 0; iterator2 < 32; iterator2 = iterator2 + 1) begin
            $dumpvars(1, regBankState[iterator2]);
        end
 
        repeat(20) #5 clk = ~clk; // Clock com período de 10 ns
    end

    // Monitoramento do PC e da instrução
    initial begin
        $monitor("Tempo: %0d | PC: %h | Instrução: %h | RegWrite: %b | ALUSrc: %b | Branch: %b | Jump: %b", 
                 $time, 
                 pc, 
                 instruction,
                 RegWrite,
                 ALUSrc,
                 Branch,
                 Jump);
    end

    // Monitoramento dos registradores
    initial begin
        $monitor("Tempo: %0d | $t0: %h | $t1: %h | $t2: %h | $t3: %h | $t7: %h | $t8: %h | $t9: %h | $s0: %h | $s1: %h", 
                 $time, 
                 uut.reg_file.regFile[8],  // $t0
                 uut.reg_file.regFile[9],  // $t1
                 uut.reg_file.regFile[10], // $t2
                 uut.reg_file.regFile[11], // $t3
                 uut.reg_file.regFile[15], // $t7
                 uut.reg_file.regFile[24], // $t8
                 uut.reg_file.regFile[25], // $t9
                 uut.reg_file.regFile[16], // $s0
                 uut.reg_file.regFile[17]  // $s1
                );
    end

    // Monitoramento da memória
    initial begin
        $monitor("Tempo: %0d | Mem[0x10010010]: %h", 
                 $time, 
                 uut.data_mem.memory[16]); // Endereço 0x10010010
    end

    // Carregar o arquivo de memória de instruções
    initial begin
        $readmemb("Test.mem", uut.inst_mem.memory);
        $display("Arquivo Teste.mem carregado com sucesso!");
    end


    always @(posedge clk) begin
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            regBankState[iterator] = SingleCycleMIPS_Simulation.uut.reg_file.regFile[iterator];
        end
    end
endmodule