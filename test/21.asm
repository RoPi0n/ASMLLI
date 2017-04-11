uses "crt.h"

label MyObj.create
 pop @r14
 int  r14*.x  16
 int  r14*.y  20
return

label MyObj.destroy
 pop @r14
 rem  r14*.x
 rem  r14*.y
return

label main
 push "myobject"
 call  MyObj.create
 push  MyObject.x
 push  MyObject.y
 invoke crt.print
 invoke crt.print
return