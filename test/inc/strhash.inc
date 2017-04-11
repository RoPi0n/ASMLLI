local label StrHash ;(str s)
 int  r   17
 int  len new
 int  i   0
 str  s   new
 char c   new
 int  ch  new

 pop  s
 push s
 invoke   strlen
 pop  len
 label StrHash.loop
  add  i   1
  push s
  push i
  invoke strcharat
  pop  c
  push c
  invoke ord
  pop  ch

  mul  r  37
  add  r  i
  mul  ch i
  idiv ch 2
  add  ch 3
  add  r  ch
  pow  r  2

  lm1  len
  lm2  i
  ifb StrHash.loop
 push r
return local

local label ObjHash ;(var Object)
 uval u new
 str  s new
 pop  u
 mov  s u
 push s
 call StrHash
return local