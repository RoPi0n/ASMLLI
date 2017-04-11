uses "sys.h"
uses "lfcr.h"
uses "threads.h"
uses "types.h"

data word form1           ?

label mainthread
  push   100
  invoke sleep

  ;push   "Hello"     ;Form caption
  ;push   vnCaption
  ;push   form1
  ;invoke layout.form.setvalue

  ;push   true
  ;push   vnVisible
  ;push   form1
  ;invoke layout.form.setvalue

  ;push   true
  ;push   vnShowInTaskBar
  ;push   form1
  ;invoke layout.form.setvalue

  ;push wsMaximized
  ;push vnWindowState
  ;push form1
  ;invoke layout.form.setvalue

  ;push   $FFFFFF    ;Background color
  ;push   vnColor
  ;push   form1
  ;invoke layout.form.setvalue

  byte    event   ?
  bool    dopaint false
  label loop
    push   form1
    invoke layout.form.waitforevent
    pop event
    lm1 event

    ;OnPaint
    lm2 fePaint
    ife block
     push 10
     push 100
     push "Hello, i'm LFCR form!"
     push fcTextOut
     push form1
     invoke layout.form.canvas
    end

    ;OnCloseQuery
    lm2 feCloseQuery
    ife block       
     invoke core.halt
    end

    ;OnMouseDown
    lm2 feMouseDown
    ife block
     mov dopaint true
    end

    ;OnMouseUp
    lm2 feMouseUp
    ife block
     mov dopaint false
    end

    ;OnMouseMove
    lm2 feMouseMove
    ife block
      int32   x ?
      int32   y ?
      push    0
      push    form1
      invoke  layout.form.getlasteventarg
      pop     x
      push    1
      push    form1
      invoke  layout.form.getlasteventarg
      pop     y

     lm1 dopaint
     lm2 true
     ifn blockelse
      push    x
      push    y
      push    fcLineTo
      push    form1
      invoke  layout.form.canvas
     label blockelse
      push    x
      push    y
      push    fcMoveTo
      push    form1
      invoke  layout.form.canvas
     rem     x
     rem     y
    end

  jump  loop
return


label main
  AsyncThread  mainthr
  mov mainthr.PRunProc @mainthread
  call mainthr:create
  call mainthr:resume
  invoke layout.initialize
  invoke layout.form.create
  peek   form1
  invoke layout.run
return
