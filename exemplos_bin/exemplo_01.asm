  addi s1, zero, 10
  addi s2, zero, 11
  bne s1,s2, teste1
  nop
teste1:
  addi s2, zero, 10
  beq s1,s2, exit 
  nop
exit:
  add s1, s1, s2