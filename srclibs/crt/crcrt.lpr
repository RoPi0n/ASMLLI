library crcrt;
{$mode objfpc}{$H+}

uses
  crt;

{$I ..\crlib.h}

procedure _CursorBig(Stack:PStack); cdecl;
begin
  crt.cursorbig;
end;

procedure _CursorOff(Stack:PStack); cdecl;
begin
  crt.cursoroff;
end;

procedure _CursorOn(Stack:PStack); cdecl;
begin
  crt.cursoron;
end;

procedure _DelLine(Stack:PStack); cdecl;
begin
  crt.DelLine;
end;

procedure _GotoXY32(Stack:PStack); cdecl;
begin
  crt.GotoXY32(Stack^.pop,Stack^.pop);
end;

procedure _InsLine(Stack:PStack); cdecl;
begin
  crt.InsLine;
end;

procedure _KeyPressed(Stack:PStack); cdecl;
begin
  Stack^.push(crt.KeyPressed);
end;

procedure _ReadKey(Stack:PStack); cdecl;
var c:char;
begin
 c:=#0;
 try
  c:=ReadKey;
 finally
  Stack^.push(c);
 end;
end;

procedure _Sound(Stack:PStack); cdecl;
begin
  crt.Sound(stack^.pop);
end;

procedure _WhereX32(Stack:PStack); cdecl;
begin
  stack^.push(crt.WhereX32);
end;

procedure _WhereY32(Stack:PStack); cdecl;
begin
  stack^.push(crt.WhereY32);
end;

procedure _Window32(Stack:PStack); cdecl;
begin
  crt.Window32(stack^.pop,stack^.pop,stack^.pop,stack^.pop);
end;

procedure _ClrEol(Stack:PStack); cdecl;
begin
  crt.ClrEol;
end;

procedure _ClrScr(Stack:PStack); cdecl;
begin
  crt.ClrScr;
end;

////////////////////////////////////////////////
procedure _GetDirectVideo(Stack:PStack); cdecl;
begin
 Stack^.push(DirectVideo);
end;

procedure _GetLastMode(Stack:PStack); cdecl;
begin
 Stack^.push(LastMode);
end;

procedure _GetTextAttr(Stack:PStack); cdecl;
begin
 Stack^.push(TextAttr);
end;

procedure _GetWindMax(Stack:PStack); cdecl;
begin
 Stack^.push(WindMax);
end;

procedure _GetWindMaxX(Stack:PStack); cdecl;
begin
 Stack^.push(WindMaxX);
end;

procedure _GetWindMaxY(Stack:PStack); cdecl;
begin
 Stack^.push(WindMaxY);
end;

procedure _GetWindMin(Stack:PStack); cdecl;
begin
 Stack^.push(WindMin);
end;

procedure _GetWindMinX(Stack:PStack); cdecl;
begin
 Stack^.push(WindMinX);
end;

procedure _GetWindMinY(Stack:PStack); cdecl;
begin
 Stack^.push(WindMinY);
end;

procedure _GetCheckBreak(Stack:PStack); cdecl;
begin
 Stack^.push(CheckBreak);
end;

procedure _GetCheckEOF(Stack:PStack); cdecl;
begin
 Stack^.push(CheckEOF);
end;

procedure _GetCheckSnow(Stack:PStack); cdecl;
begin
 Stack^.push(CheckSnow);
end;



procedure _PRINT(Stack:PStack); cdecl;
var s:string;
begin
 s:=(Stack^.pop);
 if isstr(s) then
  write(ExtractStr(s))
 else write(s);
end;

procedure _PRINTLN(Stack:PStack); cdecl;
var s:string;
begin
 s:=(Stack^.pop);
 if isstr(s) then
  writeln(ExtractStr(s))
 else writeln(s);
end;

procedure _PRINTFORMAT(Stack:PStack); cdecl;
var s:string; //str, attr
begin
 s:=Stack^.pop;
 crt.TextAttr:=Stack^.pop;
 if isstr(s) then
  write(ExtractStr(s))
 else write(s);
end;

procedure _INPUT(Stack:PStack); cdecl;
var s:string;
begin
 read(s);
 Stack^.push('"'+s+'"');
end;

procedure _INPUTLN(Stack:PStack); cdecl;
var s:string;
begin
 readln(s);
 Stack^.push('"'+s+'"');
end;

exports _GetDirectVideo name 'GETDIRECTVIDEO';
exports _GetLastMode name 'GETLASTMODE';
exports _GetTextAttr name 'GETTEXTATTR';
exports _GetWindMax name 'GETWINDMAX';
exports _GetWindMaxX name 'GETWINDMAXX';
exports _GetWindMaxY name 'GETWINDMAXY';
exports _GetWindMin name 'GETWINDMIN';
exports _GetWindMinX name 'GETWINDMINX';
exports _GetWindMinY name 'GETWINDMINY';
exports _GetCheckBreak name 'GETCHECKBREAK';
exports _GetCheckEOF name 'GETCHECKEOF';
exports _GetCheckSnow name 'GETCHECKSNOW';


exports  _CursorBig name 'CURSORBIG';
exports  _CursorOff name 'CURSOROFF';
exports  _CursorOn name 'CURSORON';
exports  _DelLine name 'DELLINE';
exports  _GotoXY32 name 'GOTOXY32';
exports  _InsLine name 'INSLINE';
exports  _KeyPressed name 'KEYPRESSED';
exports  _ReadKey name 'READKEY';
exports  _Sound name 'SOUND';
exports  _WhereX32 name 'WHEREX32';
exports  _WhereY32 name 'WHEREY32';
exports  _Window32 name 'WINDOW32';
exports  _ClrEol name 'CLREOL';
exports  _ClrScr name 'CLRSCR';

exports  _Print name 'PRINT';
exports  _Println name 'PRINTLN';
exports  _PRINTFORMAT name 'PRINTFORMAT';
exports  _Input name 'INPUT';
exports  _Inputln name 'INPUTLN';

//HIGHVIDEO
//LOWVIDEO
//NORMVIDEO
//WINDOW
//WHEREY
//TEXTBACKGROUND
//TEXTCOLOR
//WHEREX
//GotoXY
begin
end.

