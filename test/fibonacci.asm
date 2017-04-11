uses "crt.h"

label fibonacci
 int64 &v ?
 pop &v
 int64 &f 1
 int64 &s 1
 lm1 &v
 lm2 3
 ifs block
  push 1
  jump fibonacci.lbl_end
 end
 label fibonacci.lbl_while
 lm1 &v
 lm2 2
 ifb block
  add &f &s
  add &f &s
  push  &f
  push  &s
  mov &s &f
  pop &f
  sub &s &f
  pop &f
  sub &f &s
  sub &v 1
  jump fibonacci.lbl_while
 end
 push &s
 label fibonacci.lbl_end
 rem &v
 rem &f
 rem &s 
return


label main
 int64 i 1
 label lbl_for
 ;FOR START
  push i
  call fibonacci
  invoke crt.println
 ;FOR END
 add i 1
 lm1 i
 lm2 49
 ifn lbl_for  
return