program asmlli;

{$mode objfpc}//{$H+}
uses
  { ShareMem,} {$ifdef unix} {$ifdef UseCThreads}cthreads,
 {$endif}cmem, {$endif}
  SysUtils,
  strutils,
  Classes,
  variants,
  dynlibs;

const
  ver = '1.1.2.0';

type
  TValType = (DB, DW, DD8, DD, DD32, DD64, DF, DFA, DFB, DC, DP, DS, DU);
type
  TVarM = record
    link: string;
    isConstant: boolean;
    ValDyn: variant;
    ValPtr, ValStr: string;
    case val: TValType of
      DB: (ValByte: byte);
      DW: (ValWord: word);
      DD8: (ValShort: shortint);
      DD: (ValInt: smallint);
      DD32: (ValInt32: longint);
      DD64: (ValInt64: int64);
      DF: (ValFloat: single);
      DFA: (ValDouble: double);
      DFB: (ValExtended: extended);
      DC: (ValChar: char);
  end;

type
  TStack = object
  private
    stack: array of variant;
    owner: pointer;
  public
    procedure push(v: variant);
    function pop: variant;
    function peek: variant;
  end;

type
  TLabel = record
    Name: string;
    codepos: longint;
  end;

type
  TPFunc = procedure(Eng: Pointer); cdecl;

type
  pTPFunc = ^TPFunc;

type
  TFunc = record
    Name: string;
    func: pTPFunc;
  end;

type
  TLib = record
    hndl: THandle;
    Name: string;
  end;

  {core}
type
  TASMLLInterprer = object
    calllbllst: array of string;
    acpgpath: string;
    scode: TStringList;
    impl: array of TFunc;
    libs: array of TLib;
    trymode: boolean;
    try_error: string;
    public_lbls: array of tlabel;
    lbls: array of tlabel;
    arrc: array of array of string;
    logicmem1, logicmem2: variant;
    startlbl: longint;
    stack: TStack;
    stacksize: longint;
    retlst: array of longint;
    memory: array of TVarM;
    stackmemory: array of array of TVarM;
    look: cardinal;
  protected
    function doLM(line: cardinal; lm: byte): cardinal;
    function doIF(line: cardinal; op: byte): cardinal;
    function doThread(line: cardinal): cardinal;
    function ExLine(line: cardinal): cardinal;
    procedure Execute(line: cardinal);
    procedure pushst(v: variant);
    function popst: variant;
    function doInvoke(line: cardinal): cardinal;
    function doPop(line: cardinal): cardinal;
    function doPush(line: cardinal): cardinal;
    procedure pushret(line: cardinal);
    function popret: longint;
    function doJC(line: cardinal): cardinal;
    function doJR(line: cardinal): cardinal;
    function memoryExist(lnk: string): boolean;
    function getfirstindex(lnk: string): string;
    function getarrname(lnk: string): string;
    function GMem(lnk: string): cardinal;
    function isPublic(lnk: string): boolean;
    function isPublicArray(lnk: string): boolean;
    procedure RemMem(lnk: string);
    function GetMem(link: string): TVarM;
    procedure NewMem(n: string; tpe: TValType; val: variant);
    procedure NewPublicMem(n: string; tpe: TValType; val: variant);
    procedure SetMem(link: string; tpe: TValType; Val: variant);
    procedure initRec(n: string; tn: string);
    procedure initPublicRec(n: string; tn: string);
    procedure remRec(n: string; tn: string);
    function doDB(line: cardinal): cardinal;
    function doDW(line: cardinal): cardinal;
    function doDD8(line: cardinal): cardinal;
    function doDD(line: cardinal): cardinal;
    function doDD32(line: cardinal): cardinal;
    function doDD64(line: cardinal): cardinal;
    function doDF(line: cardinal): cardinal;
    function doDFa(line: cardinal): cardinal;
    function doDFb(line: cardinal): cardinal;
    function doDC(line: cardinal): cardinal;
    function doDS(line: cardinal): cardinal;
    function doDU(line: cardinal): cardinal;
    function doRem(line: cardinal): cardinal;
    function doRemRec(line: cardinal): cardinal;
    function doMov(line: cardinal): cardinal;
    function doAdd(line: cardinal): cardinal;
    function doSub(line: cardinal): cardinal;
    function doInc(line: cardinal): cardinal;
    function doDec(line: cardinal): cardinal;
    function doMul(line: cardinal): cardinal;
    function doDiv(line: cardinal): cardinal;
    function doIDiv(line: cardinal): cardinal;
    function doMod(line: cardinal): cardinal;
    function doPow(line: cardinal): cardinal;
    function doAnd(line: cardinal): cardinal;
    function doOr(line: cardinal): cardinal;
    function doXor(line: cardinal): cardinal;
    function doNot(line: cardinal): cardinal;
    function doShl(line: cardinal): cardinal;
    function doShr(line: cardinal): cardinal;
    procedure checkpublic;
    procedure ClearMem;
    function doMakePublic(line: cardinal): cardinal;
    function doSize(line: cardinal): cardinal;
    function doPeek(line: cardinal): cardinal;
    procedure initParamStr;
    function parsePtr(lnk: string): string;
    function doDP(line: cardinal): cardinal;
    function doJP(line: cardinal): cardinal;
    function isArray(lnk: string): boolean;
    function isObj(lnk: string): boolean;
    function doLength(line: cardinal): cardinal;
    procedure doImports;
    function ArrLen(n: string): cardinal;
    function getlbl(Name: string): cardinal;
    function doLastErr(line: cardinal): cardinal;
    function doTry(line: cardinal; mode: boolean): cardinal;
    function doSuspendThread(line: cardinal): cardinal;
    function doResumeThread(line: cardinal): cardinal;
    function doTerminateThread(line: cardinal): cardinal;
    function doThreadWaitFor(line: cardinal): cardinal;
    function checkinitarrname(lnk: string): boolean;
    procedure getfirstnd(lnk: string; var prefix, suffix: string; var min, max: longint);
    procedure ImportBasics;
    procedure DHalt;
    procedure error(msg: string);
    procedure prepsynonyms;
    procedure doInclude;
    procedure doHeader;
    function str2float(x: string): double;
    procedure checklabels;
    function recId(n: string): integer;
    procedure checkrecords;
    function getIndex(n: string): integer;
    procedure convert;
    function skipBlock(line: cardinal): cardinal;
    function lblexist(n: string): boolean;
    function public_lblexist(n: string): boolean;
    procedure initTRY;
    procedure initIMPORTS;
    procedure RegFunc(n: string; f: ptpfunc);
    procedure parsecodeline(l: string);
    procedure InitSrcRd;
    function smartlowercase(s: string): string;
    function doCharRead(line: cardinal): cardinal;
    function doCharWrite(line: cardinal): cardinal;
    function doOrd(line: cardinal): cardinal;
    function doChr(line: cardinal): cardinal;
    procedure RegLib(n: string; h: THandle);
    function LibRegistered(n: string): boolean;
    function GetLib(n: string): THandle;
  end;

type
  PASMLLInterprer = ^TASMLLInterprer;

var
  PublicMemory: array of TVarM;
  //check reserved words
const
  rword: array[0..68] of string = (
    'label', 'jump', 'call', 'invoke', 'end', 'struct', 'import', 'head',
    'mov', 'add', 'sub', 'mul', 'div', 'idiv', 'mod', 'pow', 'pub', '?',
    'shl', 'shr', 'and', 'or', 'xor', 'public',
    'char', 'byte', 'word', 'int', 'float', 'str', 'var', 'short', 'int32', 'int64',
    'double', 'extended', 'ptr',
    'push', 'pop', 'size', 'peek', 'rem', 'remrec',
    'lm1', 'lm2', 'ifb', 'ifs', 'ife', 'ifn', 'thread',
    'uses', 'data', 'return', 'length', 'try', 'lasterr', 'inc', 'dec',
    'memory', 'define', 'suspendthread', 'resumethread', 'terminatethread',
    'extends', 'block',
    'charread', 'charwrite', 'ord', 'chr');

  {ACPG Decompress}

var
  MainClassPath: string;

  procedure TASMLLInterprer.error(msg: string);
  var
    w: word;
  begin
    writeln('[Error]: "' + msg + '" in:');
    writeln(' -> pos: ', look - 1);
    Write(' -> line: ');
    for w := 0 to length(arrc[look - 1]) - 1 do
      Write(arrc[look - 1][w], ' ');
    dhalt;
  end;

  procedure FError(msg: string);
  begin
    writeln('[Fatal]: "' + msg + '"');
  end;

  function GetVal(mv: TVarM): variant;
  begin
    with mv do
      case val of
        db: Result := valbyte;
        dw: Result := valword;
        dd: Result := valint;
        dd8: Result := valshort;
        dd32: Result := valint32;
        dd64: Result := valint64;
        df: Result := ValFloat;
        dfa: Result := valdouble;
        dfb: Result := valextended;
        dc: Result := valchar;
        dp: Result := valptr;
        ds: Result := valstr;
        du: Result := valdyn;
        else
          FError('Internal error.');
      end;
  end;


