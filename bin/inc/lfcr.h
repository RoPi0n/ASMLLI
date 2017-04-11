; ASMLLI
; Autor: Shiriaev Pavel

import "lfcr.dll" "LAYOUT.INITIALIZE"           layout.initialize
import "lfcr.dll" "LAYOUT.RUN"                  layout.run
import "lfcr.dll" "LAYOUT.FREE"                 layout.free
import "lfcr.dll" "LAYOUT.FORM.CREATE"          layout.form.create
import "lfcr.dll" "LAYOUT.FORM.SHOW"            layout.form.show
import "lfcr.dll" "LAYOUT.FORM.FREE"            layout.form.free
import "lfcr.dll" "LAYOUT.FORM.GETVALUE"        layout.form.getvalue
import "lfcr.dll" "LAYOUT.FORM.SETVALUE"        layout.form.setvalue
import "lfcr.dll" "LAYOUT.FORM.CANVAS"          layout.form.canvas
import "lfcr.dll" "LAYOUT.FORM.WAITFOREVENT"    layout.form.waitforevent
import "lfcr.dll" "LAYOUT.FORM.GETLASTEVENTARG" layout.form.getlasteventarg
import "lfcr.dll" "LAYOUT.QUERY"                layout.query

;Form 
define form word

;Form values
data byte vnAllowDropFiles  1
data byte vnAlphaBlend      2
data byte vnAlphaBlendValue 3
data byte vnAutoScroll      4
data byte vnAutoSize        5
data byte vnBorderIcons     6
data byte vnBorderStyle     7
data byte vnCaption         8
data byte vnColor           9
data byte vnMaxHeight       10
data byte vnMaxWidth        11
data byte vnMinHeight       12
data byte vnMinWidth        13
data byte vnCursor          14
data byte vnDefaultMonitor  15
data byte vnDockSite        16
data byte vnDragKind        17
data byte vnDragMode        18
data byte vnEnabled         19
data byte vnFormStyle       20
data byte vnHeight          21
data byte vnHelpContext     22
data byte vnHelpFile        23
data byte vnHelpKeyWord     24
data byte vnHelpType        25
data byte vnBidiMode        26
data byte vnHint            27
data byte vnIcon            28
data byte vnKeyPreview      29
data byte vnLeft            30
data byte vnPixelsPerInch   31
data byte vnPosition        32
data byte vnShowHint        33
data byte vnShowInTaskBar   34
data byte vnTag             35
data byte vnTop             36
data byte vnUseDockManager  37
data byte vnVisible         38
data byte vnWidth           39
data byte vnWindowState     40
data byte vnCanClose        41

;Border icon
data byte biMinimize                     1
data byte biMaximize                     2
data byte biSystemMenu                   3
data byte biHelp                         4
data byte biMinimize_Maximize            5
data byte biMinimize_SystemMenu          6
data byte biMinimize_Help                7
data byte biMaximize_SystemMenu          8
data byte biMaximize_Help                9
data byte biSystemMenu_Help              10 
data byte biMinimize_Maximize_SystemMenu 11
data byte biMinimize_Maximize_Help       12
data byte biMinimize_SystemMenu_Help     13
data byte biMaximize_SystemMenu_Help     14
data byte biAll                          15

;Border style
data byte bsNone         0
data byte bsSingle       1
data byte bsSizeable     2
data byte bsDialog       3
data byte bsToolWindow   4
data byte bsSizeToolWin  5

;Form style
data byte fsNormal          0
data byte fsMDIChild        1
data byte fsMDIForm         2
data byte fsStayOnTop       3
data byte fsSplash          4
data byte fsSystemStayOnTop 5

;Drag kind
data byte dkDrag 0
data byte dkDock 1

;Drag mode
data byte dmManual    0
data byte dmAutomatic 1

data byte bdLeftToRight            0
data byte bdRightToLeft            1
data byte bdRightToLeftNoAlign     2
data byte bdRightToLeftReadingOnly 3

;Default monitor
data byte dmDesktop     0   ; use full desktop
data byte dmPrimary     1   ; use primary monitor
data byte dmMainForm    2   ; use monitor of main form
data byte dmActiveForm  3   ; use monitor of active form

;Help type
data byte htKeyword 0
data byte htContext 1

;Position
data byte poDesigned        0 ; use bounds from the designer (read from stream)
data byte poDefault         1 ; LCL decision (normally window manager decides)
data byte poDefaultPosOnly  2 ; designed size and LCL position
data byte poDefaultSizeOnly 3 ; designed position and LCL size
data byte poScreenCenter    4 ; center form on screen (depends on DefaultMonitor)
data byte poDesktopCenter   5 ; center form on desktop (total of all screens)
data byte poMainFormCenter  6 ; center form on main form (depends on DefaultMonitor)
data byte poOwnerFormCenter 7 ; center form on owner form (depends on DefaultMonitor)

;Show in taskbar
data byte stDefault  0 ; use default rules for showing taskbar item
data byte stAlways   1 ; always show taskbar item for the form
data byte stNever    2 ; never show taskbar item for the form

;Window state
data byte wsNormal     0
data byte wsMinimized  1
data byte wsMaximized  2
data byte wsFullScreen 3

