addi x9,  x0,  10       # x9 = 10
addi x18, x0,  11       # x18 = 11
bne  x9,  x18, lb1      # se x9 ≠ x18, salta para endereço 0x10
addi x0, x0, 0           
lb1: add  x9,  x9,  x9  # x9 = x9 + x9 (duplica x9)
jal  x1, lb2           # salta para 0x20, x1 = retorno (0x18)
addi x0, x0, 0
jal  x1, lb3           # salta para 0x28, x1 = retorno (0x24)
lb2: add  x19, x18, x18      # x19 = x18 + x18
jalr x0, x1, 0
lb3: addi x0, x0, 0