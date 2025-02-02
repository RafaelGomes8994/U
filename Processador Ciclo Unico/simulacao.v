// Simulação do Processador MIPS de Ciclo Único
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

        // Simulação roda por um tempo fixo
        #200;

        // Finaliza a simulação
        $finish;
    end

    // Monitorar valores importantes
    initial begin
        $monitor("Tempo: %0d | PC: %h | Instrução: %h", $time, uut.pc_reg.pc, uut.inst_mem.instruction);
    end

    // Carregar instruções no arquivo de memória
    initial begin
        $readmemh("instructions.mem", uut.inst_mem.memory);
    end
    
endmodule
\end{lstlisting}