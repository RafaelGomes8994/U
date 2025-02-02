module testbench;
    reg clk, rst;
    wire [31:0] pc, instruction, readData1, readData2, alu_result, mem_data;

    // Instância do processador
    SingleCycleMIPS uut(
        .clk(clk),
        .rst(rst)
    );

    // Geração do clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Inicialização e reset
    initial begin
        rst = 1;
        #10;
        rst = 0;

        // Aguarda a execução do programa
        #100;

        // Verifica os resultados
        if (uut.reg_file.regFile[8] == 5 && uut.reg_file.regFile[9] == 10 && uut.reg_file.regFile[10] == 15)
            $display("Teste passou!");
        else
            $display("Teste falhou!");

        $finish;
    end
endmodule