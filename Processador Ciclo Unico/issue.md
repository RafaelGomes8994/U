# Descrição das Modificações

## Arquivo: simulacao.v

### Modificações:
1. Adição de fios (`wire`) para `RegWrite`, `ALUSrc`, `Branch` e `Jump`.
2. Conexão dos fios aos sinais correspondentes na instância do processador (`uut`).
3. Correção das referências aos registradores e memória dentro da instância do processador (`uut`).

### Razões:
- As modificações foram necessárias para corrigir os erros de ligação de sinais e referências internas na simulação. Os sinais `RegWrite`, `ALUSrc`, `Branch` e `Jump` precisavam ser conectados corretamente à instância do processador para monitoramento durante a simulação.

## Arquivo: Processador.v

### Modificações:
1. Adição de portas de saída (`output`) para `pc`, `instruction`, `RegWrite`, `ALUSrc`, `Branch` e `Jump`.

### Razões:
- As portas de saída foram adicionadas para expor os sinais internos do processador, permitindo que eles sejam monitorados na simulação (`simulacao.v`). Isso é essencial para verificar o comportamento do processador durante a execução das instruções.

## Arquivo: UnidadeDeControle.v

### Modificações:
Nenhuma modificação necessária.

### Razões:
- O arquivo `UnidadeDeControle.v` já estava correto e não necessitou de alterações.

## Arquivo: memory.v

### Modificações:
Nenhuma modificação necessária.

### Razões:
- O arquivo `memory.v` já estava correto e não necessitou de alterações.

## Arquivo: AluAndRegistradores.v

### Modificações:
Nenhuma modificação necessária.

### Razões:
- O arquivo `AluAndRegistradores.v` já estava correto e não necessitou de alterações.

# Conclusão

As modificações realizadas foram essenciais para corrigir os erros de ligação de sinais e referências internas na simulação do processador de ciclo único. Com essas mudanças, a simulação agora pode monitorar corretamente os sinais internos do processador, permitindo uma verificação mais precisa do seu comportamento.
