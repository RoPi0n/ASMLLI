uses "crt.h"

define proc ptr

struct ScreenBuffer
 word width  ?
 word height ?
 proc create @ScreenBuffer.create
end

label ScreenBuffer.create
 
return


label main
 ScreenBuffer sb
 call sb:create
end