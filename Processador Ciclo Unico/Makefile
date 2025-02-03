# Nome do arquivo de saída
EXE = sim.vvp

# Arquivos Verilog
SRC = AluAndRegistradores.v UnidadeDeControle.v Processador.v memory.v simulacao.v

# Arquivo de saída VCD
VCD = Processador.vcd

all: compile run view

compile:
	iverilog -o $(EXE) $(SRC)

run:
	vvp $(EXE)

view:
	gtkwave $(VCD)

clean:
	cmd /c del /F /Q $(EXE) $(VCD) 2>nul
