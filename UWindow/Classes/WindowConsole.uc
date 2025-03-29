//================================================================================
// WindowConsole.
//================================================================================
class WindowConsole expands Console
	transient;

var UWindowRootWindow Root;
var() config string RootWindow;
var float OldClipX;
var float OldClipY;
var bool bCreatedRoot;
var float MouseX;
var float MouseY;
var Class<UWindowConsoleWindow> ConsoleClass;
var config float MouseScale;
var config bool ShowDesktop;
var config bool bShowConsole;
var bool bBlackout;
var bool bUWindowType;
var bool bUWindowActive;
var bool bQuickKeyEnable;
var bool bLocked;
var config EInputKey UWindowKey;
var config EInputKey UWindowQuickKey;
var UWindowConsoleWindow ConsoleWindow;

function ResetUWindow ()
{
	if ( Root != None )
	{
		Root.Close();
	}
	Root=None;
	bCreatedRoot=False;
	ConsoleWindow=None;
	CloseUWindow();
}

event bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	switch (Action)
	{
		case 1:
		switch (Key)
		{
			case 27:
			if ( bLocked )
			{
				return True;
			}
			bQuickKeyEnable=False;
			LaunchUWindow();
			return True;
			case UWindowQuickKey:
			if ( bLocked )
			{
				return True;
			}
			bQuickKeyEnable=True;
			LaunchUWindow();
			return True;
			case 192:
			if ( bLocked )
			{
				return True;
			}
			bQuickKeyEnable=True;
			LaunchUWindow();
			if (  !bShowConsole )
			{
				ShowConsole();
			}
			return True;
			default:
		}
		case 3:
		switch (Key)
		{
			case UWindowQuickKey:
			if ( bLocked )
			{
				return True;
			}
			CloseUWindow();
			return True;
			default:
		}
		break;
		default:
	}
	return Super.KeyEvent(Key,Action,Delta);
}

function ShowConsole ()
{
	bShowConsole=True;
	if ( bCreatedRoot )
	{
		ConsoleWindow.ShowWindow();
	}
}

function HideConsole ()
{
	ConsoleLines=0;
	bShowConsole=False;
	if ( ConsoleWindow != None )
	{
		ConsoleWindow.HideWindow();
	}
}

state UWindow
{
	event Tick (float Delta)
	{
		Super.Tick(Delta);
		if ( Root != None )
		{
			Root.DoTick(Delta);
		}
	}
	
	event PostRender (Canvas Canvas)
	{
		if ( ConsoleWindow != None )
		{
			UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.SetPrompt("(> " $ TypedStr);
		}
		if ( Root != None )
		{
			Root.bUWindowActive=True;
		}
		RenderUWindow(Canvas);
	}
	
	event bool KeyType (EInputKey Key)
	{
		if ( Root != None )
		{
			Root.WindowEvent(8,None,MouseX,MouseY,Key);
		}
		return True;
	}
	
	event bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local int k;
	
		k=Key;
		switch (Action)
		{
			case 3:
			switch (Key)
			{
				case 1:
				if ( Root != None )
				{
					Root.WindowEvent(1,None,MouseX,MouseY,k);
				}
				break;
				case 2:
				if ( Root != None )
				{
					Root.WindowEvent(5,None,MouseX,MouseY,k);
				}
				break;
				case 4:
				if ( Root != None )
				{
					Root.WindowEvent(3,None,MouseX,MouseY,k);
				}
				break;
				case UWindowQuickKey:
				if ( bLocked )
				{
					return True;
				}
				CloseUWindow();
				break;
				default:
				if ( Root != None )
				{
					Root.WindowEvent(6,None,MouseX,MouseY,k);
				}
				break;
			}
			break;
			case 1:
			switch (Key)
			{
				case 120:
				return Global.KeyEvent(Key,Action,Delta);
				break;
				case 192:
				if ( bShowConsole )
				{
					HideConsole();
					if ( bQuickKeyEnable )
					{
						CloseUWindow();
					}
				}
				else
				{
					ShowConsole();
				}
				break;
				case 27:
				if ( Root != None )
				{
					Root.CloseActiveWindow();
				}
				break;
				case 1:
				if ( Root != None )
				{
					Root.WindowEvent(0,None,MouseX,MouseY,k);
				}
				break;
				case 2:
				if ( Root != None )
				{
					Root.WindowEvent(4,None,MouseX,MouseY,k);
				}
				break;
				case 4:
				if ( Root != None )
				{
					Root.WindowEvent(2,None,MouseX,MouseY,k);
				}
				break;
				default:
				if ( Root != None )
				{
					Root.WindowEvent(7,None,MouseX,MouseY,k);
				}
				break;
			}
			break;
			case 4:
			switch (Key)
			{
				case 228:
				MouseX=MouseX + MouseScale * Delta;
				break;
				case 229:
				MouseY=MouseY - MouseScale * Delta;
				break;
				default:
			}
			default:
			break;
		}
		return True;
	}
	
	function BeginState ()
	{
		Log("Console entering UWindow state");
	}
	
	function EndState ()
	{
		Log("Console leaving UWindow state");
	}
	
Begin:
}

function ToggleUWindow ()
{
}

function LaunchUWindow ()
{
	bUWindowActive= !bQuickKeyEnable;
	Viewport.bShowWindowsMouse=True;
	if ( bQuickKeyEnable )
	{
		bNoDrawWorld=False;
	}
	else
	{
		Viewport.Actor.SetPause(True);
		bNoDrawWorld=ShowDesktop;
	}
	GotoState('UWindow');
}

