uses "sys.h"

label main
 thread t1
 jump   t2
return

label t1
 push   1
 invoke cout
jump t1

label t2
 push   2
 invoke cout
jump t2