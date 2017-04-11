uses "crt.h"

label main
 push "What's your name? "
 invoke crt.println
 invoke crt.inputln
 str s "Hello, "
 str s2 ?
 pop s2
 add s s2
 rem s2
 push s
 rem s
 invoke crt.println
 invoke core.halt
return