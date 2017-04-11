library dmath;

uses Math;

{$I ..\crlib.h}

{FUNCTIONS}

procedure DSin(Stack:PStack); cdecl;
begin
 Stack^.push(sin(Stack^.pop));
end;
procedure DCos(Stack:PStack); cdecl;
begin
 Stack^.push(cos(Stack^.pop));
end;
procedure DTg(Stack:PStack); cdecl;
begin
 Stack^.push(tan(Stack^.pop));
end;
procedure DCtg(Stack:PStack); cdecl;
begin
 Stack^.push(cotan(Stack^.pop));
end;
procedure DArcSin(Stack:PStack); cdecl;
begin
 Stack^.push(ArcSin(Stack^.pop));
end;
procedure DArcCos(Stack:PStack); cdecl;
begin
 Stack^.push(ArcCos(Stack^.pop));
end;
procedure DLog10(Stack:PStack); cdecl;
begin
 Stack^.push(Log10(Stack^.pop));
end;
procedure DLog2(Stack:PStack); cdecl;
begin
 Stack^.push(Log2(Stack^.pop));
end;
procedure DLogN(Stack:PStack); cdecl;
begin
 Stack^.push(LogN(Stack^.pop,Stack^.pop));
end;
procedure Dlnxp1(Stack:PStack); cdecl;
begin
 Stack^.push(lnxp1(Stack^.pop));
end;
procedure DExp(Stack:PStack); cdecl;
begin
 Stack^.push(Exp(Stack^.pop));
end;

{EXPORTS DB}
exports DSIN                name 'SIN';
exports DCOS                name 'COS';
exports DTG                 name 'TG';
exports DCTG                name 'CTG';
exports DARCSIN             name 'ARCSIN';
exports DARCCOS             name 'ARCCOS';
exports DLOG10              name 'LOG10';
exports DLOG2               name 'LOG2';
exports DLOGN               name 'LOGN';
exports DLNXP1              name 'LNXP1';
exports DExp                name 'EXP';

begin
end.
