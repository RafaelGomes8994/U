// PC (Program Counter)
module PC(
    input clk,                   // Sinal de clock
    input rst,                   // Sinal de reset
    input [31:0] next_pc,        // Próximo valor do PC
    output reg [31:0] pc         // Valor atual do PC
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0; // Reseta o PC para zero se o sinal de reset estiver ativo
        else
            pc <= next_pc; // Atualiza o PC com o próximo valor
    end
endmodule
