uses "sys.h"
uses "threads.h"
uses "crt.h"

label main
 AsyncThread  MyThr
 mov     MyThr.PRunProc @MyThreadProc
 call    MyThr:Create
 call    MyThr:Resume
 push    1
 invoke  sleep
 call    MyThr:Destroy
 invoke  halt
return

label MyThreadProc
 push " loop "
 invoke crt.print
jump MyThreadProc
