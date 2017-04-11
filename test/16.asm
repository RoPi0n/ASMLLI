uses "crt.h"

label OutArray
 ptr  &a   ?  
 int  &i   0 
 pop  @&a
 length &a*
 pop  lm1
 label OutArray.loop
  push  " "
  push  &a*[&i]
  invoke crt.print
  invoke crt.print
  add   &i  1
  lm2   &i
 ifn   OutArray.loop
return

label main
 int  i   ?
 lm1  10
 label loop1
  byte a[i] i
  add  i 1
  lm2  i
 ifn  loop1
 rem  i
 push   @a
 push "byte a[] = "
 invoke crt.print
 call   outarray
return