library CRGL;

{$mode objfpc}{$H+}

uses
  Classes,SysUtils,layoutform,interfaces, Graphics, Dialogs, controls,
  OpenGLContext, GL, GLU;

{$I DTypes.inc}

type TLFCRException=class(Exception);

function VarToInt(v:variant):integer;
begin
  try
   Result:=StrToInt(v);
  except
   on E:Exception do
    raise TLFCRException.Create('LFCR, The type casting error.');
  end;
end;


//functions
procedure _CreateGLPanel(Eng:PDASMEngine); stdcall;
var Lf:TLayout;
    GC:TOpenGLControl;
begin
 Lf:=(FindControl(VarToInt(Eng^.popst)) as TLayout);
 Gc:=TOpenGLControl.Create(Lf);
 Eng^.pushst(Gc.Handle);
end;

procedure _RemoveGLPanel(Eng:PDASMEngine); stdcall;
var GC:TOpenGLControl;
begin
 Gc:=(FindControl(VarToInt(Eng^.popst)) as TOpenGLControl);
 FreeAndNil(gc);
end;

procedure _GLPanelGetValue(Eng:PDASMEngine); stdcall;
var Lf:TOpenGLControl;
begin
 Lf:=(FindControl(VarToInt(Eng^.popst)) as TOpenGLControl);
 case VarToInt(Eng^.popst) of
  1:Eng^.PushST(Lf.AutoSize);         //autosize
  2:Eng^.PushST('"'+Lf.Caption+'"');  //Caption
  3:Eng^.PushST(Lf.Color);     //Color
  4:Eng^.PushST(Lf.Constraints.MaxHeight); //maxheight
  5:Eng^.PushST(Lf.Constraints.MaxWidth);  //maxwidth
  6:Eng^.PushST(Lf.Constraints.MinHeight); //minheight
  7:Eng^.PushST(Lf.Constraints.MaxWidth);  //minwidth
  8:Eng^.PushST(Lf.Cursor);                //cursor
  9:Eng^.PushST(Lf.DockSite);              //docksite
 10:Eng^.PushST(Lf.Enabled);               //enabled
 11:Eng^.PushST(Lf.Height);                //height
 12:Eng^.PushST(Lf.HelpContext);           //helpcontext
 13:Eng^.PushST('"'+Lf.HelpKeyword+'"');   //helpkeyword
 14:Eng^.PushST(Lf.HelpType);              //helptype
 15:Eng^.PushST(Lf.BiDiMode);              //bidimode
 16:Eng^.PushST('"'+Lf.Hint+'"');          //hint
 17:Eng^.PushST(Lf.Left);                  //left
 18:Eng^.PushST(Lf.ShowHint);              //ShowHint
 19:Eng^.PushST(Lf.Tag);                   //tag
 20:Eng^.PushST(Lf.top);                   //top
 21:Eng^.PushST(Lf.UseDockManager);        //usedockmanager
 22:Eng^.PushST(Lf.Visible);               //visible
 23:Eng^.PushST(Lf.Width);                 //width
 24:Eng^.PushST(Lf.AlphaBits);
 25:Eng^.PushST(lF.AutoResizeViewport);
 26:Eng^.PushST(lF.AUXBuffers);
 27:Eng^.PushST(Lf.BlueBits);
 //28:Eng^.PushST(Lf.BorderSpacing);
 29:Eng^.PushST(Lf.DepthBits);
 30:Eng^.PushST(Lf.GreenBits);
 31:Eng^.PushST(Lf.MultiSampling);
 32:Eng^.PushST(Lf.OpenGLMajorVersion);
 33:Eng^.PushST(Lf.OpenGLMinorVersion);
 34:Eng^.PushST(Lf.RedBits);
 35:Eng^.PushST(Lf.StencilBits);
 36:Eng^.PushST(Lf.Align);
 end;
end;

