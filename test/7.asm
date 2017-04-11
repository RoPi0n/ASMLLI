uses "crt.h"

struct point
 int x ?
 int y ?
end

label main
 ;declarate point
 point   p
 ;init point
 mov p.x 10
 mov p.y 20
 ;out point
 push    p.y
 push    p.x
 invoke  crt.println
 invoke  crt.println
return