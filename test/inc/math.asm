;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DASM math library.                                  ;
; Autor: Shyraev Pavel (c) 2016                       ;
; Library version: 1.0          m   m    a    t   h   ;
; OS:Crossplatform              mm mm   a a  ttt  h   ;
;                               m m m   aaa   t   hhh ;
; (i) Библиотека содержит       m   m  a   a  tt  h h ;
;     математические функции                          ;
;     для работы с целыми и                           ;
;     вещественными числами.                          ;
;                                                     ;
; (i) Функции принимают параметры                     ;
;     из стека в обратном порядке.                    ;
;                                                     ;
; (i) Используется работа со стеком DASM,             ;
;     а также с вынесением блока памяти на 2 план и   ;
;     чтение вынесенной памяти.                       ;
;     Это нужно, что бы не вызвать перегрузку         ;
;     переменных и ошибку чтения/записи памяти.       ;
;                                                     ;
; (i) Переменные объявленные после оператора data     ;
;     доступны для чтения/записи из любого участка    ;
;     кода, а так же после очищения блока памяти, т.к.;
;     они хранятся в отдельном блоке памяти,          ;
;     как и стек. Память может быть освобождена       ;
;     оператором REM, и вынесена оператором           ;
;     MAKEPUBLIC.                                     ;
;                                                     ;
; [!] Некоторые функции выдают приближенные значения. ;
;                                                     ;
; (i) Некоторые функции транслированы с других языков ;
;     программирования, с java,c++,pascal и verilog   ;
;                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data float Math.pi          3.14159265358979
data float Math.e           2.71828182845904
data word  Math.ISqrt.loops 16

; Functions:
;
; Round(float):int
; Abs(float):float
; ISqrt(float):int
; Sqr(float):float
; Sin(float):float
; Cos(float):float
; Tg(float):float
; Ctg(float):float
; ILogN(float,float):float
; Exp(float):float
; Max(float,float):float
; Min(float,float):float
; Gamma(float):float
; Sqrt(float):float
; IFact(int):int
; Ln(float):float
; Log2(float):float
; Log10(float):float
; LogN(float,float):float
; Trunc(float):int
; Frac(float):int

label Trunc
 float Trunc.x new
 pop   Trunc.x
 Lm1   Trunc.x
 idiv  Trunc.x 1
 Lm2   Trunc.x
 ifS   Trunc.sub
 push  Trunc.x
 rem   Trunc.x
 return
 label Trunc.sub
 sub   Trunc.x 1
 push  Trunc.x
 rem   Trunc.x
return

label Frac
 float  Frac.x new
 int    Frac.y new
 pop    Frac.x
 push   Frac.x
 call   Trunc
 pop    Frac.y
 sub    Frac.x Frac.y
 push   Frac.x
 rem    Frac.x
 rem    Frac.y
return

label Round ;Round(float):int
 push  memory
 rem   memory
 ;Return Trunc(float+0.5)
 float f       new
 pop   f
 add   f       0.5
 push  f
 call  Trunc
 pop   memory
return

label Abs ;Abs(float):float
 push  memory
 rem   memory
 float f new
 pop   f
 lm1   0
 lm2   f
 ifb   Abs.multiply   
 push  f
 pop   memory
 return
 label Abs.multiply
 mul   f -1
 push  f
 pop   memory
return

label ISqrt ;ISqrt(float):int;
 float  ISqrt.a    new
 float  ISqrt.b    new
 float  ISqrt.c    new
 pop    ISqrt.a
 mov    ISqrt.c    ISqrt.a
 div    ISqrt.c    3
 add    ISqrt.c    3
 shr    ISqrt.c    1
 mov    ISqrt.b    ISqrt.c 
 word   ISqrt.i    new
 lm1    Math.ISqrt.loops
 label  ISqrt.loop
 mov    ISqrt.c    ISqrt.a
 div    ISqrt.c    ISqrt.b
 add    ISqrt.c    ISqrt.b
 shr    ISqrt.c    1
 mov    ISqrt.b    ISqrt.c 
 add    ISqrt.i    1
 lm2    ISqrt.i
 ifn    ISqrt.loop 
 push   ISqrt.b
 rem    ISqrt.a
 rem    ISqrt.b
 rem    ISqrt.c
 rem    ISqrt.i
return

label Sqr ;Sqr(float):float
 float Sqr.buf new
 pop   Sqr.buf
 pow   Sqr.buf 2
 push  Sqr.buf
 rem   Sqr.buf
return

label Sin ;Sin(float):float
 push  memory
 rem   memory
 float x    new
 float x1   new
 float y    new
 float y1   new
 float y2   new
 float y3   new
 float y4   new
 float y5   new
 float y6   new
 float y7   new
 float sum  new
 float sign 1.0
 float buf  new
 pop   x
 mov   x1   x
 lm1   x1
 lm2   0
 ifs   ISin.then
 jump  ISin.continue
 label ISin.then
 push  x1
 call  Abs
 pop   x1
 mov   sign -1.0
 label ISin.continue
 mov   buf  3.14159265
 div   buf  2.0
 lm2   buf
 jump  ISin.gowhile
 label ISin.while
 sub   x1   3.14159265
 mul   sign -1.0
 label ISin.gowhile
 lm1   x1
 ifb   ISin.while
 mov   buf  x1
 mul   buf  2
 div   buf  3.14159265
 mov   y    buf
 mov   y2   y
 mul   y2   y
 mov   y3   y
 mul   y3   y2
 mov   y5   y3
 mul   y5   y2
 mov   y7   y5
 mul   y7   y2
 mov   buf  1.570794
 mul   buf  y
 mov   sum  buf
 mov   buf  0.645962
 mul   buf  y3
 sub   sum  buf
 mov   buf  0.079692
 mul   buf  y5
 add   sum  buf
 mov   buf  0.0046811712
 mul   buf  y7
 sub   sum  buf
 mov   buf  sign
 mul   buf  sum
 push  buf 
 pop   memory
