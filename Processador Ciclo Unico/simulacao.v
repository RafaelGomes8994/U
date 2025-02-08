`timescale 1ns / 1ps

module SingleCycleMIPS_Simulation;

    // Entradas da simulação
    reg clk;
    reg rst;

    // Fios de saída do processador
    wire [31:0] pc;
    wire [31:0] instruction;

    // Instância da memória de instruções
    InstructionMemory inst_mem (
        .address(pc),
        .instruction(instruction)
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

        // Aguarda a execução das 3 instruções
        #60; // 6 ciclos de clock (3 instruções x 2 ciclos por instrução)

        // Verifica os resultados
        $display("Simulação concluída.");
        $display("Valor final do PC: %h", pc);

        // Finaliza a simulação
        $finish;
    end

    // Monitoramento do PC e da instrução
    initial begin
        $monitor("Tempo: %0d | PC: %h | Instrução: %h", 
                 $time, 
                 pc, 
                 instruction);
    end

    // Instância do PC (Program Counter)
    reg [31:0] pc_reg;
    assign pc = pc_reg;

    // Lógica do PC
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 32'b0; // Reset do PC
        end else begin
            pc_reg <= pc_reg + 4; // Incrementa o PC em 4 a cada ciclo
        end
    end
endmodule