uses "crt.h"

record MyClass
  int a new
  ptr sqr @MyClass.sqr
end

label MyClass.sqr
 ptr MyClass.p new
 pop @MyClass.p
 pow MyClass.p*.a 2
 rem MyClass.p
return

label  main
  MyClass mc
  mov mc.a 10
  call mc:sqr
  push mc.a  
  invoke crt.print
return