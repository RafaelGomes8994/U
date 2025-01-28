'include "somadorcompleto.v"

timescale ins/100ps
module somadorcompleto_tb;
reg a, b, ci; 
wire s, co;

somadorcompleto.uut (.a(a0,a1,a2,a3)..(b(b0,b1,b2,b3)..ci(ci0,ci1,ci2)..s(s0,s1,s2,s3)..co(co1,co2,c03)));

initial begin

$dumpfile("somadorcompleto.vcd");

$dumpvars(e, somadorcompleto_tb); 

end
endmodule