;Canvas 
data byte fcGetAutoRedraw 1
data byte fcSetAutoRegraw 2
data byte fcArcTo 3
data byte fcArc 4
data byte fcArc2 5
data byte fcAngleArc 6
data byte fcSetAntialiasingMode 7
data byte fcGetAntialiasingMode 8
data byte fcAfterConstruction 9
data byte fcBeforeDestruction 10
data byte fcSetBrushColor 11
data byte fcGetBrushColor 12
data byte fcSetBrushStyle 13
data byte fcGetBrushStyle 14
data byte fcChord 15
data byte fcChord2 16
data byte fcClear 17
data byte fcSetClipping 18
data byte fcGetClipping 19
data byte fcDrawFocusRect 20
data byte fcEllipse 21
data byte fcEllipse2 22
data byte fcEllipseC 23
data byte fcErace 24
data byte fcSetFontColor 25
data byte fcGetFontColor 26
data byte fcSetFontSize 27
data byte fcGetFontSize 28
data byte fcSetFontName 29
data byte fcGetFontName 30
data byte fcSetFontHeight 31
data byte fcGetFontHeight 32
data byte fcSetFontOrientation 33
data byte fcGetFontOrientation 34
data byte fcSetFontDefault 35
data byte fcSetFontBold 36
data byte fcGetFontBold 37
data byte fcSetFontItalic 38
data byte fcGetFontItalic 39
data byte fcSetFontStrikeThrough 40
data byte fcGetFontStrikeThrough 41
data byte fcSetFontUnderLine 42
data byte fcGetFontUnderLine 43
data byte fcGetFontNamePath 44
data byte fcGetFontTextHeight 45
data byte fcGetFontTextWidth 46
data byte fcFrame 47
data byte fcFloodFill 48
data byte fcFillRect 49
data byte fcFillRect2 50
data byte fcFrameRect 51
data byte fcFrameRect2 52
data byte fcGetTextHeight 53
data byte fcGetNamePath 54
data byte fcGetTextWidth 55
data byte fcGradientFill 56
data byte fcGetHandle 57
data byte fcGetHandleAllocated 58
data byte fcGetHeight 59
data byte fcLock 60
data byte fcLine 61
data byte fcLine2 62
data byte fcLineTo 63
data byte fcLockCanvas 64
data byte fcGetLocked 65
data byte fcSetManageResources 66
data byte fcMoveTo 67
data byte fcSetPenColor 68
data byte fcGetPenColor 69
data byte fcSetPenCosmetic 70
data byte fcGetPenCosmetic 71
data byte fcGetPenPattern 72
data byte fcSetPenPattern 73
data byte fcSetPenStyle 74
data byte fcGetPenStyle 75
data byte fcSetPenMode 76
data byte fcGetPenMode 78
data byte fcSetPenWidth 79
data byte fcGetPenWidth 80
data byte fcPie 81
data byte fcSetPixel 82
data byte fcGetPixel 83
data byte fcSetPenPos 84
data byte fcGetPenPosX 85
data byte fcGetPenPosY 86
data byte fcRadicalPie 87
data byte fcRectangle 88
data byte fcRectangle2 89
data byte fcRefresh 90
data byte fcRoundRect 91
data byte fcRoundRect2 92
data byte fcSaveHandleState 93
data byte fcGetTextExtentCX 94
data byte fcGetTextExtentCY 95
data byte fcGetTextFitInfo 96
data byte fcTextHeight 97
data byte fcTextOut 98
data byte fcTextRect 99
data byte fcTextWidth 100
data byte fcTryLock 101
data byte fcUnlock 102
data byte fcUnlockCanvas 103
data byte fcWidth 104

;Form query
data byte fqIdle                 1
data byte fqLog                  2
data byte fqMessageBox           3
data byte fqMinimize             4
data byte fqProcessMessages      5
data byte fqParamCount           6
data byte fqGetParamStr          7
data byte fqRestore              8
data byte fqSetTitle             9
data byte fqGetTitle             10
data byte fqCascade              11
data byte fqNext                 12
data byte fqPrevious             13
data byte fqClose                14
data byte fqHide                 15
data byte fqSetFocus             16
data byte fqGetMouseX            17
data byte fqGetMouseY            18
data byte fqFormIconLoadFromFile 19

;Form event
data byte feActivate             1
data byte feChangeBounds         2
data byte feClick                3
data byte feClose                4
data byte feCloseQuery           5
data byte feContextPopup         6
data byte feDblClick             7
data byte feDeactivate           8
data byte feDestroy              9
data byte feDockDrop             10
data byte feDockOver             11
data byte feDragDrop             12
data byte feDragOver             13
data byte feDropFiles            14
data byte feEndDock              15
data byte feGetSiteInfo          16
data byte feHelp                 17
data byte feHide                 18
data byte feKeyDown              19
data byte feKeyPress             20
data byte feKeyUp                21
data byte feMouseDown            22
data byte feMouseEnter           23
data byte feMouseLeave           24
data byte feMouseMove            25
data byte feMouseUp              26
data byte feMouseWheel           27
data byte feMouseWheelDown       28
data byte feMouseWheelUp         29
data byte feResize               30
data byte feShortCut             31
data byte feShow                 32
data byte feShowHint             33
data byte feStartDock            34
data byte feUnDock               35
data byte feUTF8KeyPress         36
data byte feWindowStateChange    37
data byte fePaint                38