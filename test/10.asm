uses "crt.h"

;example using arrays
label main
 byte    a   1  
 lm1     11
 label loopA
  byte    c[a]  a
  add     a     1
  lm2     a
  ifn     loopA
 mov      a     1
 lm1      11
 label loopB
  push    c[a]
  invoke  crt.print
  add     a     1
  lm2     a
  ifn     loopB
return