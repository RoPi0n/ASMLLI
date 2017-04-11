uses "crt.h"
uses "types.h"
uses "classes.h"

label main
 TList lst
 int a 1
 int b 2
 int c 3
 push @a
 call lst:_add
 push @b
 call lst:_add
 push @c
 call lst:_add
 ptr p ?
 push 1
 call lst:_get
 call lst:_free
 rem lst
 pop p
 push p*
 invoke crt.print
return