uses "crt.h"

label main
 byte    a   ?
 mov     a   1111b
 shl     a   4
 push    a   
 invoke  crt.print
return