uses "crt.h"

struct a
 int a ?
 int b ?
 inc r ?
end

struct b
 extends a
 ptr summ @b.summ
end

label b.summ
 ptr &self ?
 pop @&self
 mov &self*.r &self*.a
 add &self*.r &self*.b
 rem &self
return

struct c
 extends b
 prt test @c.test
end

label c.test
 ptr &self ?
 pop @&self
 mov &self*.a 10
 mov &self*.b 20
 call &self*:summ
return


label main
 c MyC
 call MyC:test
 push MyC.r
 invoke crt.print
return
