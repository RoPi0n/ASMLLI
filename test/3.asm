uses "crt.h"

label main
  int      a    ?
  int      buf  ? 
 ;a=2*3^2/(3^2-3)+2%10   
  mov      buf  3
  pow      buf  2
  mov      a    buf
  mul      a    2
  sub      buf  3
  div      a    buf
  mov      buf  2
  mod      buf  10 
  add      a    buf
  push     a
  invoke   crt.print
  rem      a
  rem      buf
return