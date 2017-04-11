uses "crt.h"

label main
 byte a  10
 byte b  20
 
 lm1  a
 lm2  b
 
 ifs  block ;true
  push  "a<b"
  invoke crt.print
 end
 
 ifb  block ;false
  push  "error"
  invoke crt.print
 end
return