const
  alpha: set of char = ['A'..'Z', 'a'..'z', '0'..'9', '_', '.', '[',
    ']', '@', '*', '-', '+', '$', ':', '?', '#'];
  alphaf: set of char = ['A'..'Z', 'a'..'z', '_'];

  {alphachars: set of char = ['A'..'Z', 'a'..'z', '0'..'9', '_', '.',
    '[', ']', '@', '*', '-', '+', '$', ':', ' ', #13, #10, '"', '#', '?']; }




  function isAlpha(c: char): boolean;
  begin
    Result := c in alpha;
  end;

var
  SynonymL, SynonymR: array of string;

  procedure AddSynonym(L, R: string);
  begin
    SetLength(SynonymL, Length(SynonymL) + 1);
    SynonymL[length(SynonymL) - 1] := lowercase(L);
    SetLength(SynonymR, Length(SynonymR) + 1);
    SynonymR[length(SynonymR) - 1] := lowercase(R);
  end;

  function isSynonym(n: string): boolean;
  var
    i: integer;
  begin
    Result := False;
    if Length(SynonymL) = 0 then
      exit;
    Result := True;
    for i := 0 to length(SynonymL) - 1 do
      if SynonymL[i] = n then
        exit;
    Result := False;

  end;

  function RepSynonym(n: string): string;  //L->R

  var
    i: integer;
  begin
    Result := n;
    if Length(SynonymL) = 0 then
      exit;
    for i := 0 to length(SynonymL) - 1 do
      if SynonymL[i] = n then
      begin
        if isSynonym(SynonymR[i]) then
          Result := RepSynonym(SynonymR[i])
        else
          Result := SynonymR[i];
        exit;
      end;

  end;

  function isReserved(n: string): boolean;

  var
    i: integer;
  begin
    Result := True;
    if isSynonym(n) then
      exit;
    for i := 0 to length(rword) - 1 do
      if rword[i] = n then
        exit;
    Result := False;

  end;

  procedure TASMLLInterprer.PrepSynonyms;
  var
    i: longint;
  begin
    for i := 0 to length(arrc) - 1 do
      if arrc[i][0] = 'define' then
      begin
        if length(arrc[i]) <> 3 then
          error('Invalid synonym constructions.');
        if (arrc[i][2] = 'short') or (arrc[i][2] = 'int') or
          (arrc[i][2] = 'int32') or (arrc[i][2] = 'int64') or
          (arrc[i][2] = 'word') or (arrc[i][2] = 'byte') or
          (arrc[i][2] = 'char') or (arrc[i][2] = 'str') or
          (arrc[i][2] = 'float') or (arrc[i][2] = 'double') or
          (arrc[i][2] = 'extended') or (arrc[i][2] = 'ptr') or (arrc[i][2] = 'var') then
        begin
          if isReserved(arrc[i][1]) = False then
            AddSynonym(arrc[i][1], arrc[i][2])
          else
            error('Invalid synonym assign.');
        end
        else
          error('Invalid synonym assign.');
      end;
  end;


  function validLblName(n: string): boolean;
  var
    i: integer;
  begin
    Result := False;
    if (n[1] in alphaf) then
      Result := True;
    if length(n) >= 2 then
      for i := 2 to length(n) do
        if (isAlpha(n[i]) = False) then
          Result := False;
    if pos('..', n) <> 0 then
      Result := False;
    if pos('.0', n) <> 0 then
      Result := False;
    if pos('.1', n) <> 0 then
      Result := False;
    if pos('.2', n) <> 0 then
      Result := False;
    if pos('.3', n) <> 0 then
      Result := False;
    if pos('.4', n) <> 0 then
      Result := False;
    if pos('.5', n) <> 0 then
      Result := False;
    if pos('.6', n) <> 0 then
      Result := False;
    if pos('.7', n) <> 0 then
      Result := False;
    if pos('.8', n) <> 0 then
      Result := False;
    if pos('.9', n) <> 0 then
      Result := False;
    if pos('[', n) <> 0 then
      Result := False;
    if pos(']', n) <> 0 then
      Result := False;
    if pos('@', n) <> 0 then
      Result := False;
    if pos('*', n) <> 0 then
      Result := False;
    if pos('+', n) <> 0 then
      Result := False;
    if pos('-', n) <> 0 then
      Result := False;
    if pos('$', n) <> 0 then
      Result := False;
    if pos(':', n) <> 0 then
      Result := False;
    if isReserved(n) then
      Result := False;
  end;

  function validName(n: string): boolean;
  var
    i: integer;
  begin
    Result := False;
    if n[1] = '$' then
      Delete(n, 1, 1);
    if (n[1] in alphaf) then
      Result := True;
    if length(n) >= 2 then
      for i := 2 to length(n) do
        if (isAlpha(n[i]) = False) then
          Result := False;
    if pos('..', n) <> 0 then
      Result := False;
    if pos('.0', n) <> 0 then
      Result := False;
    if pos('.1', n) <> 0 then
      Result := False;
    if pos('.2', n) <> 0 then
      Result := False;
    if pos('.3', n) <> 0 then
      Result := False;
    if pos('.4', n) <> 0 then
      Result := False;
    if pos('.5', n) <> 0 then
      Result := False;
    if pos('.6', n) <> 0 then
      Result := False;
    if pos('.7', n) <> 0 then
      Result := False;
    if pos('.8', n) <> 0 then
      Result := False;
    if pos('.9', n) <> 0 then
      Result := False;
    if pos('@', n) <> 0 then
      Result := False;
    if pos('*', n) <> 0 then
      Result := False;
    if pos('+', n) <> 0 then
      Result := False;
    if (pos('-', n) <> 0) and (n[pos('-', n) - 1] <> '[') then
      Result := False;
    if pos('$', n) <> 0 then
      Result := False;
    if pos(':', n) <> 0 then
      Result := False;
    if isReserved(n) then
      Result := False;
  end;


  function getfirst(s: string): string;
  begin
    Result := '';
    s := Trim(s);
    if Length(s) > 0 then
    begin
      if s[1] = ';' then
      begin
        Result := '';
      end
      else
      if s[1] = '"' then
      begin
        Delete(s, 1, 1);
        Result := '"' + Copy(s, 1, Pos('"', s));
        Delete(s, 1, Length(Result) + 1);
      end
      else
      begin
        if Pos(' ', s) <> 0 then
        begin
          Result := Copy(s, 1, Pos(' ', s) - 1);
          Delete(s, 1, Length(Result));
        end
        else
        begin
          Result := s;
          s := '';
        end;
      end;
    end;
  end;

  function cutfirsttkn(s: string): string;
  begin
    s := trim(s);
    if s[1] = ';' then
      s := ''
    else
      Delete(s, 1, length(getfirst(s)));
    Result := Trim(s);
  end;

  function TASMLLInterprer.smartlowercase(s: string): string;
  var
    b: string;
  begin
    Result := '';
    while length(s) > 0 do
    begin
      b := getfirst(s);
      s := cutfirsttkn(s);
      if b[1] = '"' then
        Result := Result + ' ' + b
      else
        Result := Result + ' ' + LowerCase(b);
    end;
  end;

  function extractstr(x: string): string;
  begin
    Result := '';
    if (x = '""') then
      Result := ''
    else
      Result := copy(x, 2, length(x) - 2);
  end;


  function TASMLLInterprer.skipBlock(line: cardinal): cardinal;
  var
    i: longint;
  begin
    for i := line to length(arrc) - 1 do
    begin
      line := i;
      if arrc[i][0] = 'end' then
        break;
    end;
    Result := line + 1;
  end;


  procedure TASMLLInterprer.parsecodeline(l: string);
  begin
    //l:=delremark(l);
    l := smartlowercase(l);
    l := trim(l);
    if length(l) > 0 then
      scode.add(l);
  end;

  procedure TASMLLInterprer.initsrcrd;
  begin
    scode := TStringList.Create;
  end;

  procedure TASMLLInterprer.convert;
  var
    i, x: integer;
    str: string;
  begin
    setlength(arrc, scode.Count);
    for i := 0 to scode.Count - 1 do
    begin
      x := 0;
      str := scode.strings[i];
      repeat
        setlength(arrc[i], length(arrc[i]) + 1);
        arrc[i][x] := getfirst(str);
        str := trim(cutfirsttkn(str));
        x := x + 1;
      until length(str) = 0;
    end;
    scode.Free;
  end;

var
  LstUsed: array of string;

  function isUsed(p: string): boolean;

  var
    i: integer;
  begin
    Result := True;
    if length(LstUsed) <> 0 then
      for i := 0 to length(LstUsed) - 1 do
        if LstUsed[i] = p then
          exit;
    Result := False;

  end;

  procedure TASMLLInterprer.doInclude;
  var
    i, x: integer;
    buf: string;
    f: TStringList;
  begin
    for i := 0 to scode.Count - 1 do
    begin
      if getfirst(scode.strings[i]) = 'uses' then
      begin
        buf :=
          extractstr(getfirst(cutfirsttkn(scode.strings[i])));
        if fileexists(extractfiledir(ParamStr(0)) + '\inc\' + buf) then
          buf := extractfiledir(ParamStr(0)) + '\inc\' + buf
        else
          buf := extractfiledir(MainClassPath) + '\' + buf;
        if fileexists(buf) = False then
          error('Unit "' + buf + '" not found"');
        if isUsed(buf) = False then
        begin
          SetLength(LstUsed, Length(LstUsed) + 1);
          LstUsed[Length(LstUsed) - 1] := buf;
          f := TStringList.Create;
          f.loadfromfile(buf);
          for x := 0 to f.Count - 1 do
          begin
            //f.strings[x]:=smartlowercase(f.strings[x]);
            //f.strings[x]:=trim(f.strings[x]);
            parsecodeline(f.strings[x]);
          end;
        end;//if
        //scode.strings[i]:=f.text;
      end;
    end;
  end;


  procedure TASMLLInterprer.doHeader;
  var
    i, x: integer;
    buf: string;
    f, r: TStringList;
  begin
    for i := 0 to scode.Count - 1 do
    begin
      if getfirst(scode.strings[i]) = 'head' then
      begin
        buf :=
          extractstr(getfirst(cutfirsttkn(scode.strings[i])));
        if fileexists(extractfiledir(ParamStr(0)) + '\inc\' + buf) then
          buf := extractfiledir(ParamStr(0)) + '\inc\' + buf
        else
          buf := extractfiledir(ParamStr(1)) + '\' + buf;
        if fileexists(buf) = False then
          error('Unit "' + buf + '" not found"');
        if isUsed(buf) = False then
        begin
          SetLength(LstUsed, Length(LstUsed) + 1);
          LstUsed[Length(LstUsed) - 1] := buf;

          f := TStringList.Create;
          f.loadfromfile(buf);
          scode.strings[i] := ';' + scode.strings[i];
          r := TStringList.Create;
          for x := 0 to f.Count - 1 do
          begin
            f.strings[x] := smartlowercase(f.strings[x]);
            f.strings[x] := trim(f.strings[x]);
            if length(f.strings[x]) <> 0 then
              r.add(f.strings[x]);
          end;
          scode.strings[i] := r.Text;
        end//if
        else
          scode.strings[i] := ';' + scode.strings[i];
      end;
    end;
  end;

  {stack}
  procedure TASMLLInterprer.pushst(v: variant);
  begin
    Inc(stacksize);
    stack.push(v);
  end;

  procedure TStack.push(v: variant);
  begin
    SetLength(stack, Length(stack) + 1);
    stack[Length(stack) - 1] := v;
  end;

  function TStack.pop: variant;
  begin
    Result := stack[Length(stack) - 1];
    SetLength(stack, Length(stack) - 1);
  end;

  function TStack.peek: variant;
  begin
    Result := stack[Length(stack) - 1];
  end;

  function TASMLLInterprer.popst: variant;
  begin
    if length(stack.stack) = 0 then
      error('Error read stack at index [-1]');
    Dec(stacksize);
    Result := stack.pop;
  end;


  function isstr(x: string): boolean;
  begin
    Result := ((x[1] = '"') and (x[length(x)] = '"') and
      (pos(copy(x, 2, length(x) - 2), x) <> 0)) or (x = '""');
  end;

  function RBin32ToInt(Value: string): cardinal;
  var
    i: integer;
  begin
    Delete(Value, length(Value), 1);
    Result := 0;
    Value := ReverseString(Value);
    for i := 1 to Length(Value) do
      if Value[i] = '1' then
        Result := Result + Round(Exp(ln(2)*(i - 1)));
  end;

  function isrbin32(v: string): boolean;

  begin
    Result := False;
    v := ReverseString(v);
    if v[1] = 'b' then
      Delete(v, 1, 1)
    else
      exit;
    repeat
      if v[1] in ['0'..'1'] then
        Delete(v, 1, 1)
      else
        exit;
    until length(v) = 0;
    Result := True;

  end;

  function TASMLLInterprer.str2float(x: string): double;
  begin
    try
      Result := StrToInt(x);
    except
      try
        Result := StrToFloat(x);
      except
        error('invalid numeric value "' + x + '"');
      end;
    end;
  end;

  function isdigit(x: string): boolean;
  var
    isint, isfloat: boolean;
  begin
    isint := True;
    isfloat := True;
    try
      StrToInt(x);
    except
      isint := False;
    end;
    try
      StrToFloat(x);
    except
      isfloat := False;
    end;
    Result := (isint) or (isfloat);
  end;

  {labels}
  function TASMLLInterprer.lblexist(n: string): boolean;

  var
    i: longint;
  begin
    Result := False;
    if length(lbls) = 0 then
      exit;
    Result := True;
    for i := 0 to length(lbls) - 1 do
      if lbls[i].Name = n then
        exit;
    Result := False;

  end;

  function TASMLLInterprer.public_lblexist(n: string): boolean;

  var
    i: longint;
  begin
    Result := False;
    if length(public_lbls) = 0 then
      exit;
    Result := True;
    for i := 0 to length(public_lbls) - 1 do
      if public_lbls[i].Name = n then
        exit;
    Result := False;

  end;

  procedure TASMLLInterprer.checklabels;
  var
    i: integer;
    n: string;
  begin
    setlength(lbls, 0);
    for i := 0 to length(arrc) - 1 do
      if arrc[i][0] = 'label' then   //label
      begin
        n := arrc[i][1];
        if lblexist(n) then
          error('Dublicate label name @' + n);
        setlength(lbls, length(lbls) + 1);
        with lbls[length(lbls) - 1] do
        begin
          Name := n;
          codepos := i;
        end;
        if length(arrc[i]) <> 2 then
          error('Invalid label structure');
        if validLblname(n) = False then
          error('Invalid name "' + n + '"');
      end
      else
      if (arrc[i][0] = 'public') and (arrc[i][1] = 'label') then
      begin
        n := arrc[i][2];
        if lblexist(n) then
          error('Dublicate label name @' + n);
        setlength(lbls, length(lbls) + 1);
        with lbls[length(lbls) - 1] do
        begin
          Name := n;
          codepos := i;
        end;
        setlength(public_lbls, length(public_lbls) + 1);
        with public_lbls[length(public_lbls) - 1] do
        begin
          Name := n;
          codepos := i;
        end;
        if length(arrc[i]) <> 3 then
          error('Invalid label structure');
        if validLblname(n) = False then
          error('Invalid name "' + n + '"');
      end;
  end;



  procedure TASMLLInterprer.pushret(line: cardinal);
  begin
    SetLength(retlst, length(retlst) + 1);
    retlst[Length(retlst) - 1] := line;
  end;

  function TASMLLInterprer.popret: longint;
  begin
    if length(retlst) > 0 then
    begin

      Result := retlst[length(retlst) - 1];
      setlength(retlst, length(retlst) - 1);
      setlength(calllbllst, length(calllbllst) - 1);
    end
    else
      Result := length(arrc);

  end;


  function TASMLLInterprer.getlbl(Name: string): cardinal;
  var
    i: longint;
  begin
    if pos('&', Name) <> 0 then
      Name := ReplaceStr(Name, '&', calllbllst[Length(calllbllst) - 1]);
    if pos('*', Name) <> 0 then
      Name := parsePTR(Name);
    for i := 0 to length(lbls) - 1 do
      if lbls[i].Name = Name then
      begin
        Result := i;
        exit;
      end;
    error('Invalid call @' + Name + ' label');

  end;

  {Memory}
  function TASMLLInterprer.memoryExist(lnk: string): boolean;
  var
    i: longint;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    Result := False;
    if length(memory) = 0 then
      exit;
    Result := True;
    for i := 0 to length(memory) - 1 do
      if Memory[i].link = lnk then
        exit;
    Result := False;

  end;

  function TASMLLInterprer.isPublic(lnk: string): boolean;
  var
    i: longint;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    Result := False;
    if length(publicMemory) = 0 then
      exit;
    Result := True;
    for i := 0 to length(publicmemory) - 1 do
      if PublicMemory[i].link = lnk then
        exit;
    Result := False;

  end;

  function TASMLLInterprer.isArray(lnk: string): boolean;
  var
    i: longint;
  begin
    Result := True;
    for i := 0 to length(memory) - 1 do
      if copy(memory[i].link, 0, length(lnk) + 1) = lnk + '[' then
        exit;
    for i := 0 to length(publicmemory) - 1 do
      if copy(publicmemory[i].link, 0, length(lnk) + 1) = lnk + '[' then
        exit;
    Result := False;
  end;

  function TASMLLInterprer.isPublicArray(lnk: string): boolean;
  var
    i: longint;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    Result := True;
    for i := 0 to length(publicmemory) - 1 do
      if copy(publicmemory[i].link, 0, length(lnk) + 1) = lnk + '[' then
        exit;
    Result := False;
  end;

  function TASMLLInterprer.isObj(lnk: string): boolean;
  var
    i: longint;
  begin
    Result := True;
    for i := 0 to length(memory) - 1 do
      if copy(memory[i].link, 0, length(lnk) + 1) = lnk + '.' then
        exit;
    for i := 0 to length(publicmemory) - 1 do
      if copy(publicmemory[i].link, 0, length(lnk) + 1) = lnk + '.' then
        exit;
    Result := False;
  end;

  //[index] or [from..to]
  function TASMLLInterprer.getfirstindex(lnk: string): string;
  var
    buf, buf1: string;
    i, index: integer;
    ind1, ind2: int64;
  begin
    buf := copy(lnk, 2, pos(']', lnk) - 2);
    if (pos(':', buf) <> 0) then
    begin
      buf1 := buf;
      Delete(buf1, pos(':', buf1), 1);
      if pos(':', buf1) <> 0 then
        error('Invalid array index.');
      buf1 := copy(buf, 0, pos(':', buf) - 1);
      buf := copy(buf, pos(':', buf) + 1, length(buf));
      //start &
      if isdigit(buf1) then
        ind1 := StrToInt(buf1)
      else
      if isrbin32(buf1) then
        ind1 := rbin32toint(buf1)
      else
      begin
        if memoryExist(buf1) = False then
          error('Memory link not exist "' + buf1 + '"');
        for i := 0 to length(memory) - 1 do
          if Memory[i].link = buf1 then
          begin
            index := i;
            break;
          end;
        case Memory[index].val of
          db: ind1 := Memory[index].valbyte;
          dw: ind1 := Memory[index].valword;
          dd: ind1 := Memory[index].valint;
          dd8: ind1 := Memory[index].valshort;
          dd32: ind1 := Memory[index].valint32;
          dd64: ind1 := Memory[index].valint64;
          du: ind1 := Memory[index].valdyn;
          else
            error('Array index type must be integer.');
        end;
      end;
      //part2
      if isdigit(buf) then
        ind2 := StrToInt(buf)
      else
      if isrbin32(buf) then
        ind2 := rbin32toint(buf)
      else
      begin
        if memoryExist(buf) = False then
          error('Memory link not exist "' + buf + '"');
        for i := 0 to length(memory) - 1 do
          if Memory[i].link = buf then
          begin
            index := i;
            break;
          end;
        case Memory[index].val of
          db: ind2 := Memory[index].valbyte;
          dw: ind2 := Memory[index].valword;
          dd: ind2 := Memory[index].valint;
          dd8: ind2 := Memory[index].valshort;
          dd32: ind2 := Memory[index].valint32;
          dd64: ind2 := Memory[index].valint64;
          du: ind2 := Memory[index].valdyn;
          else
            error('Array index type must be integer.');
        end;
      end;
      Result := IntToStr(ind1) + ':' + IntToStr(ind2);
      //end *
    end
    else
    begin
      buf := copy(lnk, 2, pos(']', lnk) - 2);
      if isdigit(buf) then
        Result := IntToStr(StrToInt(buf))
      else
      if isrbin32(buf) then
        Result := IntToStr(rbin32toint(buf))
      else
      begin
        if memoryExist(buf) = False then
          error('Memory link not exist "' + buf + '"');
        for i := 0 to length(memory) - 1 do
          if Memory[i].link = buf then
          begin
            index := i;
            break;
          end;
        case Memory[index].val of
          db: Result := IntToStr(Memory[index].valbyte);
          dw: Result := IntToStr(Memory[index].valword);
          dd: Result := IntToStr(Memory[index].valint);
          dd8: Result := IntToStr(Memory[index].valshort);
          dd32: Result := IntToStr(Memory[index].valint32);
          dd64: Result := IntToStr(Memory[index].valint64);
          du: Result := IntToStr(Memory[index].valdyn);
          else
            error('Array index type must be integer.');
        end;
      end;
    end;
  end;

  //[index]
  function cutfirstindex(lnk: string): string;
  begin
    Result := copy(lnk, pos(']', lnk) + 1, length(lnk));
  end;

  function TASMLLInterprer.getarrname(lnk: string): string;
  var
    prefix: string;
    suffix: string;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    prefix := copy(lnk, 1, pos('[', lnk) - 1);
    if length(prefix) = 0 then
      error('Invalid array name');
    suffix := '';
    lnk := copy(lnk, pos('[', lnk), length(lnk));
    repeat
      if (not (length(lnk) <> 0) and (pos('[', lnk) <> 0) and (pos(']', lnk) <> 0)) then
        error('Invalid array index');
      suffix := suffix + '[' + getfirstindex(lnk) + ']';
      lnk := cutfirstindex(lnk);
    until length(lnk) = 0;
    Result := prefix + suffix;
  end;

  function TASMLLInterprer.checkinitarrname(lnk: string): boolean;
  var
    prefix: string;
    //suffix:string;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    Result := True;
    prefix := copy(lnk, 1, pos('[', lnk) - 1);
    if length(prefix) = 0 then
      error('Invalid array name');
    //suffix:='';
    lnk := copy(lnk, pos('[', lnk), length(lnk));
    repeat
      if (not (length(lnk) <> 0) and (pos('[', lnk) <> 0) and (pos(']', lnk) <> 0)) then
        error('Invalid array index');
      Result := (pos(':', getfirstindex(lnk)) <> 0) and (checkinitarrname);
      lnk := cutfirstindex(lnk);
    until length(lnk) = 0;
  end;

  procedure TASMLLInterprer.getfirstnd(lnk: string; var prefix, suffix: string;
  var min, max: longint);

  var
    buf: string;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    prefix := copy(lnk, 1, pos('[', lnk) - 1);                      // xxx[][][] >> xxx
    lnk := copy(lnk, pos('[', lnk), length(lnk));                 // xxx[][][] >> [][][]
    repeat
      buf := getfirstindex(lnk);
      if pos(':', buf) <> 0 then                                 // ?  [x&y][][]...
      begin
        min := StrToInt(copy(buf, 0, pos(':', buf) - 1));           // min=x
        max := StrToInt(copy(buf, pos(':', buf) + 1, length(buf)));  // max=y
        suffix := cutfirstindex(lnk);                            // suffix=unparsed
        exit;
      end;
      prefix := prefix + '[' + buf + ']';
      //prefix=prefix+[xxx]
      lnk := cutfirstindex(lnk);
    until length(lnk) = 0;

  end;

  function cutlastindex(s: string): string;
  begin
    s := ReverseString(s);
    s := copy(s, pos('[', s) + 1, length(s));
    s := ReverseString(s);
    Result := s;
  end;

  function TASMLLInterprer.ArrLen(n: string): cardinal;
  var
    i: longint;
    len: longint;
  begin
    n := ReplaceStr(n, '&', calllbllst[Length(calllbllst) - 1]);
    if pos('[', n) <> 0 then
      n := getarrname(n);
    len := 0;
    if isArray(n) then
      for i := 0 to length(memory) - 1 do
        if copy(memory[i].link, 0, length(n) + 1) = n + '[' then
          Inc(len);
    if isPublicArray(n) then
      for i := 0 to length(publicmemory) - 1 do
        if copy(publicmemory[i].link, 0, length(n) + 1) = n + '[' then
          Inc(len);
    Result := len;
  end;

  function TASMLLInterprer.parsePtr(lnk: string): string;
  var
    pref, suff: string;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    repeat
      pref := copy(lnk, 0, pos('*', lnk) - 1);
      suff := copy(lnk, pos('*', lnk) + 1, length(lnk));
      if ispublic(pref) then
        pref := publicmemory[gmem(pref)].valptr
      else
        pref := memory[gmem(pref)].valptr;
      lnk := pref + suff;
    until (length(lnk) = 0) or (pos('*', lnk) = 0);
    Result := lnk;
  end;

  function TASMLLInterprer.GMem(lnk: string): cardinal;
  var
    i: longint;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    if pos('*', lnk) <> 0 then
      lnk := parsePtr(lnk);
    if pos('[', lnk) <> 0 then
      lnk := getarrname(lnk);
    if (memoryExist(lnk) = False) and (isPublic(lnk) = False) then
      error('Memory link not exist "' + lnk + '"');

    if ispublic(lnk) then
    begin
      for i := 0 to length(publicmemory) - 1 do
        if publicMemory[i].link = lnk then
        begin
          Result := i;
          exit;
        end;
    end
    else
      for i := 0 to length(memory) - 1 do
        if Memory[i].link = lnk then
        begin
          Result := i;
          exit;
        end;
  end;


  procedure TASMLLInterprer.RemMem(lnk: string);
  var
    pr, sf: string;
    mn, mx, i: longint;
  begin
    lnk := ReplaceStr(lnk, '&', calllbllst[Length(calllbllst) - 1]);
    pr := '';
    sf := '';
    mn := 0;
    mx := 0;
    if pos('*', lnk) <> 0 then
      lnk := parsePtr(lnk);
    if pos('[', lnk) <> 0 then
      lnk := getarrname(lnk);
    if pos(':', lnk) <> 0 then
    begin
      getfirstnd(lnk, pr, sf, mn, mx);
      if mn < mx then
        for i := mn to mx do
          RemMem(pr + '[' + IntToStr(i) + ']' + sf)
      else if mn > mx then
        for i := mx to mn do
          RemMem(pr + '[' + IntToStr(i) + ']' + sf)
      else if mn = mx then
        RemMem(pr + '[' + IntToStr(mn) + ']' + sf);
      exit;
    end;

    if ispublic(lnk) then
    begin
      PublicMemory[GMem(lnk)] := PublicMemory[length(PublicMemory) - 1];
      SetLength(PublicMemory, Length(PublicMemory) - 1);
    end
    else
    if memoryexist(lnk) then
    begin
      Memory[GMem(lnk)] := Memory[length(Memory) - 1];
      SetLength(Memory, Length(Memory) - 1);
    end
    else
      error('Void can not be removed');

  end;


  function TASMLLInterprer.GetMem(link: string): TVarM;

  var
    i: longint;
    bufVarPtr: TVarM;
  begin
    link := ReplaceStr(link, '&', calllbllst[Length(calllbllst) - 1]);
    if pos('@', link) <> 0 then
    begin
      bufVarPtr.link := '@ptr';
      bufVarPtr.val := dp;
      bufVarPtr.Valptr := copy(link, 2, length(link));
      if not ((isPublic(bufVarPtr.valptr)) or (memoryExist(bufVarPtr.valptr)) or
        (isArray(bufVarPtr.valptr)) or (isObj(bufVarPtr.valptr)) or
        (lblexist(bufVarPtr.valptr))) then
        error('Void pointer');
      Result := bufVarPtr;
      exit;
    end;
    if pos('%', link) <> 0 then
    begin
      bufVarPtr.link := '@ptr';
      bufVarPtr.val := dp;
      bufVarPtr.Valptr := copy(link, 2, length(link));
      Result := bufVarPtr;
      exit;
    end;
    if (ispublic(link)) or ((pos(']', link) = length(link)) and
      (ispublic(cutlastindex(link)))) then
    begin
      if (pos(']', link) = length(link)) and (memoryExist(cutlastindex(link))) then
        if (publicmemory[GMem(cutlastindex(link))].val = DS) then
        begin
          bufVarPtr.link := '@chr';
          bufVarPtr.val := dc;
          bufVarPtr.ValChar :=
            extractstr(publicmemory[GMem(cutlastindex(link))].valstr)
            [StrToInt(getfirstindex(copy(getarrname(link),
            pos('[', getarrname(link)), length(getarrname(link)))))];
          Result := bufVarPtr;
          exit;
        end;
      i := GMem(link);
      Result := publicmemory[i];
    end
    else
    begin
      if (pos(']', link) = length(link)) and (memoryExist(cutlastindex(link))) then
        if (memory[GMem(cutlastindex(link))].val = DS) then
        begin
          bufVarPtr.link := '@chr';
          bufVarPtr.val := dc;
          bufVarPtr.ValChar :=
            extractstr(memory[GMem(cutlastindex(link))].valstr)[StrToInt(
            getfirstindex(copy(getarrname(link), pos('[', getarrname(link)),
            length(getarrname(link)))))];
          Result := bufVarPtr;
          exit;
        end;
      i := GMem(link);
      Result := memory[i];
    end;

  end;



  //создаем переменную и ссылку на неё
  procedure TASMLLInterprer.NewMem(n: string; tpe: TValType; val: variant);

  var
    newVar: TVarM;
    i: longint;
  var
    pr, sf: string;
    mn, mx: longint;
  begin
    n := ReplaceStr(n, '&', calllbllst[Length(calllbllst) - 1]);
    pr := '';
    sf := '';
    mn := 0;
    mx := 0;
    if pos('*', n) <> 0 then
      n := parsePtr(n);
    if pos('[', n) <> 0 then
      n := getarrname(n);
    if pos(':', n) <> 0 then
    begin
      getfirstnd(n, pr, sf, mn, mx);
      if mn < mx then
        for i := mn to mx do
          NewMem(pr + '[' + IntToStr(i) + ']' + sf, tpe, val)
      else if mn > mx then
        for i := mx to mn do
          NewMem(pr + '[' + IntToStr(i) + ']' + sf, tpe, val)
      else if mn = mx then
        NewMem(pr + '[' + IntToStr(mn) + ']' + sf, tpe, val);
      exit;
    end;
    if validname(n) = False then
      error('Invalid name "' + n + '"');

    if n[1] = '$' then
    begin
      newVar.isConstant := True;
      Delete(n, 1, 1);
    end
    else
      newVar.isConstant := False;

    if (memoryExist(n)) or (ispublic(n)) or (isarray(n)) then
      error('Dublicate memory link');
    newVar.link := n;
    newVar.val := tpe;
    if (isstr(val)) and (tpe <> ds) then
      error('Illegal type string');
    case tpe of
      db: newVar.valbyte := val;
      dw: newVar.valword := val;
      dd: newVar.valint := val;
      dd8: newVar.valshort := val;
      dd32: newVar.valint32 := val;
      dd64: newVar.valint64 := val;
      df: newVar.valfloat := val;
      dfa: newVar.valdouble := val;
      dfb: newVar.valextended := val;
      dc: newVar.valchar := val;
      ds: newVar.valstr := val;
      du: newVar.valdyn := val;
      dp: newVar.valptr := val;
      else
        error('Internal error.');
    end;
    SetLength(Memory,
      Length(Memory) + 1);
    Memory[length(Memory) - 1] :=
      newVar;

  end;

  procedure TASMLLInterprer.NewPublicMem(n: string; tpe: TValType; val: variant);

  var
    newVar: TVarM;
    i: longint;
  var
    pr, sf: string;
    mn, mx: longint;
  begin
    n := ReplaceStr(n, '&', calllbllst[Length(calllbllst) - 1]);
    pr := '';
    sf := '';
    mn := 0;
    mx := 0;
    if pos('*', n) <> 0 then
      n := parsePtr(n);
    if pos('[', n) <> 0 then
      n := getarrname(n);
    if pos(':', n) <> 0 then
    begin
      getfirstnd(n, pr, sf, mn, mx);
      if mn < mx then
        for i := mn to mx do
          NewPublicMem(pr + '[' + IntToStr(i) + ']' + sf, tpe, val)
      else if mn > mx then
        for i := mx to mn do
          NewPublicMem(pr + '[' + IntToStr(i) + ']' + sf, tpe, val)
      else if mn = mx then
        NewPublicMem(pr + '[' + IntToStr(mn) + ']' + sf, tpe, val);
      exit;
    end;
    if validname(n) = False then
      error('Invalid name "' + n + '"');

    if n[1] = '$' then
    begin
      newVar.isConstant := True;
      Delete(n, 1, 1);
    end
    else
      newVar.isConstant := False;

    if (memoryExist(n)) or (ispublic(n)) or (isarray(n)) then
      error('Dublicate memory link');
    newVar.link := n;
    newVar.val := tpe;
    if (isstr(val)) and (tpe <> ds) then
      error('Illegal type string');
    case tpe of
      db: newVar.valbyte := val;
      dw: newVar.valword := val;
      dd: newVar.valint := val;
      dd8: newVar.valshort := val;
      dd32: newVar.valint32 := val;
      dd64: newVar.valint64 := val;
      df: newVar.valfloat := val;
      dfa: newVar.valdouble := val;
      dfb: newVar.valextended := val;
      dc: newVar.valchar := val;
      ds: newVar.valstr := val;
      du: newVar.valdyn := val;
      dp: newVar.valptr := val;
      else
        error('Internal error.');
    end;
    SetLength(PublicMemory,
      Length(PublicMemory) + 1);
    PublicMemory[length(PublicMemory) - 1] :=
      newVar;

  end;


  procedure TASMLLInterprer.SetMem(link: string; tpe: TValType; Val: variant);
  var
    i: longint;
  begin
    if isPublic(link) then
    begin
      link := ReplaceStr(link, '&', calllbllst[Length(calllbllst) - 1]);
      i := GMem(link);
      if (publicmemory[i].isConstant = True) then
        error('Overriding constants');
      if (publicmemory[i].val <> tpe) then
        error('Invalid type');
      case tpe of
        db: PublicMemory[i].ValByte := val;
        dw: PublicMemory[i].ValWord := val;
        dd: PublicMemory[i].ValInt := val;
        dd8: PublicMemory[i].valshort := val;
        dd32: PublicMemory[i].valint32 := val;
        dd64: PublicMemory[i].valint64 := val;
        df: PublicMemory[i].ValFloat := val;
        dfa: PublicMemory[i].Valdouble := val;
        dfb: PublicMemory[i].ValExtended := val;
        dc: PublicMemory[i].Valchar := val;
        ds: PublicMemory[i].Valstr := val;
        du: PublicMemory[i].ValDyn := val;
        dp: PublicMemory[i].ValPtr := val;
        else
          error('Internal error.');
      end;
    end
    else
    begin
      i := GMem(link);
      if (memory[i].isConstant = True) then
        error('Overriding constants');
      if (memory[i].val <> tpe) then
        error('Invalid type');
      case tpe of
        db: Memory[i].ValByte := val;
        dw: Memory[i].ValWord := val;
        dd: Memory[i].ValInt := val;
        dd8: Memory[i].ValShort := val;
        dd32: Memory[i].ValInt32 := val;
        dd64: Memory[i].ValInt64 := val;
        df: Memory[i].Valfloat := val;
        dfa: Memory[i].Valdouble := val;
        dfb: Memory[i].ValExtended := val;
        dc: Memory[i].Valchar := val;
        ds: Memory[i].Valstr := val;
        du: Memory[i].ValDyn := val;
        dp: Memory[i].ValPtr := val;
        else
          error('Internal error.');
      end;
    end;
  end;

  {record type}
type
  TRecordTree = record
    suffix: string;
    typevl: TValType;
    defval: variant;
  end;

type
  TRecord = record
    Name: string;
    tree: array of TRecordTree;
  end;

var
  Records: array of TRecord;

  function recExist(n: string): boolean;

  var
    i: integer;
  begin
    Result := False;
    if length(Records) = 0 then
      exit;
    Result := True;
    for i := 0 to length(Records) - 1 do
      if Records[i].Name = n then
        exit;
    Result := False;

  end;

  function TASMLLInterprer.recId(n: string): integer;

  var
    i: integer;
  begin
    if recExist(n) = False then
      error('Struct not found @' + n);
    for i := 0 to length(Records) - 1 do
      if Records[i].Name = n then
      begin
        Result := i;
        exit;
      end;

  end;

  procedure TASMLLInterprer.initRec(n: string; tn: string);
  var
    TRec: TRecord;
    i: integer;
  begin
    TRec := Records[recID(tn)];
    newmem(n, dp, n);  //самоссылка
    for i := 0 to length(TRec.tree) - 1 do
      newMem(n + '.' + TRec.tree[i].suffix,
        TRec.tree[i].typevl,
        TRec.tree[i].defval);
  end;


  procedure TASMLLInterprer.initPublicRec(n: string; tn: string);
  var
    TRec: TRecord;
    i: integer;
  begin
    TRec := Records[recID(tn)];
    for i := 0 to length(TRec.tree) - 1 do
      newPublicMem(n + '.' + TRec.tree[i].suffix,
        TRec.tree[i].typevl,
        TRec.tree[i].defval);
  end;

  procedure TASMLLInterprer.remRec(n: string; tn: string);
  var
    TRec: TRecord;
    i: integer;
  begin
    TRec := Records[recID(tn)];
    for i := 0 to length(TRec.tree) - 1 do
      RemMem(n + '.' + TRec.tree[i].suffix);
  end;

  procedure newRec(n: string; suflst: array of string; valtypelst: array of tvaltype;
    defvals: array of variant);
  var
    i: integer;
  begin
    SetLength(Records, length(Records) + 1);
    with Records[length(records) - 1] do
    begin
      Name := n;
      setlength(tree, length(suflst));
      for i := 0 to length(tree) - 1 do
      begin
        tree[i].suffix := suflst[i];
        tree[i].typevl := valtypelst[i];
        tree[i].defval := defvals[i];
      end;
    end;
  end;


  procedure TASMLLInterprer.checkrecords;
  var
    i, x, rid, y, ind, b, c: integer;
    n: string;
    //data table
    namerec: string;
    valbuf: string;
    suflst: array of string;
    typelst: array of TValType;
    vallst: array of variant;
  begin
    setlength(records, 0);
    for i := 0 to length(arrc) - 1 do
      if arrc[i][0] = 'struct' then
      begin
        namerec := arrc[i][1];
        if recexist(namerec) then
          error('Dublicate record name @' + arrc[i][1]);
        if validlblname(namerec) = False then
          error('Invalid name "' + namerec + '"');
        if length(arrc[i]) <> 2 then
          error('Invalid structure');

        SetLength(suflst, 0);
        SetLength(typelst, 0);
        SetLength(vallst, 0);

        for x := i + 1 to length(arrc) - 1 do
        begin
          n := RepSynonym(arrc[x][0]);
          if n = 'end' then
            break;
          SetLength(suflst, length(suflst) + 1);
          SetLength(typelst, length(typelst) + 1);
          SetLength(vallst, length(vallst) + 1);
          suflst[length(suflst) - 1] := arrc[x][1];

          if n = 'extends' then
          begin
            if recExist(arrc[x][1]) = False then
              error('Struct ' + namerec + ' extends error.');
            ind := recID(arrc[x][1]);
            b := length(records[ind].tree);
            for c := 0 to b - 1 do
            begin
              SetLength(suflst, length(suflst) + 1);
              SetLength(typelst, length(typelst) + 1);
              SetLength(vallst, length(vallst) + 1);
              suflst[length(suflst) - 1] := records[ind].tree[c].suffix;
              typelst[length(typelst) - 1] := records[ind].tree[c].typevl;
              vallst[length(vallst) - 1] := records[ind].tree[c].defval;
            end;
          end
          else
          if recExist(n) then
          begin
            rid := recID(n);
            for y := 0 to length(records[rid].tree) - 1 do
            begin
              SetLength(suflst, length(suflst) + 1);
              SetLength(typelst, length(typelst) + 1);
              SetLength(vallst, length(vallst) + 1);
              suflst[length(suflst) - 1] :=
                arrc[x][1] + '.' + records[rid].tree[y].suffix;
              typelst[length(typelst) - 1] := records[rid].tree[y].typevl;
              vallst[length(vallst) - 1] := records[rid].tree[y].defval;
            end;
          end
          else
          begin
            if n = 'byte' then
              typelst[length(typelst) - 1] := db
            else
            if n = 'word' then
              typelst[length(typelst) - 1] := dw
            else
            if n = 'short' then
              typelst[length(typelst) - 1] := dd8
            else
            if n = 'int' then
              typelst[length(typelst) - 1] := dd
            else
            if n = 'int32' then
              typelst[length(typelst) - 1] := dd32
            else
            if n = 'int64' then
              typelst[length(typelst) - 1] := dd64
            else
            if n = 'float' then
              typelst[length(typelst) - 1] := df
            else
            if n = 'double' then
              typelst[length(typelst) - 1] := dfa
            else
            if n = 'extended' then
              typelst[length(typelst) - 1] := dfb
            else
            if n = 'char' then
              typelst[length(typelst) - 1] := dc
            else
            if n = 'str' then
              typelst[length(typelst) - 1] := ds
            else
            if n = 'var' then
              typelst[length(typelst) - 1] := du
            else
            if n = 'ptr' then
              typelst[length(typelst) - 1] := dp
            else
              error('Record structure not correct');

            valbuf := arrc[x][2];
            if isdigit(valbuf) then
              vallst[length(vallst) - 1] := str2float(valbuf)
            else
            if (isstr(valbuf)) and (typelst[length(typelst) - 1] = dp) then
              vallst[length(vallst) - 1] := lowercase(extractstr(valbuf))
            else
            if isstr(valbuf) then
              vallst[length(vallst) - 1] := valbuf
            else
            if isrbin32(valbuf) then
              vallst[length(vallst) - 1] := rbin32toint(valbuf)
            else
            if valbuf[1] = '@' then
              vallst[length(vallst) - 1] :=
                copy(valbuf, 2, length(valbuf))
            else
            if valbuf = '?' then
            begin
              if typelst[length(typelst) - 1] in [db, dw, dd, df, dfa,
                dfb, dd8, dd32, dd64] then
                vallst[length(vallst) - 1] := 0
              else
              if typelst[length(typelst) - 1] in [ds, du] then
                vallst[length(vallst) - 1] := ''
              else
              if typelst[length(typelst) - 1] = dc then
                vallst[length(vallst) - 1] := #0
              else
              if typelst[length(typelst) - 1] = dp then
                vallst[length(vallst) - 1] := '';
            end
            else
              error('Invalid value');
          end;
        end;
        newRec(namerec, suflst, typelst, vallst);
      end;
  end;

  procedure TASMLLInterprer.checkpublic;
  var
    i: integer;
    //data table
    typebuf: TValType;
    namebuf: string;
    valbuf: string;
    val: variant;
    isRec: boolean;
  begin
    setlength(publicmemory, 0);
    for i := 0 to length(arrc) - 1 do
      if arrc[i][0] = 'data' then
      begin
        arrc[i][1] := RepSynonym(arrc[i][1]);
        if length(arrc[i]) > 4 then
          error('Invalid data block');
        isRec := False;
        if arrc[i][1] = 'byte' then
          typebuf := db
        else
        if arrc[i][1] = 'word' then
          typebuf := dw
        else
        if arrc[i][1] = 'short' then
          typebuf := dd8
        else
        if arrc[i][1] = 'int' then
          typebuf := dd
        else
        if arrc[i][1] = 'int32' then
          typebuf := dd32
        else
        if arrc[i][1] = 'int64' then
          typebuf := dd64
        else
        if arrc[i][1] = 'float' then
          typebuf := df
        else
        if arrc[i][1] = 'double' then
          typebuf := dfa
        else
        if arrc[i][1] = 'extended' then
          typebuf := dfb
        else
        if arrc[i][1] = 'char' then
          typebuf := dc
        else
        if arrc[i][1] = 'str' then
          typebuf := ds
        else
        if arrc[i][1] = 'var' then
          typebuf := du
        else
        if arrc[i][1] = 'ptr' then
          typebuf := dp
        else
        if recExist(arrc[i][1]) then
        begin
          initpublicrec(arrc[i][2], arrc[i][1]);
          isrec := True;
        end
        else
          error('Data structure not correct');
        if isrec = False then
        begin
          namebuf := arrc[i][2];
          valbuf := arrc[i][3];
          if isdigit(valbuf) then
            val := str2float(valbuf)
          else
          if isstr(valbuf) then
            val := valbuf
          else
          if isrbin32(valbuf) then
            val := rbin32toint(valbuf)
          else
          if valbuf = '?' then
          begin
            if typebuf in [db, dw, dd, df, dfa, dfb, dd8, dd32, dd64] then
              val := 0
            else
            if typebuf in [ds, du, dp] then
              val := ''
            else
            if typebuf = dc then
              val := #0;
          end
          else
            error('Invalid value');
          newpublicmem(namebuf, typebuf, val);
        end;
      end;
  end;

  procedure TASMLLInterprer.ClearMem;
  begin
    SetLength(self.memory, 0);
    SetLength(self.stack.stack, 0);
  end;

{
  Executing code...
}
  procedure TASMLLInterprer.RegLib(n: string; h: THandle);
  begin
    SetLength(libs, length(libs) + 1);
    with libs[length(libs) - 1] do
    begin
      Name := n;
      hndl := h;
    end;
  end;

  function TASMLLInterprer.GetLib(n: string): THandle;
  var
    i: cardinal;
  begin
    for i := 0 to length(libs) - 1 do
      if libs[i].Name = n then
      begin
        Result := libs[i].hndl;
        break;
      end;
  end;

  function TASMLLInterprer.LibRegistered(n: string): boolean;
  var
    i: cardinal;
  begin
    Result := False;
    if length(libs) > 0 then
      for i := 0 to length(libs) - 1 do
        if libs[i].Name = n then
        begin
          Result := True;
          break;
        end;
  end;

  {Adapters}
  procedure TASMLLInterprer.InitImports;
  begin
    Setlength(impl, 0);
    Setlength(libs, 0);
  end;

  procedure TASMLLInterprer.RegFunc(n: string; f: ptpfunc);
  begin
    setlength(impl, length(impl) + 1);
    with impl[length(impl) - 1] do
    begin
      Name := n;
      func := f;
    end;
  end;

  function TASMLLInterprer.getIndex(n: string): integer;

  var
    i: cardinal;
  begin
    for i := 0 to length(impl) - 1 do
      if impl[i].Name = n then
      begin
        Result := i;
        exit;
      end;
    error('Invalid invoke, @' + n + ' not found');

  end;

  function TASMLLInterprer.doInvoke(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid adapter calling');
    TPFunc(impl[getIndex(arrc[line][1])].func)(@Self.stack);
    Result := line + 1;
  end;

  procedure TASMLLInterprer.doImports;
  var
    i: cardinal;
    buf, fname, dfname: string;
    lib: THandle;
    func: ^TPFunc;
  begin
    for i := 0 to length(arrc) - 1 do
    begin
      if arrc[i][0] = 'import' then
      begin
        if length(arrc[i]) <> 4 then
          error('Invalid import construction');
        buf :=
          extractstr(arrc[i][1]);
        fname := extractstr(arrc[i][2]);
        dfname := arrc[i][3];
        if fileexists(extractfiledir(ParamStr(0)) + '\adp\' + buf) then
          buf := extractfiledir(ParamStr(0)) + '\adp\' + buf
        else
          buf := extractfiledir(MainClassPath) + '\' + buf;
        if fileexists(buf) = False then
          error('Library "' + buf + '" not found"');

        if LibRegistered(buf) then
          lib := GetLib(buf)
        else
        begin
          Lib := LoadLibrary(buf);
          RegLib(buf, lib);
        end;

        if lib >= 32 then
        begin
          func := getprocaddress(Lib, fname);
          if func <> nil then
            RegFunc(lowercase(dfname), func)
          else
            error('Assign imported function failed');
        end
        else
          error('Import functions failed');
      end;
    end;
  end;

  {cmdline params&Basic data}
  procedure TASMLLInterprer.initParamStr;
  var
    i: word;
  begin
    NewPublicMem('$argc', DW, ParamCount);
    for i := 0 downto ParamCount do
      NewPublicMem('$args[' + IntToStr(i) + ']', DS, '"' + ParamStr(i) + '"');
  end;

  {Memory dynamic create call's}

  function TASMLLInterprer.doDB(line: cardinal): cardinal;

  var
    val: byte;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], db, val);

  end;

  function TASMLLInterprer.doDW(line: cardinal): cardinal;

  var
    val: word;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if arrc[line][2] = '?' then
      val := 0
    else if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dw, val);

  end;


  function TASMLLInterprer.doDD8(line: cardinal): cardinal;

  var
    val: longint;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dd8, val);

  end;

  function TASMLLInterprer.doDD(line: cardinal): cardinal;

  var
    val: longint;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dd, val);

  end;

  function TASMLLInterprer.doDD64(line: cardinal): cardinal;

  var
    val: longint;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dd64, val);

  end;

  function TASMLLInterprer.doDD32(line: cardinal): cardinal;

  var
    val: longint;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := StrToInt(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dd32, val);

  end;

  function TASMLLInterprer.doDF(line: cardinal): cardinal;

  var
    val: double;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := str2float(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], df, val);

  end;

  function TASMLLInterprer.doDFa(line: cardinal): cardinal;

  var
    val: double;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := str2float(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dfa, val);

  end;

  function TASMLLInterprer.doDFB(line: cardinal): cardinal;

  var
    val: double;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := 0
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      val := str2float(arrc[line][2])
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dfb, val);

  end;

  function TASMLLInterprer.doDC(line: cardinal): cardinal;

  var
    val: char;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := #0
    else
    if isdigit(arrc[line][2]) then
      val := chr(StrToInt(arrc[line][2]))
    else
    if isrbin32(arrc[line][2]) then
      val := chr(rbin32toint(arrc[line][2]))
    else
    if (isstr(arrc[line][2])) and (length(extractstr(arrc[line][2])) = 1) then
      val := extractstr(arrc[line][2])[1]
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dc, val);

  end;


  function TASMLLInterprer.doDP(line: cardinal): cardinal;

  var
    val: string;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := ''
    else
    if isstr(arrc[line][2]) then
      val := lowercase(extractstr(arrc[line][2]))
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], dp, val);

  end;

  function TASMLLInterprer.doDS(line: cardinal): cardinal;

  var
    val: string;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');

    if arrc[line][2] = '?' then
      val := ''
    else
    if isstr(arrc[line][2]) then
      val := arrc[line][2]
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], ds, val);

  end;

  function TASMLLInterprer.doDU(line: cardinal): cardinal;

  var
    val: variant;
  begin
    Result := line + 1;
    if length(arrc[line]) = 2 then
    begin
      newMem(arrc[line][1], dp, arrc[line][1]);
      exit;
    end;
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if arrc[line][2] = '?' then
      val := 0
    else
    if isdigit(arrc[line][2]) then
      val := str2float(arrc[line][2])
    else
    if isrbin32(arrc[line][2]) then
      val := rbin32toint(arrc[line][2])
    else
    if isstr(arrc[line][2]) then
      val := arrc[line][2]
    else
      val := getval(getmem(arrc[line][2]));
    newMem(arrc[line][1], du, val);

  end;

  {Try block}
  function TASMLLInterprer.doTry(line: cardinal; mode: boolean): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    if (mode = trymode) and (mode = True) then
      error('Try mode error');
    trymode := mode;
    Result := line + 1;
  end;

  function TASMLLInterprer.doLastErr(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    pushst(try_error);
    try_error := '0';
    Result := line + 1;
  end;

  procedure TASMLLInterprer.initTRY;
  begin
    trymode := False;
    try_error := '0';
  end;

  function TASMLLInterprer.doJP(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    trymode := False;
    Result := lbls[getlbl(arrc[line][1])].codepos;
  end;

  function TASMLLInterprer.doJC(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    trymode := False;
    Pushret(line + 1);
    SetLength(calllbllst, length(calllbllst) + 1);
    calllbllst[Length(calllbllst) - 1] := arrc[line][1];
    if pos(':', arrc[line][1]) <> 0 then
    begin
      pushst(getval(getmem(copy(arrc[line][1], 1, pos(':', arrc[line][1]) - 1))));
      Result := lbls[getlbl(ReplaceStr(arrc[line][1], ':', '.') + '*')].codepos;
      calllbllst[Length(calllbllst) - 1] :=
        parsePtr(ReplaceStr(arrc[line][1], ':', '.') + '*');
    end
    else
      Result := lbls[getlbl(arrc[line][1])].codepos;
  end;

  function TASMLLInterprer.doJR(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    trymode := False;
    //SetLength(self.calllbllst, length(calllbllst) - 1);
    Result := PopRet;
  end;

  function TASMLLInterprer.doRem(line: cardinal): cardinal;

  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    if arrc[line][1] = 'memory' then
    begin
      setlength(memory, 0);
      Result := line + 1;
      exit;
    end;
    remmem(arrc[line][1]);
    Result := line + 1;
  end;

  function TASMLLInterprer.doRemRec(line: cardinal): cardinal;
  begin //type, name
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    remrec(arrc[line][2], arrc[line][1]);
    Result := line + 1;
  end;



  function TASMLLInterprer.doPush(line: cardinal): cardinal;

  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    if arrc[line][1] = 'memory' then
    begin
      setlength(stackmemory, length(stackmemory) + 1);
      stackmemory[length(stackmemory) - 1] := memory;
      Result := line + 1;
      exit;
    end;
    if arrc[line][1] = 'lm1' then
    begin
      pushst(logicmem1);
      Result := line + 1;
      exit;
    end;
    if arrc[line][1] = 'lm2' then
    begin
      pushst(logicmem2);
      Result := line + 1;
      exit;
    end;
    if isdigit(arrc[line][1]) then
      pushst(str2float(arrc[line][1]))
    else if isstr(arrc[line][1]) then
      pushst(arrc[line][1])
    else if isrbin32(arrc[line][1]) then
      pushst(rbin32toint(arrc[line][1]))
    else
      pushst(getval(getmem(arrc[line][1])));
    Result := line + 1;

  end;

  function TASMLLInterprer.doPop(line: cardinal): cardinal;

  var
    s: string;
  begin
    if length(arrc[line]) = 0 then
    begin
      popst;
    end
    else
    begin
      if length(arrc[line]) > 2 then
        error('Invalid instruction');
      if arrc[line][1] = 'memory' then
      begin
        memory := stackmemory[length(stackmemory) - 1];
        setlength(stackmemory, length(stackmemory) - 1);
        Result := line + 1;
        exit;
      end;

      if arrc[line][1] = 'lm1' then
      begin
        logicmem1 := popst;
        Result := line + 1;
        exit;
      end;
      if arrc[line][1] = 'lm2' then
      begin
        logicmem2 := popst;
        Result := line + 1;
        exit;
      end;

      if pos('@', arrc[line][1]) <> 0 then
      begin
        s := popst;
        if isstr(s) then
          s := extractstr(s);
        setmem(copy(arrc[line][1], 2, length(arrc[line][1])), dp, s);
        Result := line + 1;
        exit;
      end;
      SetMem(arrc[line][1], getmem(arrc[line][1]).val, popst);
    end;
    Result := line + 1;

  end;

  function TASMLLInterprer.doPeek(line: cardinal): cardinal;

  var
    s: string;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    if arrc[line][1] = 'memory' then
    begin
      memory := stackmemory[length(stackmemory) - 1];
      Result := line + 1;
      exit;
    end;

    if arrc[line][1] = 'lm1' then
    begin
      logicmem1 := stackmemory[length(stackmemory) - 1];
      Result := line + 1;
      exit;
    end;
    if arrc[line][1] = 'lm2' then
    begin
      logicmem2 := stackmemory[length(stackmemory) - 1];
      Result := line + 1;
      exit;
    end;

    if pos('@', arrc[line][1]) <> 0 then
    begin
      s := stack.peek;
      if isstr(s) then
        s := extractstr(s);
      setmem(copy(arrc[line][1], 2, length(arrc[line][1])), dp, s);
      Result := line + 1;
      exit;
    end;
    SetMem(arrc[line][1], getmem(arrc[line][1]).val, stack.peek);
    Result := line + 1;

  end;

  function TASMLLInterprer.doSize(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    SetMem(arrc[line][1], getmem(arrc[line][1]).val, stacksize);
    Result := line + 1;
  end;

  function TASMLLInterprer.doMakePublic(line: cardinal): cardinal;
  var
    v: longint;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    if (isPublic(arrc[line][1]) = True) then
      error('pub publish data');
    v := gmem(arrc[line][1]);
    setlength(PublicMemory, length(PublicMemory) + 1);
    PublicMemory[Length(PublicMemory) - 1] := Memory[v];
    Memory[v] := Memory[length(Memory) - 1];
    SetLength(Memory, Length(Memory) - 1);
    Result := line + 1;
  end;

  function TASMLLInterprer.doMov(line: cardinal): cardinal;

  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else
    if isstr(arrc[line][2]) then
      v := arrc[line][2]
    else
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
      v := getval(getmem(arrc[line][2]));
    if pos('@', arrc[line][2]) <> 0 then
    begin
      setmem(arrc[line][1], dp, v);
      Result := line + 1;
      exit;
    end;
    setmem(arrc[line][1], getmem(arrc[line][1]).val, v);
    Result := line + 1;

  end;

  function TASMLLInterprer.doLength(line: cardinal): cardinal;

  var
    v: longint;
    n: string;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    Result := line + 1;
    if isstr(arrc[line][1]) then //string
    begin
      v := length(ExtractStr(arrc[line][1]));
      pushst(v);
      exit;
    end;
    n := arrc[line][1];
    if pos('*', n) <> 0 then
      n := parsePtr(n);
    if pos('[', n) <> 0 then
      n := getarrname(n);

    if (MemoryExist(n)) or (ispublic(n)) then //str variable
    begin
      if GetMem(n).val <> ds then
       //error('Length invalid type')
       v:=0
      else
       v := length(ExtractStr(GetMem(n).valstr));
    end
    else
    if isArray(n) then  //array
      v := ArrLen(n)
    else
     v:=0;
      //error('Length invalid type');
    pushst(v);

  end;

  {logical}
  function TASMLLInterprer.doLM(line: cardinal; lm: byte): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    if isrbin32(arrc[line][1]) then
      v := rbin32toint(arrc[line][1])
    else
    if isdigit(arrc[line][1]) then
      v := str2float(arrc[line][1])
    else if isstr(arrc[line][1]) then
      v := arrc[line][1]
    else
      v := getval(getmem(arrc[line][1]));
    case lm of
      1: LogicMem1 := v;
      2: LogicMem2 := v;
      else
        error('Internal error.');
    end;
    Result := line + 1;
  end;

  function TASMLLInterprer.doIF(line: cardinal; op: byte): cardinal;
  var
    v: boolean;
  begin
    if length(arrc[line]) <> 2 then
      error('Invalid instruction');
    case op of
      1: v := LogicMem1 > LogicMem2;
      2: v := LogicMem1 < LogicMem2;
      3: v := LogicMem1 = LogicMem2;
      4: v := LogicMem1 <> LogicMem2;
      else
        error('Internal error.');
    end;
    if v then
    begin
      if arrc[line][1] = 'block' then
        Result := line + 1
      else
        Result := lbls[getlbl(arrc[line][1])].codepos;
    end
    else
    begin
      if arrc[line][1] = 'block' then
        Result := skipBlock(line)
      else
        Result := line + 1;
    end;
  end;

  function TASMLLInterprer.doCharRead(line: cardinal): cardinal;
  var
    s: string;   // push [string]
    i: longint;  // push [id]
  begin          // charread
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    i := popst;
    s := popst;
    if isstr(s) = False then
      error('Invalid types');
    pushst(extractstr(s)[i]);
    Result := line + 1;
  end;

  function TASMLLInterprer.doCharWrite(line: cardinal): cardinal;
  var
    s: string;   // push [string]
    i: longint;  // push [id]
    c: char;     // push [char]
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    c := popst;
    i := popst;
    s := popst;
    if isstr(s) = False then
      error('Invalid types');
    s := extractstr(s);
    s[i] := c;
    pushst('"' + s + '"');
    Result := line + 1;
  end;

  function TASMLLInterprer.doOrd(line: cardinal): cardinal;
  var
    c: char;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    c := popst;
    pushst(Ord(c));
    Result := line + 1;
  end;

  function TASMLLInterprer.doChr(line: cardinal): cardinal;
  var
    b: byte;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    b := popst;
    pushst(chr(b));
    Result := line + 1;
  end;

  {Computing module}
  function TASMLLInterprer.doAdd(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    Result := line + 1;

    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isstr(arrc[line][2]) then
      v := arrc[line][2]
    else
      v := getval(getmem(arrc[line][2]));

    if getmem(arrc[line][1]).val = ds then
    begin
      if isstr(v) then
        setmem(arrc[line][1], getmem(arrc[line][1]).val,
          '"' + extractstr(getval(getmem(arrc[line][1]))) + extractstr(v) + '"')
      else
        setmem(arrc[line][1], getmem(arrc[line][1]).val,
          '"' + extractstr(getval(getmem(arrc[line][1]))) + VarToStr(v) + '"');
    end
    else
      setmem(arrc[line][1], getmem(arrc[line][1]).val,
        getval(getmem(arrc[line][1])) + v);
  end;

  function TASMLLInterprer.doSub(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) - v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doInc(line: cardinal): cardinal;
  begin
    setmem(arrc[line][1], getmem(arrc[line][1]).val, getval(getmem(arrc[line][1])) + 1);
    Result := line + 1;
  end;

  function TASMLLInterprer.doDec(line: cardinal): cardinal;
  begin
    setmem(arrc[line][1], getmem(arrc[line][1]).val, getval(getmem(arrc[line][1])) - 1);
    Result := line + 1;
  end;

  function TASMLLInterprer.doDiv(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) / v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doIDiv(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) div v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doMod(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) mod v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doMul(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) * v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doShl(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) shl v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doShr(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) shr v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doAnd(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) and v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doOr(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) or v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doPow(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
     exp(ln(getval(getmem(arrc[line][1])))*v)
    );
    Result := line + 1;
  end;

  function TASMLLInterprer.doXor(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val,
      getval(getmem(arrc[line][1])) xor v);
    Result := line + 1;
  end;

  function TASMLLInterprer.doNot(line: cardinal): cardinal;
  var
    v: variant;
  begin
    if length(arrc[line]) <> 3 then
      error('Invalid instruction');
    if isrbin32(arrc[line][2]) then
      v := rbin32toint(arrc[line][2])
    else
    if isdigit(arrc[line][2]) then
      v := str2float(arrc[line][2])
    else if isstr(arrc[line][2]) then
      error('Illegal type string')
    else
      v := getval(getmem(arrc[line][2]));
    setmem(arrc[line][1], getmem(arrc[line][1]).val, not v);
    Result := line + 1;
  end;

  //////////////////////////////////////////////////////////////////////////////
  // Threads

  type TThrData = record
    PEng: PASMLLInterprer;
    SL: cardinal;
    LBLN: string;
  end;

  type PThrData = ^TThrData;

  function ThreadCreate(parameter: pointer) : PtrInt;
  var
    Eng:TASMLLInterprer;
  begin
   Eng:=PThrData(parameter)^.PEng^;
   Eng.Execute(PThrData(parameter)^.SL);
   FreeAndNil(PThrData(parameter)^);
   FreeAndNil(Eng);
   result:=0;
  end;

  function TASMLLInterprer.doThread(line: cardinal): cardinal;
  var
    TID:THandle;
    PDT:PThrData;
  begin
    if length(arrc[line]) <> 2 then error('Invalid instruction');

    new(PDT);
    PDT^.PEng:=@Self;
    PDT^.SL:=lbls[getlbl(arrc[line][1])].codepos;
    PDT^.LBLN:=arrc[line][1];
    TID:=0;
    pushst(BeginThread(nil,0,@ThreadCreate,PDT,0,tid));
    Result := line + 1;
  end;

  function TASMLLInterprer.doSuspendThread(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    SuspendThread(popst);
    Result := line + 1;
  end;

  function TASMLLInterprer.doResumeThread(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    ResumeThread(popst);
    Result := line + 1;
  end;

  function TASMLLInterprer.doTerminateThread(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    KillThread(popst);
    Result := line + 1;
  end;

  function TASMLLInterprer.doThreadWaitFor(line: cardinal): cardinal;
  begin
    if length(arrc[line]) <> 1 then
      error('Invalid instruction');
    pushst(WaitForThreadTerminate(popst,popst));
    Result := line + 1;
  end;

  {Core functions}
type
  PStack = ^TStack;

  //methods core.*
  procedure _Core_Halt(Stack: PStack); cdecl;
  begin
    try
      FreeAndNil(PASMLLInterprer(Stack^.owner)^);
      PASMLLInterprer(Stack^.owner)^.dhalt;
    except
      Halt;
    end;
  end;

 procedure _Core_Except(Stack: PStack); cdecl;
  begin
    raise Exception.Create(Stack^.pop);
  end;

{procedure CrCallExternal(PathToLib,MethodName,EngStack,SSize:Pointer); cdecl;
          external 'crlibmodule.lib' name 'CRCALLEXTERNAL';

procedure _Core_CallExternal(Stack:PStack); cdecl;
var s1,s2:string;
begin
 s1:=ExtractStr(Stack^.pop);
 s2:=ExtractStr(Stack^.pop);
 CrCallExternal(@s1,@s2,@Eng^.Stack,@Eng^.StackSize);
end;}

  procedure _Core_GetUsedMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(Length(PASMLLInterprer(Stack^.owner)^.Memory));
  end;

  procedure _Core_GetFreeMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(2147483647 - Length(PASMLLInterprer(Stack^.owner)^.Memory));
  end;

  procedure _Core_GetTotalMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(2147483647);
  end;

  procedure _Core_GetUsedPublicMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(Length(PublicMemory));
  end;

  procedure _Core_GetFreePublicMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(2147483647 - Length(PublicMemory));
  end;

  procedure _Core_GetTotalPublicMemory(Stack: PStack); cdecl;
  begin
    Stack^.push(2147483647);
  end;


  //DynADP
  procedure _Core_GetAdpMethod(Stack: PStack); cdecl;
  var
    h: THandle;
    p: ^TPFunc;
  begin
    h := LoadLibrary(ExtractStr(Stack^.pop));
    if h >= 32 then
    begin
      p := getprocaddress(h, ExtractStr(Stack^.pop));
      if p <> nil then
        Stack^.push(True)
      else
        Stack^.push(False);
    end
    else
      Stack^.push(False);
  end;

  procedure _Core_RunAdpMethod(Stack: PStack); cdecl;
  var
    h: THandle;
    p: ^TPFunc;
  begin
    h := LoadLibrary(ExtractStr(Stack^.pop));
    if h >= 32 then
    begin
      p := getprocaddress(h, ExtractStr(Stack^.pop));
      if p <> nil then
        TPFunc(p)(Stack)
      else
        Stack^.push(False);
    end
    else
      Stack^.push(False);
  end;


  //REGISTER
  procedure TASMLLInterprer.ImportBasics;
  begin
    RegFunc('core.halt', pTPFunc(@_Core_Halt));
    RegFunc('core.except', pTPFunc(@_Core_Except));
    RegFunc('core.getusedmemory', pTPFunc(@_Core_GetUsedMemory));
    RegFunc('core.getfreememory', pTPFunc(@_Core_GetFreeMemory));
    RegFunc('core.gettotalmemory', pTPFunc(@_Core_GetTotalMemory));
    RegFunc('core.getusedpublicmemory', pTPFunc(@_Core_GetUsedPublicMemory));
    RegFunc('core.getfreepublicmemory', pTPFunc(@_Core_GetFreePublicMemory));
    RegFunc('core.gettotalpublicmemory', pTPFunc(@_Core_GetTotalPublicMemory));
    RegFunc('core.getadpmethod', pTPFunc(@_Core_GetAdpMethod));
    RegFunc('core.runadpmethod', pTPFunc(@_Core_RunAdpMethod));
    //RegFunc('core.callexternal',pTPFunc(@_Core_CallExternal));
  end;

  {Execute}

  function TASMLLInterprer.ExLine(line: cardinal): cardinal;
  var
    n: string;
  begin
    n := arrc[line][0];
    look := line + 1;
    try
      n := RepSynonym(n);

      if n = 'label' then
        look := line + 1
      else
      if n = 'public' then
        look := line + 1
      else
      if n = 'uses' then
        look := line + 1
      else
      if n = 'struct' then
        look := skipBlock(line)
      else
      if n = 'data' then
        look := line + 1
      else
      if n = 'thrc' then
        look := doThread(line)
      else
      if n = 'thrr' then
        look := doResumeThread(line)
      else
      if n = 'thrs' then
        look := doSuspendThread(line)
      else
      if n = 'thrt' then
        look := doTerminateThread(line)
      else
      if n = 'thrw' then
        look := doThreadWaitFor(line)
      else
      if n = 'import' then
        look := line + 1
      else
      if n = 'end' then
        look := doTry(line, False){r:=line+1}
      else
      if n = 'define' then
        look := line + 1
      else
      if n = 'try' then
        look := doTry(line, True)
      else
      if n = 'lasterr' then
        look := doLastErr(line)
      else
      if n = 'extends' then
        error('Invalid construction.')
      else
      if n = 'nop' then
        look := line + 1
      else

      if n = 'short' then
        look := doDD8(line)
      else
      if n = 'int' then
        look := doDD(line)
      else
      if n = 'int32' then
        look := doDD32(line)
      else
      if n = 'int64' then
        look := doDD64(line)
      else
      if n = 'byte' then
        look := doDB(line)
      else
      if n = 'word' then
        look := doDW(line)
      else
      if n = 'float' then
        look := doDF(line)
      else
      if n = 'double' then
        look := doDFa(line)
      else
      if n = 'extended' then
        look := doDFb(line)
      else
      if n = 'char' then
        look := doDC(line)
      else
      if n = 'ptr' then
        look := doDP(line)
      else
      if n = 'str' then
        look := doDS(line)
      else
      if n = 'var' then
        look := doDU(line)
      else

      if n = 'length' then
        look := doLENGTH(line)
      else

      if n = 'pub' then
        look := doMakePublic(line)
      else
      if n = 'rem' then
        look := doRem(line)
      else
      if n = 'remrec' then
        look := doRemRec(line)
      else

      if n = 'jump' then
        look := doJP(line)
      else
      if n = 'call' then
        look := doJC(line)
      else
      if n = 'invoke' then
        look := doInvoke(line)
      else
      if n = 'return' then
        look := doJR(line)
      else

      if n = 'push' then
        look := doPush(line)
      else
      if n = 'pop' then
        look := doPop(line)
      else
      if n = 'size' then
        look := doSize(line)
      else
      if n = 'peek' then
        look := doPeek(line)
      else

      if n = 'mov' then
        look := doMov(line)
      else
      if n = 'add' then
        look := doAdd(line)
      else
      if n = 'sub' then
        look := doSub(line)
      else
      if n = 'mul' then
        look := doMul(line)
      else
      if n = 'div' then
        look := doDiv(line)
      else
      if n = 'idiv' then
        look := doIDiv(line)
      else
      if n = 'mod' then
        look := doMod(line)
      else
      if n = 'shl' then
        look := doShl(line)
      else
      if n = 'shr' then
        look := doShr(line)
      else
      if n = 'and' then
        look := doAnd(line)
      else
      if n = 'or' then
        look := doOr(line)
      else
      if n = 'pow' then
        look := doPow(line)
      else
      if n = 'xor' then
        look := doXor(line)
      else
      if n = 'not' then
        look := doNot(line)
      else
      if n = 'inc' then
        look := doInc(line)
      else
      if n = 'dec' then
        look := doDec(line)
      else

      if n = 'lm1' then
        look := doLM(line, 1)
      else//logic a
      if n = 'lm2' then
        look := doLM(line, 2)
      else//logic b
      if n = 'ifb' then
        look := doIF(line, 1)
      else//a>b
      if n = 'ifs' then
        look := doIF(line, 2)
      else//a<b
      if n = 'ife' then
        look := doIF(line, 3)
      else//a=b
      if n = 'ifn' then
        look := doIF(line, 4)
      else//a!=b

      if n = 'chrrd' then
        look := doCHARREAD(line)
      else
      if n = 'chrwr' then
        look := doCHARWRITE(line)
      else
      if n = 'ord' then
        look := doORD(line)
      else
      if n = 'chr' then
        look := doCHR(line)
      else

      //record
      if recExist(n) then
      begin
        initrec(arrc[line][1], n);
        look := line + 1;
      end
      else
        error('Invalid operator "' + arrc[line][0] + '"');

    except
      on E: Exception do
        if trymode = True then
        begin
          try_error := ('ClassName:"' + E.ClassName + '"; Message:"' + E.Message + '".');
          look := skipBlock(line);
        end
        else
        begin
          writeln('[' + datetimetostr(now) + '] [ERROR] - ClassName:"' +
            E.ClassName + '"; Message:"' + E.Message + '".');
          dhalt;
        end;
    end;
    Result := look;
  end;

  procedure TASMLLInterprer.Execute(line: cardinal);
  begin
    repeat
      line := ExLine(line);
      //crasm_tact_counter:=crasm_tact_counter+1;
    until line = length(arrc);
  end;

  procedure TASMLLInterprer.DHalt;
  begin
    Halt;
  end;

{
 Start program...
}

var
  f: textfile;
  buf: string;
  eng: TASMLLInterprer;
  labelname: string;
begin
  {$ifdef unix}
     {$ifdef UseCthreads}
       SetCThreadManager;
     {$endif}
  {$endif}
  labelname := 'main';
  if trim(ParamStr(1)) = '' then
  begin
    writeln('Assembly-like language interprer.');
    writeln('Pavel Shiriaev (c) 2016.');
    writeln('ver ' + ver, '.');
    writeln;
    writeln('use: exe <path to script>');
    halt;
  end;
  MainClassPath := ParamStr(1);
  eng.AcpgPath := MainClassPath;
  if fileexists(ParamStr(1)) = False then
  begin
    writeln('File not found');
    halt;
  end;
  DefaultFormatSettings.DecimalSeparator := '.';
  try
    Assign(f, eng.acpgpath);
    reset(f);
    eng.initsrcrd;
    repeat
      readln(f, buf);
      eng.parsecodeline(buf);
    until EOF(f);
    Close(f);
    SetLength(eng.calllbllst, 1);
    eng.calllbllst[0] := labelname;
    eng.stack.owner := @eng;
    eng.doHeader;
    eng.doInclude;
    eng.convert;
    eng.initImports;
    eng.initTRY;
    eng.checklabels;
    eng.PrepSynonyms;
    eng.checkrecords;
    eng.checkpublic;
    eng.initParamStr;
    eng.doImports;
    eng.ImportBasics;
  except
    on E: Exception do
    begin
      Writeln('[LAUNCH ERROR!], ClassName:"' + E.ClassName +
        '"; Message:"' + E.Message + '".');
      halt;
    end;
  end;
  //crasm_tact_counter:=0;
  eng.Execute(eng.lbls[eng.getlbl(labelname)].codepos);
  eng.dhalt;
end.
