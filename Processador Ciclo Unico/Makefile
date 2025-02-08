# Nome do arquivo de saída
EXE = sim.vvp

# Arquivos Verilog
SRC = AluControl.v Alu.v Registradores.v ControlUnit.v Processador.v InstructionMemory.v Pc.v DataMemory.v simulacao.v Mux2to1.v

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
