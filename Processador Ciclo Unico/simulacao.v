`timescale 1ns / 1ps

module SingleCycleMIPS_Simulation;

    // Entradas da simulação
    reg clk;
    reg rst;

    // Fios de saída do processador
    wire [31:0] pc;
    wire [31:0] instruction;

    // Instância do processador
    SingleCycleMIPS uut (
        .clk(clk),
        .rst(rst)
    );

    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock com período de 10 ns
    end

    // Inicialização e estímulos
    initial begin
        // Inicializar reset
        rst = 1;
        #10; // Espera 10 ns
        rst = 0;

        // Aguarda a execução do programa
        #500; // Aumentei o tempo de simulação para garantir que o programa termine

        // Verifica os resultados
        if (uut.reg_file.regFile[8] == 5 && 
            uut.reg_file.regFile[9] == 10 && 
            uut.reg_file.regFile[10] == 15 && 
            uut.reg_file.regFile[11] == 5 && 
            uut.reg_file.regFile[15] == 2 && 
            uut.reg_file.regFile[24] == 999 && 
            uut.reg_file.regFile[25] == 0 && 
            uut.reg_file.regFile[16] == 15 && 
            uut.reg_file.regFile[17] == 1) begin
            $display("Teste passou!");
        end else begin
            $display("Teste falhou!");
            $display("Valores dos registradores:");
            $display("$t0 (reg[8]): %h", uut.reg_file.regFile[8]);
            $display("$t1 (reg[9]): %h", uut.reg_file.regFile[9]);
            $display("$t2 (reg[10]): %h", uut.reg_file.regFile[10]);
            $display("$t3 (reg[11]): %h", uut.reg_file.regFile[11]);
            $display("$t7 (reg[15]): %h", uut.reg_file.regFile[15]);
            $display("$t8 (reg[24]): %h", uut.reg_file.regFile[24]);
            $display("$t9 (reg[25]): %h", uut.reg_file.regFile[25]);
            $display("$s0 (reg[16]): %h", uut.reg_file.regFile[16]);
            $display("$s1 (reg[17]): %h", uut.reg_file.regFile[17]);
        end

        // Finaliza a simulação
        $finish;
    end

    // Monitorar valores importantes
    initial begin
        $monitor("Tempo: %0d | PC: %h | Instrução: %h | $t0: %h | $t1: %h | $t2: %h | $t3: %h | $t7: %h | $t8: %h | $t9: %h | $s0: %h | $s1: %h", 
                 $time, 
                 uut.pc_reg.pc, 
                 uut.inst_mem.instruction,
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

    // Carregar instruções no arquivo de memória
    initial begin
        $readmemh("Teste.mem", uut.inst_mem.memory);
    end

endmodule