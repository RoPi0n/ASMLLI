uses "crt.h"

;count 1..10
label main
 byte    a   1  
 lm1     11
 label loop1
  push    a
  invoke  crt.print
  add     a   1
  lm2     a
  ifn     loop1
 invoke  halt
return