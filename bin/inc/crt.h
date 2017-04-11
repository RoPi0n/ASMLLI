; ASMLLI
; Autor: Shiriaev Pavel

import "crt.dll" "CURSORBIG"      Crt.CursorBig
import "crt.dll" "CURSOROFF"      Crt.CursorOff
import "crt.dll" "CURSORON"       Crt.CursorOn
import "crt.dll" "DELLINE"        Crt.DelLine
import "crt.dll" "GOTOXY32"       Crt.GotoXY32
import "crt.dll" "INSLINE"        Crt.InsLine
import "crt.dll" "KEYPRESSED"     Crt.KeyPressed
import "crt.dll" "READKEY"        Crt.ReadKey
import "crt.dll" "SOUND"          Crt.Sound
import "crt.dll" "WHEREX32"       Crt.WhereX32
import "crt.dll" "WHEREY32"       Crt.WhereY32
import "crt.dll" "WINDOW32"       Crt.Window32
import "crt.dll" "CLREOL"         Crt.ClrEOL
import "crt.dll" "CLRSCR"         Crt.ClrScr

import "crt.dll" "GETDIRECTVIDEO" Crt.GetDirectVideo
import "crt.dll" "GETLASTMODE"    Crt.GetLastMode
import "crt.dll" "GETTEXTATTR"    Crt.GetTextAttr
import "crt.dll" "GETWINDMAX"     Crt.GetWindMax
import "crt.dll" "GETWINDMAXX"    Crt.GetWindMaxX
import "crt.dll" "GETWINDMAXY"    Crt.GetWindMaxY
import "crt.dll" "GETWINDMIN"     Crt.GetWindMin
import "crt.dll" "GETWINDMINX"    Crt.GetWindMinX
import "crt.dll" "GETWINDMINY"    Crt.GetWindMinY
import "crt.dll" "GETCHECKBREAK"  Crt.GetCheckBreak
import "crt.dll" "GETCHECKEOF"    Crt.GetCheckEOF
import "crt.dll" "GETCHECKSNOW"   Crt.GetCheckSnow

import "crt.dll" "PRINT"          Crt.Print
import "crt.dll" "PRINTLN"        Crt.PrintLn
import "crt.dll" "PRINTFORMAT"    Crt.PrintFormat
import "crt.dll" "INPUT"          Crt.Input
import "crt.dll" "INPUTLN"        Crt.InputLn

; CRT modes 
data byte   $Crt.BW40           0            ; 40x25 B/W on Color Adapter 
data byte   $Crt.CO40           1            ; 40x25 Color on Color Adapter 
data byte   $Crt.BW80           2            ; 80x25 B/W on Color Adapter 
data byte   $Crt.CO80           3            ; 80x25 Color on Color Adapter 
data byte   $Crt.Mono           7            ; 80x25 on Monochrome Adapter 
data word   $Crt.Font8x8        256          ; Add-in for ROM font 

; Foreground and background color constants 
data byte   $Crt.Black          0
data byte   $Crt.Blue           1
data byte   $Crt.Green          2
data byte   $Crt.Cyan           3
data byte   $Crt.Red            4
data byte   $Crt.Magenta        5
data byte   $Crt.Brown          6
data byte   $Crt.LightGray      7

; Foreground color constants 
data byte   $Crt.DarkGray       8
data byte   $Crt.LightBlue      9
data byte   $Crt.LightGreen     10
data byte   $Crt.LightCyan      11
data byte   $Crt.LightRed       12
data byte   $Crt.LightMagenta   13
data byte   $Crt.Yellow         14
data byte   $Crt.White          15

; Add-in for blinking 
data byte   $Crt.Blink          128 

;Functions & procedures for work with CRT

data byte   Crt.TextAttr        $07

label Crt.TextColor
  byte &color ?
  byte &buf   ?
  pop  &color
  and  &color $8f
  mov  &buf   Crt.TextAttr
  and  &buf   $70
  or   &color buf
  mov  Crt.TextAttr &color
  rem  &color
  rem  &buf
return

label Crt.TextBackground
  byte &color ?
  byte &buf   ?
  mov  &buf   $f0
  not  &color Crt.Blink
  and  &buf   &color
  pop  &color
  shl  &color 4
  and  &color &buf
  mov  &buf   $0f
  or   &buf   Crt.Blink
  and  &buf   Crt.TextAttr
  or   &color &buf
  mov  Crt.TextAttr &color
  rem  &color
  rem  &buf
return

label Crt.HighVideo
  byte &buf ?
  mov  &buf Crt.TextAttr
  or   &buf $08
  push &buf
  call Crt.TextColor
  rem  &buf
return

label Crt.LowVideo
  byte &buf ?
  mov  &buf Crt.TextAttr
  and  &buf $77
  push &buf
  call Crt.TextColor
  rem  &buf
return

label Crt.NormVideo
  push 7
  call TextColor
  push 0
  call Crt.TextBackGround
return

label Crt.Window
 invoke Crt.Window32
return

label Crt.GotoXY
 invoke Crt.GotoXY32
return

label Crt.WhereX
 byte &buf  ?
 call Crt.WhereX32
 pop  &buf
 mod  &buf  256
 push &buf
 rem  &buf
return

label Crt.WhereY
 byte &buf  ?
 call Crt.WhereY2
 pop  &buf
 mod  &buf  256
 push &buf
 rem  &buf
return

label Crt.PrintFmt
 var &buf ?
 pop &buf
 push Crt.TextAttr
 push &buf
 invoke Crt.PrintFormat
 rem  &buf
return

label Crt.Pause
 push lm1
 push lm2
 lm1 -1 ;true
 label Crt.Pause.loop
  invoke crt.keypressed
  pop lm2
 ifn Crt.Pause.loop
 pop lm2
 pop lm1
return