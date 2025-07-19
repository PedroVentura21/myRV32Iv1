addi s1, zero, 10 # Dado
addi sp, sp, -4   # Empilhar um dado (32 bits)
sw s1, 0(sp)      # Salva o dado na pilha
lw s2, 0(sp)      # Salva o dado da pilha no registrador