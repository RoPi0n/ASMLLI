unit layoutform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, types, LMessages, LCLType, variants;

type

  { TLayout }

  TLayout = class(TForm)
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormDblClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    function FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean
      ): Boolean;
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure FormUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure FormWindowStateChange(Sender: TObject);
  private

  public
    CanCloseForm:boolean;
    EventReceived:boolean;
    LastEvent:word;
    LastEventArg:array of variant;
  end;

implementation

{$R *.lfm}

{ TLayout }

procedure TLayout.FormActivate(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=1;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormChangeBounds(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=2;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormClick(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=3;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  EventReceived:=true;
  LastEvent:=4;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  EventReceived:=true;
  LastEvent:=5;
  SetLength(LastEventArg,0);
  CanClose:=CanCloseForm;
end;

procedure TLayout.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  EventReceived:=true;
  LastEvent:=6;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=MousePos.x;
  LastEventArg[1]:=MousePos.y;
end;

procedure TLayout.FormDblClick(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=7;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormDeactivate(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=8;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormDestroy(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=9;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=10;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
end;

procedure TLayout.FormDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  EventReceived:=true;
  LastEvent:=11;
  SetLength(LastEventArg,3);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
  LastEventArg[2]:=State;
end;

procedure TLayout.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=12;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
end;

procedure TLayout.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  EventReceived:=true;
  LastEvent:=13;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
end;

procedure TLayout.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var i:integer;
begin
  EventReceived:=true;
  LastEvent:=14;
  SetLength(LastEventArg,length(FileNames)+1);
  LastEventArg[0]:=length(FileNames);
  for i:=1 to length(FileNames) do
   LastEventArg[i]:=FileNames[i-1];
end;

procedure TLayout.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=15;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
end;

procedure TLayout.FormGetSiteInfo(Sender: TObject; DockClient: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  EventReceived:=true;
  LastEvent:=16;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=MousePos.x;
  LastEventArg[1]:=MousePos.y;
end;

function TLayout.FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean): Boolean;
begin
  EventReceived:=true;
  LastEvent:=17;
  SetLength(LastEventArg,0);
  Result:=true;
end;

procedure TLayout.FormHide(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=18;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  EventReceived:=true;
  LastEvent:=19;
  SetLength(LastEventArg,1);
  LastEventArg[0]:=Key;
end;

procedure TLayout.FormKeyPress(Sender: TObject; var Key: char);
begin
  EventReceived:=true;
  LastEvent:=20;
  SetLength(LastEventArg,1);
  LastEventArg[0]:=Key;
end;

procedure TLayout.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  EventReceived:=true;
  LastEvent:=21;
  SetLength(LastEventArg,1);
  LastEventArg[0]:=Key;
end;

procedure TLayout.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=22;
  SetLength(LastEventArg,3);
  LastEventArg[0]:=Button;
  LastEventArg[1]:=x;
  LastEventArg[2]:=y;
end;

procedure TLayout.FormMouseEnter(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=23;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormMouseLeave(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=24;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=25;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=x;
  LastEventArg[1]:=y;
end;

procedure TLayout.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  EventReceived:=true;
  LastEvent:=26;
  SetLength(LastEventArg,3);
  LastEventArg[0]:=Button;
  LastEventArg[1]:=x;
  LastEventArg[2]:=y;
end;

procedure TLayout.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  EventReceived:=true;
  LastEvent:=27;
  SetLength(LastEventArg,3);
  LastEventArg[0]:=WheelDelta;
  LastEventArg[1]:=MousePos.x;
  LastEventArg[2]:=MousePos.y;
end;

procedure TLayout.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  EventReceived:=true;
  LastEvent:=28;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=MousePos.x;
  LastEventArg[1]:=MousePos.y;
end;

procedure TLayout.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  EventReceived:=true;
  LastEvent:=29;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=MousePos.x;
  LastEventArg[1]:=MousePos.y;
end;

procedure TLayout.FormResize(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=30;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormShortCut(var Msg: TLMKey; var Handled: Boolean);
begin
  EventReceived:=true;
  LastEvent:=31;
  SetLength(LastEventArg,2);
  LastEventArg[0]:=Msg.CharCode;
  LastEventArg[1]:=Msg.Msg;
end;

procedure TLayout.FormShow(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=32;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormShowHint(Sender: TObject; HintInfo: PHintInfo);
begin
  EventReceived:=true;
  LastEvent:=33;
  SetLength(LastEventArg,3);
  LastEventArg[0]:='"'+HintInfo^.HintStr+'"';
  LastEventArg[1]:=HintInfo^.HintPos.x;
  LastEventArg[2]:=HintInfo^.HintPos.y;
end;

procedure TLayout.FormStartDock(Sender: TObject; var DragObject: TDragDockObject
  );
begin
  EventReceived:=true;
  LastEvent:=34;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  EventReceived:=true;
  LastEvent:=35;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  EventReceived:=true;
  LastEvent:=36;
  SetLength(LastEventArg,1);
  LastEventArg[0]:='"'+UTF8Key+'"';
end;

procedure TLayout.FormWindowStateChange(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=37;
  SetLength(LastEventArg,0);
end;

procedure TLayout.FormPaint(Sender: TObject);
begin
  EventReceived:=true;
  LastEvent:=38;
  SetLength(LastEventArg,0);
end;

end.