procedure _GLPanelSetValue(Eng:PDASMEngine); stdcall;
var Lf:TOpenGLControl;
begin
 Lf:=(FindControl(VarToInt(Eng^.popst)) as TOpenGLControl);
 case VarToInt(Eng^.popst) of
  1:Lf.AutoSize:=Boolean(VarToInt(Eng^.popst));         //autosize
  2:Lf.Caption:=extractstr(Eng^.popst);   //Caption
  3:Lf.Color:=VarToInt(Eng^.popst);                 //Color
  4:Lf.Constraints.MaxHeight:=VarToInt(Eng^.popst); //maxheight
  5:Lf.Constraints.MaxWidth:=VarToInt(Eng^.popst);  //maxwidth
  6:Lf.Constraints.MinHeight:=VarToInt(Eng^.popst); //minheight
  7:Lf.Constraints.MaxWidth:=VarToInt(Eng^.popst);  //minwidth
  8:Lf.Cursor:=VarToInt(Eng^.popst);                //cursor
  9:Lf.DockSite:=Boolean(VarToInt(Eng^.popst));              //docksite
 10:Lf.Enabled:=Boolean(VarToInt(Eng^.popst));              //enabled
 11:Lf.Height:=VarToInt(Eng^.popst);                //height
 12:Lf.HelpContext:=VarToInt(Eng^.popst);           //helpcontext
 13:Lf.HelpKeyword:=extractstr(Eng^.popst);   //helpkeyword
 14:Lf.HelpType:=THelpType(VarToInt(Eng^.popst));                  //helptype
 15:Lf.BiDiMode:=TBiDiMode(VarToInt(Eng^.popst));                  //bidimode
 16:Lf.Hint:=extractstr(Eng^.popst);          //hint
 17:Lf.Left:=VarToInt(Eng^.popst);                  //left
 18:Lf.ShowHint:=Boolean(VarToInt(Eng^.popst));              //ShowHint
 19:Lf.Tag:=VarToInt(Eng^.popst);                   //tag
 20:Lf.top:=VarToInt(Eng^.popst);                   //top
 21:Lf.UseDockManager:=Boolean(VarToInt(Eng^.popst));        //usedockmanager
 22:Lf.Visible:=Boolean(VarToInt(Eng^.popst));               //visible
 23:Lf.Width:=VarToInt(Eng^.popst);                 //width
 24:Lf.AlphaBits:=VarToInt(Eng^.popst);
 25:lF.AutoResizeViewport:=Boolean(VarToInt(Eng^.popst));
 26:lF.AUXBuffers:=VarToInt(Eng^.popst);
 27:Lf.BlueBits:=VarToInt(Eng^.popst);
 //28:Lf.BorderSpacing:=VarToInt(Eng^.popst);
 29:Lf.DepthBits:=VarToInt(Eng^.popst);
 30:Lf.GreenBits:=VarToInt(Eng^.popst);
 31:Lf.MultiSampling:=VarToInt(Eng^.popst);
 32:Lf.OpenGLMajorVersion:=VarToInt(Eng^.popst);
 33:Lf.OpenGLMinorVersion:=VarToInt(Eng^.popst);
 34:Lf.RedBits:=VarToInt(Eng^.popst);
 35:Lf.StencilBits:=VarToInt(Eng^.popst);
 36:Lf.Align:=Eng^.popst;
 end;
end;

procedure _GLPanelQuery(Eng:PDASMEngine); stdcall;
var Lf:TOpenGLControl;
begin
 Lf:=(FindControl(VarToInt(Eng^.popst)) as TOpenGLControl);
 case VarToInt(Eng^.popst) of
  1:Eng^.pushst(Lf.ReleaseContext);
  2:Lf.SwapBuffers;
  3:Lf.Update;
  4:Eng^.pushst(Lf.FrameDiffTimeInMSecs);
 end;
end;


{
 Value  :  Eng^.popst
 Pointer: @Eng^.stack[Length(Eng^.stack)-1]
}

