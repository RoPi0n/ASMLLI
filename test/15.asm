uses "crt.h"

;length array
label main
 ;len=10
 int  i   ?
 lm1  10
 label loop1
  byte a[i] ?
  add  i 1
  lm2  i
 ifn  loop1
 length a
 invoke crt.print
return