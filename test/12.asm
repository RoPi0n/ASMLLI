uses "crt.h"

;string -> array of char
label main
 str  s   "My string"
 byte i   1
 byte len ?
 char c   ?

 length s
 pop  len
 add  len 1  
 lm1  len   
 label    main.loop.a
  mov      c      s[i]
  char     a[i]   c
  add      i      1
  lm2      i
 ifn      main.loop.a
 mov       i      1
 label    main.loop.b
  push     a[i]
  invoke   crt.print
  add      i      1
  lm2      i
 ifn      main.loop.b
return