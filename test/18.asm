uses "crt.h"

label recFunc
 int  &i ?
 pop  &i
 lm1  10
 lm2  &i
 ife  recFunc.rec
 add  &i 1
 push &i
 rem  &i
 call recFunc
 label recFunc.rec
 push &i
 invoke crt.print
return

label main
 push 0
 call recFunc
return