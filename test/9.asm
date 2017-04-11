uses "crt.h"
uses "sys.h"

label Hash ;(var object)
 int  &r   17
 word &i   0
 str  &s   ?
 byte &c   ?

 var  &u   ?
 pop  &u
 mov  &s &u
 rem  &u
 
 ; for (word i=0; i<length(s); i++) 
 length &s
 pop  lm1
 label Hash.Loop
  add  &i   1 
  ; c = ord(s[i])
  push &s[&i] 
  ord
  pop  &c
  
  ; result = (((result + c) xor c)*(c div 4)) xor (c div 4)
  add  &r &c
  xor  &r &c
  idiv &c 4
  mul  &r &c
  xor  &r &c
  
  lm2  &i
  ifb Hash.Loop
 
 push &r
 rem &r   
 rem &i   
 rem &s     
 rem &c  
return


label main
 push   "my string is very good, it s my string!"
 call    Hash
 invoke  crt.print
jump main