function CloseUWindow ()
{
	if (  !bQuickKeyEnable )
	{
		Viewport.Actor.SetPause(False);
	}
	bNoDrawWorld=False;
	bQuickKeyEnable=False;
	bUWindowActive=False;
	Viewport.bShowWindowsMouse=False;
	GotoState('None');
}

function CreateRootWindow (Canvas Canvas)
{
	local int i;

	OldClipX=Canvas.ClipX;
	OldClipY=Canvas.ClipY;
	Log("Creating root window: " $ RootWindow);
	Root=new (None,Class<UWindowRootWindow>(DynamicLoadObject(RootWindow,Class'Class')));
	Root.BeginPlay();
	Root.WinTop=0.00;
	Root.WinLeft=0.00;
	Root.WinWidth=Canvas.ClipX / Root.GUIScale;
	Root.WinHeight=Canvas.ClipY / Root.GUIScale;
	Root.RealWidth=Canvas.ClipX;
	Root.RealHeight=Canvas.ClipY;
	Root.ClippingRegion.X=0;
	Root.ClippingRegion.Y=0;
	Root.ClippingRegion.W=Root.WinWidth;
	Root.ClippingRegion.H=Root.WinHeight;
	Root.Console=self;
	Root.bUWindowActive=bUWindowActive;
	Root.Created();
	bCreatedRoot=True;
	ConsoleWindow=UWindowConsoleWindow(Root.CreateWindow(ConsoleClass,100.00,100.00,200.00,200.00));
	if (  !bShowConsole )
	{
		HideConsole();
	}
	UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(" ");
	i=0;
JL0254:
	if ( i < 4 )
	{
		UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(MsgText[i]);
		i++;
		goto JL0254;
	}
}

function RenderUWindow (Canvas Canvas)
{
	local UWindowWindow NewFocusWindow;

	Canvas.bNoSmooth=True;
	Canvas.Z=1.00;
	Canvas.Style=1;
	Canvas.DrawColor.R=255;
	Canvas.DrawColor.G=255;
	Canvas.DrawColor.B=255;
	if ( Viewport.bWindowsMouseAvailable && (Root != None) )
	{
		MouseX=Viewport.WindowsMouseX / Root.GUIScale;
		MouseY=Viewport.WindowsMouseY / Root.GUIScale;
	}
	if (  !bCreatedRoot )
	{
		CreateRootWindow(Canvas);
	}
	Root.bUWindowActive=bUWindowActive;
	Root.bQuickKeyEnable=bQuickKeyEnable;
	if ( (Canvas.ClipX != OldClipX) || (Canvas.ClipY != OldClipY) )
	{
		OldClipX=Canvas.ClipX;
		OldClipY=Canvas.ClipY;
		Root.WinTop=0.00;
		Root.WinLeft=0.00;
		Root.WinWidth=Canvas.ClipX / Root.GUIScale;
		Root.WinHeight=Canvas.ClipY / Root.GUIScale;
		Root.RealWidth=Canvas.ClipX;
		Root.RealHeight=Canvas.ClipY;
		Root.ClippingRegion.X=0;
		Root.ClippingRegion.Y=0;
		Root.ClippingRegion.W=Root.WinWidth;
		Root.ClippingRegion.H=Root.WinHeight;
		Root.Resized();
	}
	if ( MouseX > Root.WinWidth )
	{
		MouseX=Root.WinWidth;
	}
	if ( MouseY > Root.WinHeight )
	{
		MouseY=Root.WinHeight;
	}
	if ( MouseX < 0 )
	{
		MouseX=0.00;
	}
	if ( MouseY < 0 )
	{
		MouseY=0.00;
	}
	NewFocusWindow=Root.CheckKeyFocusWindow();
	if ( NewFocusWindow != Root.KeyFocusWindow )
	{
		Root.KeyFocusWindow.KeyFocusExit();
		Root.KeyFocusWindow=NewFocusWindow;
		Root.KeyFocusWindow.KeyFocusEnter();
	}
	Root.MoveMouse(MouseX,MouseY);
	Root.WindowEvent(9,Canvas,MouseX,MouseY,0);
	if ( bUWindowActive || bQuickKeyEnable )
	{
		Root.DrawMouse(Canvas);
	}
}

event Message (PlayerReplicationInfo PRI, coerce string Msg, name N)
{
	local string OutText;

	Super.Message(PRI,Msg,N);
	if ( Viewport.Actor == None )
	{
		return;
	}
	if ( Msg != "" )
	{
		if ( (MsgType[TopLine] == 'Say') || (MsgType[TopLine] == 'TeamSay') )
		{
			OutText=MsgPlayer[TopLine].PlayerName $ ": " $ MsgText[TopLine];
		}
		else
		{
			OutText=MsgText[TopLine];
		}
		if ( ConsoleWindow != None )
		{
			UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(OutText);
		}
	}
}

function UpdateHistory ()
{
	History[HistoryCur++  % 16]=TypedStr;
	if ( HistoryCur > HistoryBot )
	{
		HistoryBot++;
	}
	if ( HistoryCur - HistoryTop >= 16 )
	{
		HistoryTop=HistoryCur - 16 + 1;
	}
}

function HistoryUp ()
{
	if ( HistoryCur > HistoryTop )
	{
		History[HistoryCur % 16]=TypedStr;
		TypedStr=History[ --HistoryCur % 16];
	}
}

function HistoryDown ()
{
	History[HistoryCur % 16]=TypedStr;
	if ( HistoryCur < HistoryBot )
	{
		TypedStr=History[ ++HistoryCur % 16];
	}
	else
	{
		TypedStr="";
	}
}

defaultproperties
{
    RootWindow="UWindow.UWindowRootWindow"
    ConsoleClass=Class'UWindowConsoleWindow'
    MouseScale=0.60
    UWindowQuickKey=IK_ScrollLock
}