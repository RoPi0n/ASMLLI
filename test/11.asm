uses "crt.h"

label main
 byte i ?
 lm1  3
 label    main.loop.a
  byte     a[i]   i
  add      i      1
  lm2      i
 ifn      main.loop.a
 mov       i      0
 label    main.loop.b
  push     a[i]
  invoke   crt.print
  add      i      1
  lm2      i
 ifn      main.loop.b
return