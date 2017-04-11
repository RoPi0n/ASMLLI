;ASMLLI
;Autor: Pavel Shiriaev (c) 2017

uses "types.h"

label str_copy ; (str s; word from, len) -> str
 str &s ?
 word &from ?
 word &len  ?
 pop &len
 pop &from
 pop &s
 str &r ? ; <- #0
 add &len &from
 lm1 &len
 label str_copy.lp
  add &r &s[&from]
  inc &from
  lm2 &from
  ifb str_copy.lp
 push &r
 rem &r
 rem &s
 rem &len
 rem &from 
return



label str_left ; (str s; word l) -> str
 word &b ?
 pop &b
 push 1
 dec &b
 push &b
 call str_copy
 rem &b
return



label str_right ; (str s; word l) -> str
 str &s ?
 word &l ?
 word &b ?
 pop &b
 pop &s
 length &s
 pop &l
 sub &l &b
 inc &l
 push &s
 push &l
 push &b
 call str_copy
 rem &s
 rem &l
 rem &b
return



label str_reverse ; (str s) -> str
 str &s ?
 pop &s
 str &r ? ; <- #0
 word &i 0
 length &s
 pop &i
 lm1 0
 label str_reverse.lp
  add &r &s[&i]
  dec &i
  lm2 &i
  ifs str_reverse.lp
 push &r
 rem &s
 rem &r
 rem &i 
return



label str_indexof ; (str s, itm) -> word
 str &s ?
 str &itm ?
 pop &itm
 pop &s
 word &i 1
 label str_indexof.lp
  lm1 &s[&i]
  lm2 &itm[1]
  ife block
   push &s
   push &i
   length &itm
   call str_copy
   pop lm1
   lm2 &itm
   ife str_indexof.finded 
  end
  inc &i
  lm1 &i
  length &s
  pop lm2
  ifs str_indexof.lp
 jump str_indexof.not_finded
 label str_indexof.finded
  push &i
  jump str_indexof.end  
 label str_indexof.not_finded
  push false 
 label str_indexof.end
  rem &s
  rem &itm
  rem &i
return



label str_indexofnum ; (str s, itm; word n) -> word
 str &s ?
 str &itm ?
 word &n ?
 word &l ?
 pop &n
 pop &itm
 pop &s
 label str_indexofnum.lp
  push &s
  push &itm
  call str_indexof
  pop &l
  push &s
  push &l
  push &n
  length &s
  lm1 &n
  lm2 0
  ifb str_indexofnum.lp 
 rem &s
 rem &itm
 rem &n
 rem &l
return



label str_insert ; (str s,i; word p) -> str
 str &s ?
 str &i ?
 word &p ?
 pop &p
 pop &i
 pop &s
 push &s
 push &1
 dec &p
 push &p
 inc &p
 call str_copy
 word &l ?
 length &s
 pop &l
 inc &l
 sub &l &p
 push &s
 push &p
 push &l
 rem &l 
 call str_copy
 pop &s
 add &i &s
 pop &s
 add &s &i
 push &s
 rem &s
 rem &i
 rem &p
return



label str_concat ; (str s1,s2) -> str
 str &s1 ?
 str &s2 ?
 pop &s2
 pop &s1
 add &s1 &s2
 push &s1
 rem &s1
 rem &s2
return



label str_delete ; (str s; word from, cnt) -> str
 str &s ?
 word &from ?
 word &cnt ?
 pop &cnt
 pop &from
 pop &s
 push &s
 push 1
 dec &from
 push &from
 call str_copy
 inc &from
 add &from &cnt
 push &s
 push &from
 length &s
 pop &cnt
 sub &cnt &from
 inc &cnt
 push &cnt
 call str_copy
 rem &s
 rem &from
 rem &cnt
 call str_concat
return