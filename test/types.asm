uses "crt.h"

struct _A
 int x 10
end

struct _B
 _A A
end

struct _C
 _B B
end

label main
 _C C
 push C.B.A.x
 invoke crt.print
return