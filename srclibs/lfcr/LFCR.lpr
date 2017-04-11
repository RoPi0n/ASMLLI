library LFCR;

{$mode objfpc}{$H+}

uses
  Classes,SysUtils,layoutform,interfaces,controls,forms,Graphics,windows;

{$I ..\crlib.h}

//functions
procedure _InitLayoutForm(Stack:PStack); cdecl;
begin
 Application.Initialize;
end;

procedure _RunLayoutForm(Stack:PStack); cdecl;
var
 id:dword;
begin
 Application.Run;
end;

procedure _TerminateLayoutForm(Stack:PStack); cdecl;
begin
 Application.Terminate;
end;

procedure _CreateLayoutForm(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Application.CreateForm(TLayout,Lf);
 Stack^.push(Lf.Handle);
end;

procedure _FreeLayoutForm(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 Lf.Free;
end;

procedure _ShowLayoutForm(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 Lf.Show;
end;

procedure _LayoutFormGetValue(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 case (Stack^.pop) of
  1:Stack^.push(Lf.AllowDropFiles);   //allowdropfiles
  2:Stack^.push(Lf.AlphaBlend);       //alphablend
  3:Stack^.push(Lf.AlphaBlendValue);  //alphablendvalue
  4:Stack^.push(Lf.AutoScroll);       //autoscroll
  5:Stack^.push(Lf.AutoSize);         //autosize
  6:begin //BorderIcons
     if Lf.BorderIcons=[biMinimize] then Stack^.push(1);
     if Lf.BorderIcons=[biMaximize] then Stack^.push(2);
     if Lf.BorderIcons=[biSystemMenu] then Stack^.push(3);
     if Lf.BorderIcons=[biHelp] then Stack^.push(4);
     if Lf.BorderIcons=[biMinimize,biMaximize] then Stack^.push(5);
     if Lf.BorderIcons=[biMinimize,biSystemMenu] then Stack^.push(6);
     if Lf.BorderIcons=[biMinimize,biHelp] then Stack^.push(7);
     if Lf.BorderIcons=[biMaximize,biSystemMenu] then Stack^.push(8);
     if Lf.BorderIcons=[biMaximize,biHelp] then Stack^.push(9);
     if Lf.BorderIcons=[biSystemMenu,biHelp] then Stack^.push(10);
     if Lf.BorderIcons=[biMinimize,biMaximize,biSystemMenu] then Stack^.push(11);
     if Lf.BorderIcons=[biMinimize,biMaximize,biHelp] then Stack^.push(12);
     if Lf.BorderIcons=[biMinimize,biSystemMenu,biHelp] then Stack^.push(13);
     if Lf.BorderIcons=[biMaximize,biSystemMenu,biHelp] then Stack^.push(14);
     if Lf.BorderIcons=[biMinimize,biMaximize,biSystemMenu,biHelp] then Stack^.push(15);
    end;
  7:Stack^.push(Lf.BorderStyle);//borderstyle
  8:Stack^.push('"'+Lf.Caption+'"');  //Caption
  9:Stack^.push(Lf.Color);     //Color
 10:Stack^.push(Lf.Constraints.MaxHeight); //maxheight
 11:Stack^.push(Lf.Constraints.MaxWidth);  //maxwidth
 12:Stack^.push(Lf.Constraints.MinHeight); //minheight
 13:Stack^.push(Lf.Constraints.MaxWidth);  //minwidth
 14:Stack^.push(Lf.Cursor);                //cursor
 15:Stack^.push(Lf.DefaultMonitor);        //defaultmonitor
 16:Stack^.push(Lf.DockSite);              //docksite
 17:Stack^.push(Lf.DragKind);              //dragkind
 18:Stack^.push(Lf.DragMode);              //dragmode
 19:Stack^.push(Lf.Enabled);               //enabled
 20:Stack^.push(Lf.FormStyle);             //formstyle
 21:Stack^.push(Lf.Height);                //height
 22:Stack^.push(Lf.HelpContext);           //helpcontext
 23:Stack^.push('"'+Lf.HelpFile+'"');      //helpfile
 24:Stack^.push('"'+Lf.HelpKeyword+'"');   //helpkeyword
 25:Stack^.push(Lf.HelpType);              //helptype
 26:Stack^.push(Lf.BiDiMode);              //bidimode
 27:Stack^.push('"'+Lf.Hint+'"');          //hint
 28:Stack^.push(Lf.Icon.Handle);           //icon
 29:Stack^.push(Lf.KeyPreview);            //keypreview
 30:Stack^.push(Lf.Left);                  //left
 31:Stack^.push(Lf.PixelsPerInch);         //PixelsPerInch
 32:Stack^.push(Lf.Position);              //Position
 33:Stack^.push(Lf.ShowHint);              //ShowHint
 34:Stack^.push(Lf.ShowInTaskBar);         //ShowInTaskBar
 35:Stack^.push(Lf.Tag);                   //tag
 36:Stack^.push(Lf.top);                   //top
 37:Stack^.push(Lf.UseDockManager);        //usedockmanager
 38:Stack^.push(Lf.Visible);               //visible
 39:Stack^.push(Lf.Width);                 //width
 40:Stack^.push(Lf.WindowState);           //WindowState
 41:Stack^.push(Lf.CanCloseForm);          //Canclose
 end;
end;

procedure _LayoutFormSetValue(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 case (Stack^.pop) of
  1:Lf.AllowDropFiles:=Boolean((Stack^.pop));   //allowdropfiles
  2:Lf.AlphaBlend:=Boolean((Stack^.pop));       //alphablend
  3:Lf.AlphaBlendValue:=(Stack^.pop);  //alphablendvalue
  4:Lf.AutoScroll:=Boolean((Stack^.pop));       //autoscroll
  5:Lf.AutoSize:=Boolean((Stack^.pop));         //autosize
  6:begin //BorderIcons
     if (Stack^.pop)=1 then Lf.BorderIcons:=[biMinimize];
     if (Stack^.pop)=2 then Lf.BorderIcons:=[biMaximize];
     if (Stack^.pop)=3 then Lf.BorderIcons:=[biSystemMenu];
     if (Stack^.pop)=4 then Lf.BorderIcons:=[biHelp];
     if (Stack^.pop)=5 then Lf.BorderIcons:=[biMinimize,biMaximize];
     if (Stack^.pop)=6 then Lf.BorderIcons:=[biMinimize,biSystemMenu];
     if (Stack^.pop)=7 then Lf.BorderIcons:=[biMinimize,biHelp];
     if (Stack^.pop)=8 then Lf.BorderIcons:=[biMaximize,biSystemMenu];
     if (Stack^.pop)=9 then Lf.BorderIcons:=[biMaximize,biHelp];
     if (Stack^.pop)=10 then Lf.BorderIcons:=[biSystemMenu,biHelp];
     if (Stack^.pop)=11 then Lf.BorderIcons:=[biMinimize,biMaximize,biSystemMenu];
     if (Stack^.pop)=12 then Lf.BorderIcons:=[biMinimize,biMaximize,biHelp];
     if (Stack^.pop)=13 then Lf.BorderIcons:=[biMinimize,biSystemMenu,biHelp];
     if (Stack^.pop)=14 then Lf.BorderIcons:=[biMaximize,biSystemMenu,biHelp];
     if (Stack^.pop)=15 then Lf.BorderIcons:=[biMinimize,biMaximize,biSystemMenu,biHelp];
    end;
  7:Lf.BorderStyle:=TBorderStyle((Stack^.pop));           //borderstyle
  8:Lf.Caption:=extractstr(Stack^.pop);   //Caption
  9:Lf.Color:=(Stack^.pop);                 //Color
 10:Lf.Constraints.MaxHeight:=(Stack^.pop); //maxheight
 11:Lf.Constraints.MaxWidth:=(Stack^.pop);  //maxwidth
 12:Lf.Constraints.MinHeight:=(Stack^.pop); //minheight
 13:Lf.Constraints.MaxWidth:=(Stack^.pop);  //minwidth
 14:Lf.Cursor:=(Stack^.pop);                //cursor
 15:Lf.DefaultMonitor:=TDefaultMonitor((Stack^.pop));        //defaultmonitor
 16:Lf.DockSite:=Boolean((Stack^.pop));              //docksite
 17:Lf.DragKind:=TDragKind((Stack^.pop));              //dragkind
 18:Lf.DragMode:=TDragMode((Stack^.pop));              //dragmode
 19:Lf.Enabled:=Boolean((Stack^.pop));              //enabled
 20:Lf.FormStyle:=TFormStyle((Stack^.pop));             //formstyle
 21:Lf.Height:=(Stack^.pop);                //height
 22:Lf.HelpContext:=(Stack^.pop);           //helpcontext
 23:Lf.HelpFile:=extractstr(Stack^.pop);      //helpfile
 24:Lf.HelpKeyword:=extractstr(Stack^.pop);   //helpkeyword
 25:Lf.HelpType:=THelpType((Stack^.pop));                  //helptype
 26:Lf.BiDiMode:=TBiDiMode((Stack^.pop));                  //bidimode
 27:Lf.Hint:=extractstr(Stack^.pop);          //hint
 28:Lf.Icon.Handle:=(Stack^.pop);           //icon
 29:Lf.KeyPreview:=Boolean((Stack^.pop));            //keypreview
 30:Lf.Left:=(Stack^.pop);                  //left
 31:Lf.PixelsPerInch:=(Stack^.pop);         //PixelsPerInch
 32:Lf.Position:=TPosition((Stack^.pop));              //Position
 33:Lf.ShowHint:=Boolean((Stack^.pop));              //ShowHint
 34:Lf.ShowInTaskBar:=TShowInTaskbar((Stack^.pop));         //ShowInTaskBar
 35:Lf.Tag:=(Stack^.pop);                   //tag
 36:Lf.top:=(Stack^.pop);                   //top
 37:Lf.UseDockManager:=Boolean((Stack^.pop));        //usedockmanager
 38:Lf.Visible:=Boolean((Stack^.pop));               //visible
 39:Lf.Width:=(Stack^.pop);                 //width
 40:Lf.WindowState:=TWindowState((Stack^.pop));           //WindowState
 41:Lf.CanCloseForm:=Boolean((Stack^.pop));          //CanClose
 end;
end;

procedure _LayoutFormCanvas(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 case (Stack^.pop) of
{A}
  1:Stack^.push(Lf.Canvas.AutoRedraw);
  2:Lf.Canvas.AutoRedraw:=Boolean((Stack^.pop));
  3:Lf.Canvas.ArcTo((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
  4:Lf.Canvas.Arc((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
  5:Lf.Canvas.Arc((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
  6:Lf.Canvas.AngleArc((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
  7:Lf.Canvas.AntialiasingMode:=TAntialiasingMode((Stack^.pop));
  8:Stack^.push(Lf.Canvas.AntialiasingMode);
  9:Lf.Canvas.AfterConstruction;
{B}
 10:Lf.Canvas.BeforeDestruction;
 11:Lf.Canvas.Brush.Color:=(Stack^.pop);
 12:Stack^.push(Lf.Canvas.Brush.Color);
 13:Lf.Canvas.Brush.Style:=TBrushStyle((Stack^.pop));
 14:Stack^.push(Lf.Canvas.Brush.Style);
 //11:Lf.Canvas.Brush.Pattern:=(Stack^.pop);
{C}
 15:Lf.Canvas.Chord((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 16:Lf.Canvas.Chord((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 17:Lf.Canvas.Clear;
 18:Lf.Canvas.Clipping:=Boolean((Stack^.pop));
 19:Stack^.push(Lf.Canvas.Clipping);
{D}
 20:Lf.Canvas.DrawFocusRect(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
{E}
 21:Lf.Canvas.Ellipse((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 22:Lf.Canvas.Ellipse(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
 23:Lf.Canvas.EllipseC((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 24:Lf.Canvas.Erase;
{F}
 25:Lf.Canvas.Font.Color:=(Stack^.pop);//font start
 26:Stack^.push(Lf.Canvas.Font.Color);
 27:Lf.Canvas.Font.Size:=(Stack^.pop);
 28:Stack^.push(Lf.Canvas.Font.Size);
 29:Lf.Canvas.Font.Name:=extractstr(Stack^.pop);
 30:Stack^.push('"'+Lf.Canvas.Font.Name+'"');
 31:Lf.Canvas.Font.Height:=(Stack^.pop);
 32:Stack^.push(Lf.Canvas.Font.Height);
 33:Lf.Canvas.Font.Orientation:=(Stack^.pop);
 34:Stack^.push(Lf.Canvas.Font.Orientation);
 35:Lf.Canvas.Font.SetDefault;
 36:Lf.Canvas.Font.Bold:=Boolean((Stack^.pop));
 37:Stack^.push(Lf.Canvas.Font.Bold);
 38:Lf.Canvas.Font.Italic:=Boolean((Stack^.pop));
 39:Stack^.push(Lf.Canvas.Font.Italic);
 40:Lf.Canvas.Font.StrikeThrough:=Boolean((Stack^.pop));
 41:Stack^.push(Lf.Canvas.Font.StrikeThrough);
 42:Lf.Canvas.Font.Underline:=Boolean((Stack^.pop));
 43:Stack^.push(Lf.Canvas.Font.Underline);
 44:Stack^.push('"'+Lf.Canvas.Font.GetNamePath+'"');
 45:Stack^.push(Lf.Canvas.Font.GetTextHeight(extractstr(Stack^.pop)));
 46:Stack^.push(Lf.Canvas.Font.GetTextWidth(extractstr(Stack^.pop)));//font end

 47:Lf.Canvas.Frame((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 48:Lf.Canvas.FloodFill((Stack^.pop),(Stack^.pop),(Stack^.pop),TFillStyle((Stack^.pop)));
 49:Lf.Canvas.FillRect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 50:Lf.Canvas.FillRect(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
 {38:Lf.Canvas.Frame3D(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 39:Lf.Canvas.Frame3D(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)),(Stack^.pop),(Stack^.pop)); }
 51:Lf.Canvas.FrameRect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 52:Lf.Canvas.FrameRect(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
{G}
 53:Stack^.push(Lf.Canvas.GetTextHeight(extractstr(Stack^.pop)));
 54:Stack^.push('"'+Lf.Canvas.GetNamePath+'"');
 55:Stack^.push(Lf.Canvas.GetTextWidth(extractstr(Stack^.pop)));
 56:Lf.Canvas.GradientFill(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)),(Stack^.pop),(Stack^.pop),TGradientDirection((Stack^.pop)));
{H}
 57:Stack^.push(Lf.Canvas.Handle);
 58:Stack^.push(Lf.Canvas.HandleAllocated);
 59:Stack^.push(Lf.Canvas.Height);
{I}
{J}
{K}
{L}
 60:Lf.Canvas.Lock;
 61:Lf.Canvas.Line((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 62:Lf.Canvas.Line(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
 63:Lf.Canvas.LineTo((Stack^.pop),(Stack^.pop));
 64:Lf.Canvas.LockCanvas;
 65:Stack^.push(Lf.Canvas.Locked);
{M}
 66:Lf.Canvas.ManageResources:=Boolean((Stack^.pop));
 67:Lf.Canvas.MoveTo((Stack^.pop),(Stack^.pop));
{N}
{O}
{P}
 68:Lf.Canvas.Pen.Color:=(Stack^.pop);
 69:Stack^.push(Lf.Canvas.Pen.Color);
 70:Lf.Canvas.Pen.Cosmetic:=Boolean((Stack^.pop));
 71:Stack^.push(Lf.Canvas.Pen.Cosmetic);
 72:Stack^.push(Lf.Canvas.Pen.GetPattern);
 73:Lf.Canvas.Pen.SetPattern(TPenPattern((Stack^.pop)));
 74:Lf.Canvas.Pen.Style:=TPenStyle((Stack^.pop));
 75:Stack^.push(Lf.Canvas.Pen.Style);
 76:Lf.Canvas.Pen.Mode:=TPenMode((Stack^.pop));
 77:Stack^.push(Lf.Canvas.Pen.Mode);
 78:Lf.Canvas.Pen.Width:=(Stack^.pop);
 79:Stack^.push(Lf.Canvas.Pen.Width);
 80:Lf.Canvas.Pie((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 81:Lf.Canvas.Pixels[(Stack^.pop),(Stack^.pop)]:=(Stack^.pop);
 82:Stack^.push(Lf.Canvas.Pixels[(Stack^.pop),(Stack^.pop)]);
 83:Lf.Canvas.PenPos:=Classes.Point((Stack^.pop),(Stack^.pop));
 85:Stack^.push(Lf.Canvas.PenPos.x);
 86:Stack^.push(Lf.Canvas.PenPos.y);
{Q}
{R}
 87:Lf.Canvas.RadialPie((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 88:Lf.Canvas.Rectangle((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 89:Lf.Canvas.Rectangle(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)));
 90:Lf.Canvas.Refresh;
 91:Lf.Canvas.RoundRect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop));
 92:Lf.Canvas.RoundRect(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)),(Stack^.pop),(Stack^.pop));
{S}
 93:Lf.Canvas.SaveHandleState;
{T}
 94:Stack^.push(Lf.Canvas.TextExtent(extractstr(Stack^.pop)).cx);
 95:Stack^.push(Lf.Canvas.TextExtent(extractstr(Stack^.pop)).cy);
 96:Stack^.push(Lf.Canvas.TextFitInfo(extractstr(Stack^.pop),(Stack^.pop)));
 97:Stack^.push(Lf.Canvas.TextHeight(extractstr(Stack^.pop)));
 98:Lf.Canvas.TextOut((Stack^.pop),(Stack^.pop),extractstr(Stack^.pop));
 99:Lf.Canvas.TextRect(Classes.Rect((Stack^.pop),(Stack^.pop),(Stack^.pop),(Stack^.pop)),(Stack^.pop),(Stack^.pop),extractstr(Stack^.pop));
 100:Stack^.push(Lf.Canvas.TextWidth(extractstr(Stack^.pop)));
 101:Stack^.push(Lf.Canvas.TryLock);
{U}
 102:Lf.Canvas.Unlock;
 103:Lf.Canvas.UnlockCanvas;
{V}
{W}
 104:Lf.Canvas.Width;
{X}
{Y}
{Z}
 end;
end;

procedure _LayoutFormWaitForEvent(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 repeat
  if Lf.EventReceived=true then
   begin
     Stack^.push(Lf.LastEvent);
     Lf.EventReceived:=false;
     Exit;
   end;
  sleep(1);
 until false;
end;

procedure _LayoutFormGetLastEventArg(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 Stack^.push(Lf.LastEventArg[(Stack^.pop)]);
end;

procedure _LayoutQuery(Stack:PStack); cdecl;
var Lf:TLayout;
begin
 Lf:=(FindControl((Stack^.pop)) as TLayout);
 case (Stack^.pop) of
  1:Application.Idle(Boolean((Stack^.pop)));
  2:Application.Log(TEventType((Stack^.pop)),extractstr(Stack^.pop));
  3:Application.MessageBox(PChar(extractstr(Stack^.pop)),PChar(extractstr(Stack^.pop)),(Stack^.pop));
  4:Application.Minimize;
  5:Application.ProcessMessages;
  6:Stack^.push(Application.ParamCount);
  7:Stack^.push('"'+Application.Params[(Stack^.pop)]+'"');
  8:Application.Restore;
  9:Application.Title:=extractstr(Stack^.pop);
 10:Stack^.push('"'+Application.Title+'"');
 11:Lf.Cascade;
 12:Lf.Next;
 13:Lf.Previous;
 14:Lf.Close;
 15:Lf.Hide;
 16:Lf.SetFocus;
 17:Stack^.push(Mouse.CursorPos.x);
 18:Stack^.push(Mouse.CursorPos.y);
 19:Lf.Icon.LoadFromFile(extractstr(Stack^.pop));
 end;
end;

//reg table
exports _InitLayoutForm            name    'LAYOUT.INITIALIZE';
exports _RunLayoutForm             name    'LAYOUT.RUN';
exports _TerminateLayoutForm       name    'LAYOUT.FREE';
exports _CreateLayoutForm          name    'LAYOUT.FORM.CREATE';
exports _FreeLayoutForm            name    'LAYOUT.FORM.FREE';
exports _ShowLayoutForm            name    'LAYOUT.FORM.SHOW';
exports _LayoutFormGetValue        name    'LAYOUT.FORM.GETVALUE';
exports _LayoutFormSetValue        name    'LAYOUT.FORM.SETVALUE';
exports _LayoutFormCanvas          name    'LAYOUT.FORM.CANVAS';
exports _LayoutFormWaitForEvent    name    'LAYOUT.FORM.WAITFOREVENT';
exports _LayoutFormGetLastEventArg name    'LAYOUT.FORM.GETLASTEVENTARG';
exports _LayoutQuery               name    'LAYOUT.QUERY';

begin
end.

