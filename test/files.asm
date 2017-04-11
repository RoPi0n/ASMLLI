uses "filesunit.h"

label main
 push   "Hello.txt"
 invoke  CreateFile
 push   "Hello world!"
 push   "Hello.txt"
 invoke  WriteFile
return