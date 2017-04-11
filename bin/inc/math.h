; ASMLLI
; Autor: Shiriaev Pavel

import "math.dll"   "SIN"            math.sin
import "math.dll"   "COS"            math.cos
import "math.dll"   "TG"             math.tg
import "math.dll"   "CTG"            math.ctg
import "math.dll"   "ARCSIN"         math.arcsin
import "math.dll"   "ARCCOS"         math.arccos
import "math.dll"   "LOG10"          math.log10
import "math.dll"   "LOG2"           math.lg
import "math.dll"   "LOGN"           math.logn
import "math.dll"   "LNXP1"          math.lnxp1

label math.trunc
 float &x ?
 pop   &x
 Lm1   &x
 idiv  &x 1
 Lm2   &x
 ifS   math.trunc.sub
 push  &x
return
 label math.trunc.sub
 sub   &x 1
 push  &x
 rem   &x
return

label math.frac
 float  &x ?
 int    &y ?
 pop    &x
 push   &x
 call   math.trunc
 pop    &y
 sub    &x &y
 push   &x
 rem    &x
 rem    &y
return

label math.round
 float &f  ?
 pop   &f
 add   &f  0.5
 push  &f
 rem   &f
 jump  math.trunc

label math.abs
 float &f ?
 pop   &f
 lm1   0
 lm2   &f
 ifb   math.abs.multiply   
 push  &f
 rem   &f
return
 label math.abs.multiply
 mul   &f -1
 push  &f
 rem   &f
return

label math.sqr
 float &a ?
 pop   &a
 pow   &a 2
 push  &a
 rem   &a
return

label math.sqrt
 float  &a ?
 pop    &a
 pow    &a 0.5
 push   &a
 rem    &a
return