uses "crt.h"

label main
 int  a[1]   ?
 ptr  pa     ?
 push @a
 pop  @pa
 mov  pa*[1] 10
 push a[1]
 invoke crt.print
return
