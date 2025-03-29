//================================================================================
// UWindowRootWindow.
//================================================================================
class UWindowRootWindow expands UWindowWindow;

var UWindowWindow MouseWindow;
var bool bMouseCapture;
var float MouseX;
var float MouseY;
var float OldMouseX;
var float OldMouseY;
var WindowConsole Console;
var UWindowWindow FocusedWindow;
var UWindowWindow KeyFocusWindow;
var MouseCursor NormalCursor;
var MouseCursor MoveCursor;
var MouseCursor DiagCursor1;
var MouseCursor HandCursor;
var MouseCursor HSplitCursor;
var MouseCursor VSplitCursor;
var MouseCursor DiagCursor2;
var MouseCursor NSCursor;
var MouseCursor WECursor;
var bool bQuickKeyEnable;
var UWindowHotkeyWindowList HotkeyWindows;
var config float GUIScale;
var float RealWidth;
var float RealHeight;
var Font Fonts[10];
var UWindowLookAndFeel LooksAndFeels[20];
var config string LookAndFeelClass;

function BeginPlay ()
{
	Root=self;
	MouseWindow=self;
	KeyFocusWindow=self;
}

function UWindowLookAndFeel GetLookAndFeel (string LFClassName)
{
	local int i;
	local Class<UWindowLookAndFeel> LFClass;

	LFClass=Class<UWindowLookAndFeel>(DynamicLoadObject(LFClassName,Class'Class'));
	i=0;
JL0022:
	if ( i < 20 )
	{
		if ( LooksAndFeels[i] == None )
		{
			LooksAndFeels[i]=new (,LFClass);
			LooksAndFeels[i].Setup();
			return LooksAndFeels[i];
		}
		if ( LooksAndFeels[i].Class == LFClass )
		{
			return LooksAndFeels[i];
		}
		i++;
		goto JL0022;
	}
	Log("Out of LookAndFeel array space!!");
	return None;
}

function Created ()
{
	LookAndFeel=GetLookAndFeel(LookAndFeelClass);
	SetupFonts();
	NormalCursor.Tex=Texture'MouseCursor';
	NormalCursor.HotX=0;
	NormalCursor.HotY=0;
	NormalCursor.WindowsCursor=Console.Viewport.0;
	MoveCursor.Tex=Texture'MouseMove';
	MoveCursor.HotX=8;
	MoveCursor.HotY=8;
	MoveCursor.WindowsCursor=Console.Viewport.1;
	DiagCursor1.Tex=Texture'MouseDiag1';
	DiagCursor1.HotX=8;
	DiagCursor1.HotY=8;
	DiagCursor1.WindowsCursor=Console.Viewport.4;
	HandCursor.Tex=Texture'MouseHand';
	HandCursor.HotX=11;
	HandCursor.HotY=1;
	HandCursor.WindowsCursor=Console.Viewport.0;
	HSplitCursor.Tex=Texture'MouseHSplit';
	HSplitCursor.HotX=9;
	HSplitCursor.HotY=9;
	HSplitCursor.WindowsCursor=Console.Viewport.5;
	VSplitCursor.Tex=Texture'MouseVSplit';
	VSplitCursor.HotX=9;
	VSplitCursor.HotY=9;
	VSplitCursor.WindowsCursor=Console.Viewport.3;
	DiagCursor2.Tex=Texture'MouseDiag2';
	DiagCursor2.HotX=7;
	DiagCursor2.HotY=7;
	DiagCursor2.WindowsCursor=Console.Viewport.2;
	NSCursor.Tex=Texture'MouseNS';
	NSCursor.HotX=3;
	NSCursor.HotY=7;
	NSCursor.WindowsCursor=Console.Viewport.3;
	WECursor.Tex=Texture'MouseWE';
	WECursor.HotX=7;
	WECursor.HotY=3;
	WECursor.WindowsCursor=Console.Viewport.5;
	HotkeyWindows=new (,Class'UWindowHotkeyWindowList');
	HotkeyWindows.Last=HotkeyWindows;
	HotkeyWindows.Next=None;
	HotkeyWindows.Sentinel=HotkeyWindows;
	Cursor=NormalCursor;
}

function MoveMouse (float X, float Y)
{
	local UWindowWindow NewMouseWindow;
	local float tX;
	local float tY;

	MouseX=X;
	MouseY=Y;
	if (  !bMouseCapture )
	{
		NewMouseWindow=FindWindowUnder(X,Y);
	}
	else
	{
		NewMouseWindow=MouseWindow;
	}
	if ( NewMouseWindow != MouseWindow )
	{
		MouseWindow.MouseLeave();
		NewMouseWindow.MouseEnter();
		MouseWindow=NewMouseWindow;
	}
	if ( (MouseX != OldMouseX) || (MouseY != OldMouseY) )
	{
		OldMouseX=MouseX;
		OldMouseY=MouseY;
		MouseWindow.GetMouseXY(tX,tY);
		MouseWindow.MouseMove(tX,tY);
	}
}

