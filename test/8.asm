uses "crt.h"

label main
 int    a[1][2]   3
 int    x         1
 int    y         2
 
 push   a[x][y]
 invoke crt.print
return