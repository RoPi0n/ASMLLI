uses "crt.h"

label GetVarValueByName
 ptr  &p ?
 pop @&p
 push &p*
 rem  &p
return

label main
 int  MyVar 99
 push "myvar"
 call getvarvaluebyname
 invoke crt.print
return