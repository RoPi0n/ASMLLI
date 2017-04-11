uses "crt.h"

label main
 var     a ?
 mov     a 1010b
 push    a
 invoke  crt.print

 mov     a " string "
 push    a
 invoke  crt.print
 
 mov     a 3.14
 push    a
 invoke  crt.print
 
 char    c "f"
 mov     a c
 rem     c
 push    a
 invoke  crt.print
return