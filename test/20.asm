uses "crt.h"

data int i ?

label main
 add    i 1
 push   i
 invoke crt.print
 push   " "
 invoke crt.print
jump  main