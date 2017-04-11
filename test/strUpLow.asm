uses "sys.h"

label main
 str  s new
 invoke cReadLN
 peek s
 invoke StrUpper
 push s
 invoke StrLower
 invoke cOutLn
 invoke cOutLn
return