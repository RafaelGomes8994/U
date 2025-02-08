// PC (Program Counter)
module PC(
    input clk,                   // Sinal de clock
    input rst,                   // Sinal de reset
    input [31:0] next_pc,        // Próximo valor do PC
    output reg [31:0] pc         // Valor atual do PC
);
    always @(posedge clk, posedge rst) begin

        if (rst)
            pc <= 32'b0; // Reseta o PC para zero se o sinal de reset estiver ativo
        else
            pc <= next_pc; // Reseta o PC para zero se o sinal de reset estiver ativo
    end
    
endmodule
