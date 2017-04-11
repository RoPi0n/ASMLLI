uses "crt.h"

struct MyClass
 ptr   proc1  @MyClass.proc1
 ptr   proc2  @MyClass.proc2
 int   x       ?
end

label MyClass.proc1
 ptr  &self ?
 pop @&self
 mov  &self*.x  10
 rem  &self
return

label MyClass.proc2
 ptr  &self ?
 pop @&self
 add  &self*.x  10
 rem  &self
return

label Main
 MyClass obj
 call    obj:proc1
 call    obj:proc2
 push    obj.x
 invoke  crt.print
return