return

label Cos ;Cos(float):float
 push  memory
 rem   memory
 float x   new
 float buf new
 pop   x
 mov   buf 3.14159265
 div   buf 2.0
 add   x   buf
 push  x
 call  Sin
 pop   x
 push  x
 pop   memory
return

label Tg ;Tg(float):float
 float Tg.a new
 float Tg.b new
 pop   Tg.a
 mov   Tg.b Tg.a
 push  Tg.a
 push  Tg.b
 call  Cos
 pop   Tg.b
 call  Sin
 pop   Tg.a
 div   Tg.a Tg.b
 push  Tg.a
 rem   Tg.a
 rem   Tg.b
return

label Ctg ;Ctg(float):float
 float Ctg.a new
 float Ctg.b new
 pop   Ctg.a
 mov   Ctg.b Ctg.a
 push  Ctg.a
 push  Ctg.b
 call  Cos
 pop   Ctg.b
 call  Sin
 pop   Ctg.a
 div   Ctg.b Ctg.a
 push  Ctg.a
 rem   Ctg.a
 rem   Ctg.b
return

label ILogN ;ILogN(float a,float n):int
 push  memory
 rem   memory
 float a  new
 float n  new
 int   i  new
 int   i1 new
 int   r  new
 pop   n
 pop   a
 lm2   a
 jump  ILogN.loop.start
 label ILogN.loop
 mov   r    i
 add   r    1
 add   i    1
 label ILogN.loop.start
 mov   i1   i
 pow   i1   n
 lm1   i1
 ifs   ILogN.loop
 push  r
 pop  memory
return

label Exp ;Exp(float):float
 push  Memory
 rem   Memory
 ;exp(x)=e^x
 float Exp.a Math.e
 float Exp.b new
 pop   Exp.b
 pow   Exp.a Exp.b
 push  Exp.a
 pop   Memory
return

label Max ;Max(float a,float b):float
 push  Memory
 rem   Memory
 float a new
 float b new
 pop   a
 pop   b
 lm1   a
 lm2   b
 ifb   Max.returnA   ;if (a>b) or (a=b) then return a
 ife   Max.returnA   ;else return b;
 push  b             
 pop   Memory
 return
 label Max.returnA
 push  a
 pop   Memory
 return

label Min ;Min(float a,float b):float
 float &a new
 float &b new
 pop   &a
 pop   &b
 lm1   &a
 lm2   &b
 ifs   Min.returnA   ;if (a<b) or (a=b) then return a
 ife   Min.returnA   ;else return b;
 push  &b             
 rem   &a
 rem   &b
return
 label Min.returnA
 push  &a
 rem   &a
 rem   &b
return

label Gamma ;Gamma(float):float
 float &n    new
 float &buf1 new
 float &buf2 new
 float &buf3 new
 float &buf  new
 pop   &n
 mov   &buf1 &n
 mul   &buf1 Math.pi
 mul   &buf1 2
 pow   &buf1 0.5
 mov   &buf2 &n
 pow   &buf2 &n
 mov   &buf3 Math.e
 sub   &buf  &n
 pow   &buf3 &buf
 mul   &buf2 &buf3
 mul   &buf1 &buf2
 push  &buf1
 rem   &n
 rem   &buf
 rem   &buf1
 rem   &buf2
 rem   &buf3
return

label Sqrt ;Sqrt(float):float;
 float  &a new
 pop    &a
 pow    &a 0.5
 push   &a
 rem    &a
return

label IFact ;IFact(int):int
  int    &n  new
  pop    &n
  int    &r  1
  int    &i  1
  lm2    &n
  label  ifact.loop
  mul    &r &i
  add    &i  1
  lm1    &i
  ifs    ifact.loop
  ife    ifact.loop
  push   &r
  rem    &n
  rem    &r
  rem    &i
return

label Ln ;Ln(float):float
 float &x0  new
 float &x   new
 float &y   new
 float &a   new
 float &b   new
 float &buf new
 pop   &x0
 mov   &a   &x0
 add   &a   1
 mov   &b   Math.e
 int   &n   1
 float &sn  1
 label ln.whileloop
 mov   &buf 1
 pow   &buf -16
 mul   &buf &n
 lm1   &sn
 lm2   &buf
 ifs   ln.loopexit ;while(sn>(1E-16)*n)
 mov   &buf  &b
 sub   &buf  1
 mul   &sn  -1
 mul   &sn   &buf
 mov   &buf  &sn
 div   &buf  &n
 add   &y    &buf
 add   &n  1
 jump  ln.whileloop
 label ln.loopexit
 mul   &a   2.302585092994046
 add   &y   &a
 push  &y
 rem   &x0  
 rem   &x   
 rem   &y   
 rem   &a   
 rem   &b    
 rem   &buf
return

label Log2 ;Log2(float):float
 push 2
 jump LogN

label Log10 ;Log10(float):float
 push 10
 jump LogN

label LogN ;LogN(float,float):float
 float &b new
 float &a new
 call  ln
 pop   &b
 call  ln
 pop   &a
 div   &a &b
 push  &a
 rem   &a
 rem   &b
return