function DrawMouse (Canvas C)
{
	local float X;
	local float Y;

	if ( Console.Viewport.bWindowsMouseAvailable )
	{
		Console.Viewport.SelectedCursor=MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
		C.bNoSmooth=True;
		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX,MouseY * GUIScale - MouseWindow.Cursor.HotY);
		C.DrawIcon(MouseWindow.Cursor.Tex,1.00);
	}
}

function GetMouseXY (out float X, out float Y)
{
	X=MouseX;
	Y=MouseY;
}

function GlobalToWindow (float GlobalX, float GlobalY, out float WinX, out float WinY)
{
	WinX=GlobalX;
	WinY=GlobalY;
}

function WindowToGlobal (float WinX, float WinY, out float GlobalX, out float GlobalY)
{
	GlobalX=WinX;
	GlobalY=WinY;
}

function bool CheckCaptureMouseUp ()
{
	local float X;
	local float Y;

	if ( bMouseCapture )
	{
		MouseWindow.GetMouseXY(X,Y);
		MouseWindow.LMouseUp(X,Y);
		bMouseCapture=False;
		return True;
	}
	return False;
}

function bool CheckCaptureMouseDown ()
{
	local float X;
	local float Y;

	if ( bMouseCapture )
	{
		MouseWindow.GetMouseXY(X,Y);
		MouseWindow.LMouseDown(X,Y);
		bMouseCapture=False;
		return True;
	}
	return False;
}

function CancelCapture ()
{
	bMouseCapture=False;
}

function CaptureMouse (optional UWindowWindow W)
{
	bMouseCapture=True;
	if ( W != None )
	{
		MouseWindow=W;
	}
}

function BringToFront ()
{
}

function ActivateWindow (int depth, bool bTransientNoDeactivate)
{
	if ( depth == 0 )
	{
		FocusWindow();
	}
}

function SetAcceptsFocus ()
{
	bAcceptsFocus=True;
}

function Texture GetLookAndFeelTexture ()
{
	return LookAndFeel.Active;
}

function bool IsActive ()
{
	return True;
}

function AddHotkeyWindow (UWindowWindow W)
{
	UWindowHotkeyWindowList(HotkeyWindows.Insert(Class'UWindowHotkeyWindowList')).Window=W;
}

function RemoveHotkeyWindow (UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L=HotkeyWindows.FindWindow(W);
	if ( L != None )
	{
		L.Remove();
	}
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
		case 7:
		if ( HotKeyDown(Key,X,Y) )
		{
			return;
		}
		break;
		case 6:
		if ( HotKeyUp(Key,X,Y) )
		{
			return;
		}
		break;
		default:
	}
	Super.WindowEvent(Msg,C,X,Y,Key);
}

function bool HotKeyDown (int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(HotkeyWindows.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.Window != self) && L.Window.HotKeyDown(Key,X,Y) )
		{
			return True;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0019;
	}
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(HotkeyWindows.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.Window != self) && L.Window.HotKeyUp(Key,X,Y) )
		{
			return True;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0019;
	}
	return False;
}

function CloseActiveWindow ()
{
	if ( ActiveWindow != None )
	{
		ActiveWindow.Close();
	}
	else
	{
		Console.CloseUWindow();
	}
}

function Resized ()
{
	ResolutionChanged(WinWidth,WinHeight);
}

function SetScale (float NewScale)
{
	WinWidth=RealWidth / NewScale;
	WinHeight=RealHeight / NewScale;
	GUIScale=NewScale;
	ClippingRegion.X=0;
	ClippingRegion.Y=0;
	ClippingRegion.W=WinWidth;
	ClippingRegion.H=WinHeight;
	SetupFonts();
	Resized();
}

function SetupFonts ()
{
	local string Sizes[5];
	local int UseSize;

	Sizes[0]="Tahoma12";
	Sizes[1]="Tahoma13";
	Sizes[2]="Tahoma14";
	Sizes[3]="Tahoma15";
	Sizes[4]="Tahoma16";
	UseSize=FClamp((GUIScale - 1) * 8,0.00,4.00);
	Log("Using font: " $ Sizes[UseSize]);
	Fonts[0]=Font(DynamicLoadObject("UWindowFonts." $ Sizes[UseSize],Class'Font'));
}

function ChangeLookAndFeel (string NewLookAndFeel)
{
	LookAndFeelClass=NewLookAndFeel;
	SaveConfig();
	Console.ResetUWindow();
}

function bool WindowIsVisible ()
{
	return True;
}

defaultproperties
{
    GUIScale=1.00
}