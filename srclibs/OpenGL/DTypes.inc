type TValType=(DB,DW,DD8,DD,DD32,DD64,DF,DFA,DFB,DC,DP,DS,DU);
type TVarM=record
  link:string;
  isconstant:boolean;
  ValDyn:variant;//variant in case :(
  ValPtr,ValStr:string;
  case val:TValType of
   DB:(ValByte:BYTE);
   DW:(ValWord:WORD);
   DD8:(ValShort:SHORTINT);
   DD:(ValInt:SMALLINT);
   DD32:(ValInt32:LONGINT);
   DD64:(ValInt64:Int64);
   DF:(ValFloat:REAL);
   DFA:(ValDouble:Double);
   DFB:(ValExtended:Extended);
   DC:(ValChar:CHAR);
end;

type TLabel=record
       name:string;
       bytenum:longint;
end;

type TPFunc=procedure(Eng:Pointer); STDCALL;

type pTPFunc=^TPFunc;

type TFunc=record
 name:string;
 func:pTPFunc;
end;

type TCrLib=record
 name:string;
 pEng:pointer;
end;

{core}
type CRASMEngine=object
 acpgpath:string; 
 islibrary:boolean;
 libs:array of TCrLib;
 scode:tstringlist;
 impl:array of TFunc;
 trymode:boolean;
 try_error:string;
 public_lbls:array of tlabel;
 lbls:array of tlabel;
 arrc:array of array of string;
 logicmem1,logicmem2:variant;
 startlbl:longint;
 stack:array of variant;
 stacksize:longint;
 retlst:array of longint;
 memory:Array of TVarM;
 stackmemory:array of array of TVarM;
 protected
 procedure pushst(v:variant);
 function  popst:variant;
 procedure ClearMem;
end;

type PDASMEngine=^CRASMEngine;

procedure error(msg:string);
begin
 writeln('[Error]: <'+msg+'>');
 halt;
end;

function isstr(x:string):boolean;
begin
 isstr:=(x[1]='"')and(x[length(x)]='"')and(pos(copy(x,2,length(x)-2),x)<>0);
end;

function extractstr(x:string):string;
begin
 extractstr:=copy(x,2,length(x)-2);
end;

procedure CRASMEngine.pushst(v:variant);
begin
 inc(stacksize);
 setlength(stack,length(stack)+1);
 stack[length(stack)-1]:=v;
end;

function CRASMEngine.popst:variant;
begin
 dec(stacksize);
 popst:=stack[length(stack)-1];
 setlength(stack,length(stack)-1);
end;

procedure CRASMEngine.ClearMem;
begin
 SetLength(self.memory,0);
 SetLength(self.stack,0);
end;
