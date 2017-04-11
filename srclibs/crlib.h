{* 
 * This module is freely distributable part of the project crasm.
 * You can use this module for any commercial or non-commercial purposes for free.
 * Author: Pavel Shiryaev (c) 2016.
 * The purpose of the module: to enable communication between the core of the crasm and the adapter for data exchange.
 * This module is cross-platform and not depend on different libraries.
 * Compiles with FPC (Lazarus)/Delphi or other object pascal compilers.
 *}
 
type TStack=object
 private
  stack:array of variant;
 public
  procedure push(v:variant);
  function  pop:variant;
  function  peek:variant;
end;

type PStack=^TStack;

procedure TStack.push(v:variant);
begin
 SetLength(stack,Length(stack)+1);
 stack[Length(stack)-1]:=v;
end;

function  TStack.pop:variant;
begin
 pop:=stack[Length(stack)-1];
 SetLength(stack,Length(stack)-1);
end;

function  TStack.peek:variant;
begin
 peek:=stack[Length(stack)-1];
end;

function isstr(x:string):boolean;
begin
 isstr:=((x[1]='"')and(x[length(x)]='"')and(pos(copy(x,2,length(x)-2),x)<>0))or(x='""');
end;

function extractstr(x:string):string;
begin
 extractstr:='';
 if (x='""') then extractstr:='' else
  extractstr:=copy(x,2,length(x)-2);
end; 
