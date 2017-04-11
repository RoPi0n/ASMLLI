; ASMLLI
; Autor: Shiriaev Pavel

struct AsyncThread
  int    ThreadID   ?
  ptr    PRunProc   ?
  ptr    Create    @AsyncThread.Create
  ptr    Suspend   @AsyncThread.Suspend
  ptr    Resume    @AsyncThread.Resume
  ptr    Destroy   @AsyncThread.Destroy
  ptr    WaitFor   @AsyncThread.WaitFor
end

label AsyncThread.Create
 ptr     &p  ?
 pop    @&p
 thrc    &p*.PRunProc*
 pop     &p*.ThreadID
 rem     &p
return

label AsyncThread.Suspend
 ptr     &p  ?
 pop    @&p
 push    &p*.ThreadID
 thrs
 rem     &p
return

label AsyncThread.Resume
 ptr     &p  ?
 pop    @&p
 push    &p*.ThreadID
 thrr
 rem     &p
return

label AsyncThread.Destroy
 ptr     &p  ?
 pop    @&p
 push    &p*.ThreadID
 thrt
 rem     &p
return

label AsyncThread.WaitFor
 ptr     &p  ?
 pop    @&p
 push    &p*.ThreadID
 thrw
 rem     &p
return