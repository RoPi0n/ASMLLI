uses "crt.h"
uses "inc\math.asm"

label main
 push   3
 call   Gamma
 invoke crt.print
return