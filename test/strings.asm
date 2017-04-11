uses "string.h"
uses "types.h"
uses "crt.h"

data str $s "this is sample string"
data str $s1 "sample"
data str $s2 "this is  string"

label main
 push s
 push 9
 push 6
 call str_copy
 invoke crt.println ; -> "sample"
 push s
 push s1
 call str_indexof
 invoke crt.println ; -> 9
 push s2
 push s1
 push 9
 call str_insert
 invoke crt.println ; -> "this is sample string"
 push s
 push 9
 push 7
 call str_delete
 invoke crt.println ; -> "this is string"
 push s
 push 9
 call str_left
 invoke crt.println ; -> "this is "
 push s
 push 13
 call str_right
 invoke crt.println ; -> "sample string"
return