procedure _GLQuery(Eng:PDASMEngine); stdcall;
begin
 case VarToInt(Eng^.popst) of
 //A
  1:glAccum(Eng^.popst,Eng^.popst);
  2:glAlphaFunc(Eng^.popst,Eng^.popst);
  3:Eng^.pushst(glAreTexturesResident(Eng^.popst,@Eng^.stack[Length(Eng^.stack)-1],@Eng^.stack[Length(Eng^.stack)-1]));
  4:glArrayElement(Eng^.popst);
 //B
  5:glBegin(Eng^.popst);
  6:glBindTexture(Eng^.popst,Eng^.popst);
  7:glBitmap(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[Length(Eng^.stack)-1]);
  8:glBlendFunc(Eng^.popst,Eng^.popst);
 //C
  9:glCallList(Eng^.popst);
 10:glCallLists(Eng^.popst,Eng^.popst,@Eng^.stack[Length(Eng^.stack)-1]);
 11:glClear(Eng^.popst);
 12:glClearAccum(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 13:glClearColor(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 14:glClearDepth(Eng^.popst);
 15:glClearIndex(Eng^.popst);
 16:glClearStencil(Eng^.popst);
 17:glClipPlane(Eng^.popst,@Eng^.stack[Length(Eng^.stack)-1]);
 18:glColor3b(Eng^.popst,Eng^.popst,Eng^.popst);
 19:glColor3dv(@Eng^.stack[Length(Eng^.stack)-1]);
 20:glColor3bv(@Eng^.stack[length(eng^.stack)-1]);
 21:glColor3d(Eng^.popst,Eng^.popst,Eng^.popst);
 22:glColor3f(Eng^.popst,Eng^.popst,Eng^.popst);
 23:glColor3fv(@Eng^.stack[length(eng^.stack)-1]);
 24:glColor3i(Eng^.popst,Eng^.popst,Eng^.popst);
 25:glColor3iv(@Eng^.stack[length(eng^.stack)-1]);
 26:glColor3s(Eng^.popst,Eng^.popst,Eng^.popst);
 27:glColor3sv(@Eng^.stack[length(eng^.stack)-1]);
 28:glColor3ub(Eng^.popst,Eng^.popst,Eng^.popst);
 29:glColor3ubv(@Eng^.stack[length(eng^.stack)-1]);
 30:glColor3ui(Eng^.popst,Eng^.popst,Eng^.popst);
 31:glColor3uiv(@Eng^.stack[length(eng^.stack)-1]);
 32:glColor3us(Eng^.popst,Eng^.popst,Eng^.popst);
 33:glColor3usv(@Eng^.stack[length(eng^.stack)-1]);
 34:glColor4b(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 35:glColor4bv(@Eng^.stack[length(eng^.stack)-1]);
 36:glColor4d(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 37:glColor4dv(@Eng^.stack[length(eng^.stack)-1]);
 38:glColor4f(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 39:glColor4fv(@Eng^.stack[length(eng^.stack)-1]);
 40:glColor4i(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 41:glColor4iv(@Eng^.stack[length(eng^.stack)-1]);
 42:glColor4s(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 43:glColor4sv(@Eng^.stack[length(eng^.stack)-1]);
 44:glColor4ub(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 45:glColor4ubv(@Eng^.stack[length(eng^.stack)-1]);
 46:glColor4ui(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 47:glColor4uiv(@Eng^.stack[length(eng^.stack)-1]);
 48:glColor4us(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 49:glColor4usv(@Eng^.stack[length(eng^.stack)-1]);
 50:glColorMask(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 51:glColorMaterial(Eng^.popst,Eng^.popst);
 52:glColorPointer(Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 53:glCopyPixels(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 54:glCopyTexImage1D(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 55:glCopyTexImage2D(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 56:glCopyTexSubImage1D(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 57:glCopyTexSubImage2D(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 58:glCullFace(Eng^.popst);
 //D
 59:glDeleteLists(Eng^.popst,Eng^.popst);
 60:glDeleteTextures(Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 61:glDepthFunc(Eng^.popst);
 62:glDepthMask(Eng^.popst);
 63:glDepthRange(Eng^.popst,Eng^.popst);
 64:glDisable(Eng^.popst);
 65:glDisableClientState(Eng^.popst);
 66:glDrawArrays(Eng^.popst,Eng^.popst,Eng^.popst);
 67:glDrawBuffer(Eng^.popst);
 68:glDrawElements(Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 69:glDrawPixels(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 //E
 70:glEdgeFlag(Eng^.popst);
 71:glEdgeFlagPointer(Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 72:glEdgeFlagv(@Eng^.stack[length(eng^.stack)-1]);
 73:glEnable(Eng^.popst);
 74:glEnableClientState(Eng^.popst);
 75:glEnd;
 76:glEndList;
 77:glEvalCoord1d(Eng^.popst);
 78:glEvalCoord1dv(@Eng^.stack[length(eng^.stack)-1]);
 79:glEvalCoord1f(Eng^.popst);
 80:glEvalCoord1fv(@Eng^.stack[length(eng^.stack)-1]);
 81:glEvalCoord2d(Eng^.popst,Eng^.popst);
 82:glEvalCoord2dv(@Eng^.stack[length(eng^.stack)-1]);
 83:glEvalCoord2f(Eng^.popst,Eng^.popst);
 84:glEvalCoord2fv(@Eng^.stack[length(eng^.stack)-1]);
 85:glEvalMesh1(Eng^.popst,Eng^.popst,Eng^.popst);
 86:glEvalMesh2(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 87:glEvalPoint1(Eng^.popst);
 88:glEvalPoint2(Eng^.popst,Eng^.popst);
 //F
 89:glFeedbackBuffer(Eng^.popst,Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 90:glFinish;
 91:glFlush;
 92:glFogf(Eng^.popst,Eng^.popst);
 93:glFogfv(Eng^.popst,@Eng^.stack[length(eng^.stack)-1]);
 94:glFogi(Eng^.popst,Eng^.popst);
 95:glFogiv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
 96:glFrontFace(Eng^.popst);
 97:glFrustum(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
 //G
 98:Eng^.pushst(glGenLists(Eng^.popst));
 99:glGenTextures(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
100:glGetBooleanv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
101:glGetClipPlane(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
102:glGetDoublev(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
103:Eng^.pushst(glGetError());
104:glGetFloatv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
105:glGetIntegerv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
106:glGetLightfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
107:glGetLightiv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
108:glGetMapfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
109:glGetMapiv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
110:glGetMapdv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
111:glGetMaterialfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
112:glGetMaterialiv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
113:glGetPixelMapfv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
114:glGetPixelMapuiv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
115:glGetPixelMapusv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
116:glGetPointerv(Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
117:glGetPolygonStipple(@Eng^.stack[length(Eng^.stack)-1]);
118:Eng^.pushst(glGetString(Eng^.popst));
119:glGetTexEnvfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
120:glGetTexGendv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
121:glGetTexEnviv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
122:glGetTexGenfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
123:glGetTexGeniv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
124:glGetTexImage(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
125:glGetTexLevelParameterfv(Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
126:glGetTexLevelParameteriv(Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
127:glGetTexParameterfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
128:glGetTexLevelParameteriv(Eng^.popst,Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
129:glGetTexParameterfv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
130:glGetTexParameteriv(Eng^.popst,Eng^.popst,@Eng^.stack[length(Eng^.stack)-1]);
//H
131:glHint(Eng^.popst,Eng^.popst);
//I
132:glIndexd(Eng^.popst);
133:glIndexdv(@Eng^.stack[length(Eng^.stack)-1]);
134:glIndexf(Eng^.popst);
135:glIndexfv(@Eng^.stack[length(Eng^.stack)-1]);
136:;


137:glMatrixMode(Eng^.popst);
138:glLoadIdentity;
139:gluPerspective(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
140:glTranslatef(Eng^.popst,Eng^.popst,Eng^.popst);
141:glRotatef(Eng^.popst,Eng^.popst,Eng^.popst,Eng^.popst);
142:glVertex3f(Eng^.popst,Eng^.popst,Eng^.popst);
 end;
end;

//reg table
exports _CreateGLPanel           name    'GL.CREATEGLPANEL';
exports _RemoveGLPanel           name    'GL.REMOVEGLPANEL';
exports _GLPanelGetValue         name    'GL.GLPANEL.GETVALUE';
exports _GLPanelSetValue         name    'GL.GLPANEL.SETVALUE';
exports _GLPanelQuery            name    'GL.GLPANEL.QUERY';
exports _GLQuery                 name    'GL.QUERY';

begin
end.

