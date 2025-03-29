//================================================================================
// UWindowWindow.
//================================================================================
class UWindowWindow expands UWindowBase;

const F_Normal= 0;
const DE_MouseEnter= 12;
const DE_DoubleClick= 11;
const DE_LMouseDown= 10;
const DE_MouseLeave= 9;
const DE_MouseMove= 8;
const DE_EnterPressed= 7;
const DE_RClick= 6;
const DE_MClick= 5;
const DE_Exit= 4;
const DE_Enter= 3;
const DE_Click= 2;
const DE_Change= 1;
const DE_Created= 0;
enum WinMessage {
	WM_LMouseDown,
	WM_LMouseUp,
	WM_MMouseDown,
	WM_MMouseUp,
	WM_RMouseDown,
	WM_RMouseUp,
	WM_KeyUp,
	WM_KeyDown,
	WM_KeyType,
	WM_Paint
};

struct MouseCursor
{
	var Texture Tex;
	var int HotX;
	var int HotY;
	var byte WindowsCursor;
};

var float WinLeft;
var float WinTop;
var float WinWidth;
var float WinHeight;
var UWindowWindow ParentWindow;
var UWindowWindow FirstChildWindow;
var UWindowWindow LastChildWindow;
var UWindowWindow NextSiblingWindow;
var UWindowWindow PrevSiblingWindow;
var UWindowWindow ActiveWindow;
var UWindowRootWindow Root;
var UWindowWindow OwnerWindow;
var UWindowWindow ModalWindow;
var bool bWindowVisible;
var bool bNoClip;
var bool bMouseDown;
var bool bRMouseDown;
var bool bMMouseDown;
var bool bAlwaysBehind;
var bool bAcceptsFocus;
var bool bAlwaysOnTop;
var bool bLeaveOnscreen;
var bool bUWindowActive;
var bool bTransient;
var bool bAcceptsHotKeys;
var bool bIgnoreLDoubleClick;
var bool bIgnoreMDoubleClick;
var bool bIgnoreRDoubleClick;
var float ClickTime;
var float MClickTime;
var float RClickTime;
var float ClickX;
var float ClickY;
var float MClickX;
var float MClickY;
var float RClickX;
var float RClickY;
var UWindowLookAndFeel LookAndFeel;
var Region ClippingRegion;
var MouseCursor Cursor;

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
		case 9:
		Paint(C,X,Y);
		PaintClients(C,X,Y);
		break;
		case 0:
		if (  !Root.CheckCaptureMouseDown() )
		{
			if (  !MessageClients(Msg,C,X,Y,Key) )
			{
				LMouseDown(X,Y);
			}
		}
		break;
		case 1:
		if (  !Root.CheckCaptureMouseUp() )
		{
			if (  !MessageClients(Msg,C,X,Y,Key) )
			{
				LMouseUp(X,Y);
			}
		}
		break;
		case 4:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			RMouseDown(X,Y);
		}
		break;
		case 5:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			RMouseUp(X,Y);
		}
		break;
		case 2:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MMouseDown(X,Y);
		}
		break;
		case 3:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MMouseUp(X,Y);
		}
		break;
		case 7:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyDown(Key,X,Y);
		}
		break;
		case 6:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyUp(Key,X,Y);
		}
		break;
		case 8:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyType(Key,X,Y);
		}
		break;
		default:
		break;
	}
}

function SaveConfigs ()
{
}

function PlayerPawn GetPlayerOwner ()
{
	return Root.Console.Viewport.Actor;
}

function LevelInfo GetLevel ()
{
	return Root.Console.Viewport.Actor.Level;
}

function Resized ()
{
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function AfterPaint (Canvas C, float X, float Y)
{
}

function Paint (Canvas C, float X, float Y)
{
}

function Click (float X, float Y)
{
}

function MClick (float X, float Y)
{
}

function RClick (float X, float Y)
{
}

function DoubleClick (float X, float Y)
{
}

function MDoubleClick (float X, float Y)
{
}

function RDoubleClick (float X, float Y)
{
}

function BeginPlay ()
{
}

function Created ()
{
}

function AfterCreate ()
{
}

function MouseEnter ()
{
}

function Activated ()
{
}

function DeActivated ()
{
}

function MouseLeave ()
{
	bMouseDown=False;
	bMMouseDown=False;
	bRMouseDown=False;
}

function MouseMove (float X, float Y)
{
}

function KeyUp (int Key, float X, float Y)
{
}

function KeyDown (int Key, float X, float Y)
{
}

function bool HotKeyDown (int Key, float X, float Y)
{
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	return False;
}

function KeyType (int Key, float X, float Y)
{
}

function ProcessMenuKey (int Key, string KeyName)
{
}

function KeyFocusEnter ()
{
}

function KeyFocusExit ()
{
}

function RMouseDown (float X, float Y)
{
	bRMouseDown=True;
}

function RMouseUp (float X, float Y)
{
	if ( bRMouseDown )
	{
		if (  !bIgnoreRDoubleClick && (X == RClickX) && (Y == RClickY) && (GetLevel().TimeSeconds < RClickTime + 600) )
		{
			RDoubleClick(X,Y);
			RClickTime=0.00;
		}
		else
		{
			RClickTime=GetLevel().TimeSeconds;
			RClickX=X;
			RClickY=Y;
			RClick(X,Y);
		}
	}
	bRMouseDown=False;
}

function MMouseDown (float X, float Y)
{
	bMMouseDown=True;
}

function MMouseUp (float X, float Y)
{
	if ( bMMouseDown )
	{
		if (  !bIgnoreMDoubleClick && (X == MClickX) && (Y == MClickY) && (GetLevel().TimeSeconds < MClickTime + 600) )
		{
			MDoubleClick(X,Y);
			MClickTime=0.00;
		}
		else
		{
			MClickTime=GetLevel().TimeSeconds;
			MClickX=X;
			MClickY=Y;
			MClick(X,Y);
		}
	}
	bMMouseDown=False;
}

function LMouseDown (float X, float Y)
{
	ActivateWindow(0,False);
	bMouseDown=True;
}

function LMouseUp (float X, float Y)
{
	if ( bMouseDown )
	{
		if (  !bIgnoreLDoubleClick && (X == ClickX) && (Y == ClickY) && (GetLevel().TimeSeconds < ClickTime + 600) )
		{
			DoubleClick(X,Y);
			ClickTime=0.00;
		}
		else
		{
			ClickTime=GetLevel().TimeSeconds;
			ClickX=X;
			ClickY=Y;
			Click(X,Y);
		}
	}
	bMouseDown=False;
}

function FocusWindow ()
{
	if ( (Root.FocusedWindow != None) && (Root.FocusedWindow != self) )
	{
		Root.FocusedWindow.FocusOtherWindow(self);
	}
	Root.FocusedWindow=self;
}

function FocusOtherWindow (UWindowWindow W)
{
}

function Close (optional bool bByParent)
{
	local UWindowWindow Prev;
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Prev=Child.PrevSiblingWindow;
		Child.Close(True);
		Child=Prev;
		goto JL000B;
	}
	SaveConfigs();
	if (  !bByParent )
	{
		HideWindow();
	}
}

function SetSize (float W, float H)
{
	if ( (WinWidth != W) || (WinHeight != H) )
	{
		WinWidth=W;
		WinHeight=H;
		Resized();
	}
}

function Tick (float Delta)
{
}

function DoTick (float Delta)
{
	local UWindowWindow Child;

	Tick(Delta);
	Child=FirstChildWindow;
JL0016:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			Child.DoTick(Delta);
		}
		Child=Child.NextSiblingWindow;
		goto JL0016;
	}
}

function PaintClients (Canvas C, float X, float Y)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;
	local UWindowWindow Child;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	Child=FirstChildWindow;
JL005B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		C.SetPos(0.00,0.00);
		C.Style=GetPlayerOwner().1;
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
		C.SpaceX=0.00;
		C.SpaceY=0.00;
		Child.BeforePaint(C,X - Child.WinLeft,Y - Child.WinTop);
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			C.OrgX=C.OrgX + Child.WinLeft * Root.GUIScale;
			C.OrgY=C.OrgY + Child.WinTop * Root.GUIScale;
			if (  !Child.bNoClip )
			{
				C.ClipX=FMin(WinWidth - Child.WinLeft,Child.WinWidth) * Root.GUIScale;
				C.ClipY=FMin(WinHeight - Child.WinTop,Child.WinHeight) * Root.GUIScale;
				Child.ClippingRegion.X=ClippingRegion.X - Child.WinLeft;
				Child.ClippingRegion.Y=ClippingRegion.Y - Child.WinTop;
				Child.ClippingRegion.W=ClippingRegion.W;
				Child.ClippingRegion.H=ClippingRegion.H;
				if ( Child.ClippingRegion.X < 0 )
				{
					Child.ClippingRegion.W += Child.ClippingRegion.X;
					Child.ClippingRegion.X=0;
				}
				if ( Child.ClippingRegion.Y < 0 )
				{
					Child.ClippingRegion.H += Child.ClippingRegion.Y;
					Child.ClippingRegion.Y=0;
				}
				if ( Child.ClippingRegion.W > Child.WinWidth - Child.ClippingRegion.X )
				{
					Child.ClippingRegion.W=Child.WinWidth - Child.ClippingRegion.X;
				}
				if ( Child.ClippingRegion.H > Child.WinHeight - Child.ClippingRegion.Y )
				{
					Child.ClippingRegion.H=Child.WinHeight - Child.ClippingRegion.Y;
				}
			}
			if ( (Child.ClippingRegion.W > 0) && (Child.ClippingRegion.H > 0) )
			{
				Child.WindowEvent(9,C,X - Child.WinLeft,Y - Child.WinTop,0);
				Child.AfterPaint(C,X - Child.WinLeft,Y - Child.WinTop);
			}
			C.OrgX=OrgX;
			C.OrgY=OrgY;
		}
		Child=Child.NextSiblingWindow;
		goto JL005B;
	}
	C.ClipX=ClipX;
	C.ClipY=ClipY;
}

function UWindowWindow FindWindowUnder (float X, float Y)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( (X >= Child.WinLeft) && (X <= Child.WinLeft + Child.WinWidth) && (Y >= Child.WinTop) && (Y <= Child.WinTop + Child.WinHeight) &&  !Child.CheckMousePassThrough(X - Child.WinLeft,Y - Child.WinTop) )
			{
				return Child.FindWindowUnder(X - Child.WinLeft,Y - Child.WinTop);
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return self;
}

function bool PropagateKey (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
	if ( (ActiveWindow != None) && (Child != ActiveWindow) &&  !Child.bTransient )
	{
		Child=ActiveWindow;
	}
JL0048:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( (bUWindowActive || Child.bLeaveOnscreen) && Child.bAcceptsFocus )
		{
			Child.WindowEvent(Msg,C,X - Child.WinLeft,Y - Child.WinTop,Key);
			return True;
		}
		Child=Child.PrevSiblingWindow;
		goto JL0048;
	}
	return False;
}

function UWindowWindow CheckKeyFocusWindow ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
	if ( (ActiveWindow != None) && (Child != ActiveWindow) &&  !Child.bTransient )
	{
		Child=ActiveWindow;
	}
JL0048:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( Child.bAcceptsFocus )
			{
				return Child.CheckKeyFocusWindow();
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL0048;
	}
	return self;
}

function bool MessageClients (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( (X >= Child.WinLeft) && (X <= Child.WinLeft + Child.WinWidth) && (Y >= Child.WinTop) && (Y <= Child.WinTop + Child.WinHeight) &&  !Child.CheckMousePassThrough(X - Child.WinLeft,Y - Child.WinTop) )
			{
				Child.WindowEvent(Msg,C,X - Child.WinLeft,Y - Child.WinTop,Key);
				return True;
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return False;
}

function ActivateWindow (int depth, bool bTransientNoDeactivate)
{
	if ( WaitModal() )
	{
		return;
	}
	if (  !bAlwaysBehind )
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
	if (  !bTransient || bTransientNoDeactivate )
	{
		if ( (ParentWindow.ActiveWindow != None) && (ParentWindow.ActiveWindow != self) )
		{
			ParentWindow.ActiveWindow.DeActivated();
		}
		ParentWindow.ActiveWindow=self;
		ParentWindow.ActivateWindow(depth + 1,False);
		Activated();
	}
	else
	{
		ParentWindow.ActivateWindow(depth + 1,True);
	}
	if ( depth == 0 )
	{
		FocusWindow();
	}
}

function BringToFront ()
{
	if (  !bAlwaysBehind &&  !WaitModal() )
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
	ParentWindow.BringToFront();
}

function SendToBack ()
{
	ParentWindow.HideChildWindow(self);
	ParentWindow.ShowChildWindow(self,True);
}

function HideChildWindow (UWindowWindow Child)
{
	local UWindowWindow Window;

	if (  !Child.bWindowVisible )
	{
		return;
	}
	Child.bWindowVisible=False;
	if ( Child.bAcceptsHotKeys )
	{
		Root.RemoveHotkeyWindow(Child);
	}
	if ( LastChildWindow == Child )
	{
		LastChildWindow=Child.PrevSiblingWindow;
		if ( LastChildWindow != None )
		{
			LastChildWindow.NextSiblingWindow=None;
		}
		else
		{
			FirstChildWindow=None;
		}
	}
	else
	{
		if ( FirstChildWindow == Child )
		{
			FirstChildWindow=Child.NextSiblingWindow;
			if ( FirstChildWindow != None )
			{
				FirstChildWindow.PrevSiblingWindow=None;
			}
			else
			{
				LastChildWindow=None;
			}
		}
		else
		{
			Window=FirstChildWindow;
JL00EE:
			if ( Window != None )
			{
				if ( Window.NextSiblingWindow == Child )
				{
					Window.NextSiblingWindow=Child.NextSiblingWindow;
					Window.NextSiblingWindow.PrevSiblingWindow=Window;
				}
				else
				{
					Window=Window.NextSiblingWindow;
					goto JL00EE;
				}
			}
		}
	}
	ActiveWindow=None;
	Window=LastChildWindow;
JL0177:
	if ( Window != None )
	{
		if (  !Window.bAlwaysOnTop )
		{
			ActiveWindow=Window;
		}
		else
		{
			Window=Window.PrevSiblingWindow;
			goto JL0177;
		}
	}
	if ( ActiveWindow == None )
	{
		ActiveWindow=LastChildWindow;
	}
}

function SetAcceptsFocus ()
{
	if ( bAcceptsFocus )
	{
		return;
	}
	bAcceptsFocus=True;
	ParentWindow.SetAcceptsFocus();
}

function GetMouseXY (out float X, out float Y)
{
	ParentWindow.GetMouseXY(X,Y);
	X=X - WinLeft;
	Y=Y - WinTop;
}

function GlobalToWindow (float GlobalX, float GlobalY, out float WinX, out float WinY)
{
	ParentWindow.GlobalToWindow(GlobalX,GlobalY,WinX,WinY);
	WinX=WinX - WinLeft;
	WinY=WinY - WinTop;
}

function WindowToGlobal (float WinX, float WinY, out float GlobalX, out float GlobalY)
{
	ParentWindow.WindowToGlobal(WinX + WinLeft,WinY + WinTop,GlobalX,GlobalY);
}

function ShowChildWindow (UWindowWindow Child, optional bool bAtBack)
{
	local UWindowWindow W;

	if (  !Child.bTransient )
	{
		ActiveWindow=Child;
	}
	if ( Child.bWindowVisible )
	{
		return;
	}
	Child.bWindowVisible=True;
	if ( Child.bAcceptsHotKeys )
	{
		Root.AddHotkeyWindow(Child);
	}
	if ( bAtBack )
	{
		if ( FirstChildWindow == None )
		{
			Child.NextSiblingWindow=None;
			Child.PrevSiblingWindow=None;
			LastChildWindow=Child;
			FirstChildWindow=Child;
		}
		else
		{
			FirstChildWindow.PrevSiblingWindow=Child;
			Child.NextSiblingWindow=FirstChildWindow;
			Child.PrevSiblingWindow=None;
			FirstChildWindow=Child;
		}
	}
	else
	{
		W=LastChildWindow;
JL0108:
		if ( True )
		{
			if ( Child.bAlwaysOnTop || (W == None) ||  !W.bAlwaysOnTop )
			{
				if ( W == None )
				{
					if ( LastChildWindow == None )
					{
						Child.NextSiblingWindow=None;
						Child.PrevSiblingWindow=None;
						LastChildWindow=Child;
						FirstChildWindow=Child;
					}
					else
					{
						Child.NextSiblingWindow=FirstChildWindow;
						Child.PrevSiblingWindow=None;
						FirstChildWindow.PrevSiblingWindow=Child;
						FirstChildWindow=Child;
					}
				}
				else
				{
					Child.NextSiblingWindow=W.NextSiblingWindow;
					Child.PrevSiblingWindow=W;
					if ( W.NextSiblingWindow != None )
					{
						W.NextSiblingWindow.PrevSiblingWindow=Child;
					}
					else
					{
						LastChildWindow=Child;
					}
					W.NextSiblingWindow=Child;
				}
			}
			else
			{
				W=W.PrevSiblingWindow;
				goto JL0108;
			}
		}
	}
}

function ShowWindow ()
{
	ParentWindow.ShowChildWindow(self);
	WindowShown();
}

function HideWindow ()
{
	WindowHidden();
	ParentWindow.HideChildWindow(self);
}

function UWindowWindow CreateWindow (Class<UWindowWindow> WndClass, float X, float Y, float W, float H, optional UWindowWindow OwnerW, optional bool bUnique)
{
	local UWindowWindow Child;

	if ( bUnique )
	{
		Child=Root.FindChildWindow(WndClass,True);
		if ( Child != None )
		{
			Child.ShowWindow();
			return Child;
		}
	}
	Child=new (,WndClass);
	Child.BeginPlay();
	Child.WinTop=Y;
	Child.WinLeft=X;
	Child.WinWidth=W;
	Child.WinHeight=H;
	Child.Root=Root;
	Child.ParentWindow=self;
	Child.OwnerWindow=OwnerW;
	if ( Child.OwnerWindow == None )
	{
		Child.OwnerWindow=self;
	}
	Child.Cursor=Cursor;
	Child.bAlwaysBehind=False;
	Child.LookAndFeel=LookAndFeel;
	Child.Created();
	ShowChildWindow(Child);
	Child.AfterCreate();
	return Child;
}

function Tile (Canvas C, Texture t)
{
	local int X;
	local int Y;

	X=0;
	Y=0;
JL000E:
	if ( X < WinWidth )
	{
JL001E:
		if ( Y < WinHeight )
		{
			DrawClippedTexture(C,X,Y,t);
			Y += t.VSize;
			goto JL001E;
		}
		X += t.USize;
		Y=0;
		goto JL000E;
	}
}

function DrawHorizTiledPieces (Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5];
	local TexRegion R;
	local int PieceCount;
	local int j;
	local float X;
	local float L;

	Pieces[0]=T1;
	if ( T1.t != None )
	{
		PieceCount=1;
	}
	Pieces[1]=T2;
	if ( T2.t != None )
	{
		PieceCount=2;
	}
	Pieces[2]=T3;
	if ( T3.t != None )
	{
		PieceCount=3;
	}
	Pieces[3]=T4;
	if ( T4.t != None )
	{
		PieceCount=4;
	}
	Pieces[4]=T5;
	if ( T5.t != None )
	{
		PieceCount=5;
	}
	j=0;
	X=DestX;
JL00CD:
	if ( X < DestX + DestW )
	{
		L=DestW - X - DestX;
		R=Pieces[j];
		DrawStretchedTextureSegment(C,X,DestY,FMin(R.W * Scale,L),R.H * Scale,R.X,R.Y,FMin(R.W,L / Scale),R.H,R.t);
		X += FMin(R.W * Scale,L);
		j=(j + 1) % PieceCount;
		goto JL00CD;
	}
}

function DrawVertTiledPieces (Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5];
	local TexRegion R;
	local int PieceCount;
	local int j;
	local float Y;
	local float L;

	Pieces[0]=T1;
	if ( T1.t != None )
	{
		PieceCount=1;
	}
	Pieces[1]=T2;
	if ( T2.t != None )
	{
		PieceCount=2;
	}
	Pieces[2]=T3;
	if ( T3.t != None )
	{
		PieceCount=3;
	}
	Pieces[3]=T4;
	if ( T4.t != None )
	{
		PieceCount=4;
	}
	Pieces[4]=T5;
	if ( T5.t != None )
	{
		PieceCount=5;
	}
	j=0;
	Y=DestY;
JL00CD:
	if ( Y < DestY + DestH )
	{
		L=DestH - Y - DestY;
		R=Pieces[j];
		DrawStretchedTextureSegment(C,DestX,Y,R.W * Scale,FMin(R.H * Scale,L),R.X,R.Y,R.W,FMin(R.H,L / Scale),R.t);
		Y += FMin(R.H * Scale,L);
		j=(j + 1) % PieceCount;
		goto JL00CD;
	}
}

function DrawClippedTexture (Canvas C, float X, float Y, Texture Tex)
{
	DrawStretchedTextureSegment(C,X,Y,Tex.USize,Tex.VSize,0.00,0.00,Tex.USize,Tex.VSize,Tex);
}

function DrawStretchedTexture (Canvas C, float X, float Y, float W, float H, Texture Tex)
{
	DrawStretchedTextureSegment(C,X,Y,W,H,0.00,0.00,Tex.USize,Tex.VSize,Tex);
}

function DrawStretchedTextureSegment (Canvas C, float X, float Y, float W, float H, float tX, float tY, float tW, float tH, Texture Tex)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	C.SetOrigin(OrgX + ClippingRegion.X * Root.GUIScale,OrgY + ClippingRegion.Y * Root.GUIScale);
	C.SetClip(ClippingRegion.W * Root.GUIScale,ClippingRegion.H * Root.GUIScale);
	C.SetPos((X - ClippingRegion.X) * Root.GUIScale,(Y - ClippingRegion.Y) * Root.GUIScale);
	C.DrawTileClipped(Tex,W * Root.GUIScale,H * Root.GUIScale,tX,tY,tW,tH);
	C.SetClip(ClipX,ClipY);
	C.SetOrigin(OrgX,OrgY);
}

function ClipText (Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	C.SetOrigin(OrgX + ClippingRegion.X * Root.GUIScale,OrgY + ClippingRegion.Y * Root.GUIScale);
	C.SetClip(ClippingRegion.W * Root.GUIScale,ClippingRegion.H * Root.GUIScale);
	C.SetPos((X - ClippingRegion.X) * Root.GUIScale,(Y - ClippingRegion.Y) * Root.GUIScale);
	C.DrawTextClipped(S,bCheckHotKey);
	C.SetClip(ClipX,ClipY);
	C.SetOrigin(OrgX,OrgY);
}

function int WrapClipText (Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey, optional int Length, optional int PaddingLength)
{
	local float W;
	local float H;
	local int SpacePos;
	local int CRPos;
	local int WordPos;
	local int TotalPos;
	local string Out;
	local string Temp;
	local string Padding;
	local bool bCR;
	local bool bSentry;
	local int i;
	local int NumLines;
	local float pW;
	local float pH;

	bSentry=True;
	Out="";
	NumLines=1;
JL0017:
	if ( bSentry && (Y < WinHeight) )
	{
		if ( Out == "" )
		{
			i++;
			if ( Length > 0 )
			{
				Out=Left(S,Length);
			}
			else
			{
				Out=S;
			}
		}
		SpacePos=InStr(Out," ");
		CRPos=InStr(Out,Chr(13));
		bCR=False;
		if ( (CRPos != -1) && ((CRPos < SpacePos) || (SpacePos == -1)) )
		{
			WordPos=CRPos;
			bCR=True;
		}
		else
		{
			WordPos=SpacePos;
		}
		C.SetPos(0.00,0.00);
		if ( WordPos == -1 )
		{
			Temp=Out;
		}
		else
		{
			Temp=Left(Out,WordPos) $ " ";
		}
		TotalPos += WordPos;
		TextSize(C,Temp,W,H);
		if ( (Mid(Out,Len(Temp)) == "") && (PaddingLength > 0) )
		{
			Padding=Mid(S,Length,PaddingLength);
			TextSize(C,Padding,pW,pH);
			if ( (W + X + pW > WinWidth) && (X > 0) )
			{
				X=0.00;
				Y += H;
				NumLines++;
			}
		}
		else
		{
			if ( (W + X > WinWidth) && (X > 0) )
			{
				X=0.00;
				Y += H;
				NumLines++;
			}
		}
		ClipText(C,X,Y,Temp,bCheckHotKey);
		X += W;
		if ( bCR )
		{
			X=0.00;
			Y += H;
		}
		Out=Mid(Out,Len(Temp));
		if ( (Out == "") && (i > 0) )
		{
			bSentry=False;
		}
		goto JL0017;
	}
	return NumLines;
}

function ClipTextWidth (Canvas C, float X, float Y, coerce string S, float W)
{
	ClipText(C,X,Y,S);
}

function DrawClippedActor (Canvas C, float X, float Y, Actor A, bool WireFrame, Rotator RotOffset, Vector LocOffset)
{
	local Vector MeshLoc;
	local float FOV;

	FOV=GetPlayerOwner().FovAngle * 3.14 / 180;
	MeshLoc.X=4.00 / Tan(FOV / 2);
	MeshLoc.Y=0.00;
	MeshLoc.Z=0.00;
	A.SetRotation(RotOffset);
	A.SetLocation(MeshLoc + LocOffset);
	C.Super.DrawClippedActor(A,WireFrame,ClippingRegion.W * Root.GUIScale,ClippingRegion.H * Root.GUIScale,C.OrgX + ClippingRegion.X * Root.GUIScale,C.OrgY + ClippingRegion.Y * Root.GUIScale,True);
}

function DrawUpBevel (Canvas C, float X, float Y, float W, float H, Texture t)
{
	local Region R;

	R=LookAndFeel.BevelUpTL;
	DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpT;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpTL.W,Y,W - LookAndFeel.BevelUpTL.W - LookAndFeel.BevelUpTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpTR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpL;
	DrawStretchedTextureSegment(C,X,Y + LookAndFeel.BevelUpTL.H,R.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y + LookAndFeel.BevelUpTL.H,R.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpBL;
	DrawStretchedTextureSegment(C,X,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpB;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpBL.W,Y + H - R.H,W - LookAndFeel.BevelUpBL.W - LookAndFeel.BevelUpBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpBR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpArea;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpTL.W,Y + LookAndFeel.BevelUpTL.H,W - LookAndFeel.BevelUpBL.W - LookAndFeel.BevelUpBR.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
}

function DrawMiscBevel (Canvas C, float X, float Y, float W, float H, Texture t, int BevelType)
{
	local Region R;

	R=LookAndFeel.MiscBevelTL[BevelType];
	DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelT[BevelType];
	DrawStretchedTextureSegment(C,X + LookAndFeel.MiscBevelTL[BevelType].W,Y,W - LookAndFeel.MiscBevelTL[BevelType].W - LookAndFeel.MiscBevelTR[BevelType].W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelTR[BevelType];
	DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelL[BevelType];
	DrawStretchedTextureSegment(C,X,Y + LookAndFeel.MiscBevelTL[BevelType].H,R.W,H - LookAndFeel.MiscBevelTL[BevelType].H - LookAndFeel.MiscBevelBL[BevelType].H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelR[BevelType];
	DrawStretchedTextureSegment(C,X + W - R.W,Y + LookAndFeel.MiscBevelTL[BevelType].H,R.W,H - LookAndFeel.MiscBevelTL[BevelType].H - LookAndFeel.MiscBevelBL[BevelType].H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelBL[BevelType];
	DrawStretchedTextureSegment(C,X,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelB[BevelType];
	DrawStretchedTextureSegment(C,X + LookAndFeel.MiscBevelBL[BevelType].W,Y + H - R.H,W - LookAndFeel.MiscBevelBL[BevelType].W - LookAndFeel.MiscBevelBR[BevelType].W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelBR[BevelType];
	DrawStretchedTextureSegment(C,X + W - R.W,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.MiscBevelArea[BevelType];
	DrawStretchedTextureSegment(C,X + LookAndFeel.MiscBevelTL[BevelType].W,Y + LookAndFeel.MiscBevelTL[BevelType].H,W - LookAndFeel.MiscBevelBL[BevelType].W - LookAndFeel.MiscBevelBR[BevelType].W,H - LookAndFeel.MiscBevelTL[BevelType].H - LookAndFeel.MiscBevelBL[BevelType].H,R.X,R.Y,R.W,R.H,t);
}

function string RemoveAmpersand (string S)
{
	local string Result;
	local string Underline;

	ParseAmpersand(S,Result,Underline,False);
	return Result;
}

function byte ParseAmpersand (string S, out string Result, out string Underline, bool bCalcUnderline)
{
	local string Temp;
	local int pos;
	local int NewPos;
	local int i;
	local byte HotKey;

	HotKey=0;
	pos=0;
	Result="";
	Underline="";
JL001F:
	if ( True )
	{
		Temp=Mid(S,pos);
		NewPos=InStr(Temp,"&");
		if ( NewPos == -1 )
		{
			goto JL0152;
		}
		pos += NewPos;
		if ( Mid(Temp,NewPos + 1,1) == "&" )
		{
			Result=Result $ Left(Temp,NewPos) $ "&";
			if ( bCalcUnderline )
			{
				Underline=Underline $ " ";
			}
			pos++;
		}
		else
		{
			if ( HotKey == 0 )
			{
				HotKey=Asc(Caps(Mid(Temp,NewPos + 1,1)));
			}
			Result=Result $ Left(Temp,NewPos);
			if ( bCalcUnderline )
			{
				i=0;
JL010C:
				if ( i < NewPos - 1 )
				{
					Underline=Underline $ " ";
					i++;
					goto JL010C;
				}
				Underline=Underline $ "_";
			}
		}
		pos++;
		goto JL001F;
	}
JL0152:
	Result=Result $ Temp;
	return HotKey;
}

function bool MouseIsOver ()
{
	return Root.MouseWindow == self;
}

function ToolTip (string strTip)
{
	if ( ParentWindow != Root )
	{
		ParentWindow.ToolTip(strTip);
	}
}

function SetMouseWindow ()
{
	Root.MouseWindow=self;
}

function Texture GetLookAndFeelTexture ()
{
	return ParentWindow.GetLookAndFeelTexture();
}

function bool IsActive ()
{
	return ParentWindow.IsActive();
}

function SetAcceptsHotKeys (bool bNewAccpetsHotKeys)
{
	if ( bNewAccpetsHotKeys &&  !bAcceptsHotKeys && bWindowVisible )
	{
		Root.AddHotkeyWindow(self);
	}
	if (  !bNewAccpetsHotKeys && bAcceptsHotKeys && bWindowVisible )
	{
		Root.RemoveHotkeyWindow(self);
	}
	bAcceptsHotKeys=bNewAccpetsHotKeys;
}

function UWindowWindow GetParent (Class<UWindowWindow> ParentClass, optional bool bExactClass)
{
	if ( ParentWindow == Root )
	{
		return None;
	}
	if ( bExactClass )
	{
		if ( ParentWindow.Class == ParentClass )
		{
			return ParentWindow;
		}
	}
	else
	{
		if ( ClassIsChildOf(ParentWindow.Class,ParentClass) )
		{
			return ParentWindow;
		}
	}
	return ParentWindow.GetParent(ParentClass);
}

function UWindowWindow FindChildWindow (Class<UWindowWindow> ChildClass, optional bool bExactClass)
{
	local UWindowWindow Child;
	local UWindowWindow Found;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		if ( bExactClass )
		{
			if ( Child.Class == ChildClass )
			{
				return Child;
			}
		}
		else
		{
			if ( ClassIsChildOf(Child.Class,ChildClass) )
			{
				return Child;
			}
		}
		Found=Child.FindChildWindow(ChildClass);
		if ( Found != None )
		{
			return Found;
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return None;
}

function Object BuildObjectWithProperties (string Text)
{
	local int i;
	local string ObjectClass;
	local string PropertyName;
	local string PropertyValue;
	local Class C;
	local Object o;

	i=InStr(Text,",");
	if ( i == -1 )
	{
		ObjectClass=Text;
		Text="";
	}
	else
	{
		ObjectClass=Left(Text,i);
		Text=Mid(Text,i + 1);
	}
	C=Class<Object>(DynamicLoadObject(ObjectClass,Class'Class'));
	o=new (,C);
JL0086:
	if ( Text != "" )
	{
		i=InStr(Text,"=");
		if ( i == -1 )
		{
			Log("Missing value for property " $ ObjectClass $ "." $ Text);
			PropertyName=Text;
			PropertyValue="";
		}
		else
		{
			PropertyName=Left(Text,i);
			Text=Mid(Text,i + 1,255);
		}
		i=InStr(Text,",");
		if ( i == -1 )
		{
			PropertyValue=Text;
			Text="";
		}
		else
		{
			PropertyValue=Left(Text,i);
			Text=Mid(Text,i + 1,255);
		}
		o.SetPropertyText(PropertyName,PropertyValue);
		goto JL0086;
	}
	return o;
}

function GetDesiredDimensions (out float W, out float H)
{
	local float MaxW;
	local float MaxH;
	local float tW;
	local float tH;
	local UWindowWindow Child;
	local UWindowWindow Found;

	MaxW=0.00;
	MaxH=0.00;
	Child=LastChildWindow;
JL0021:
	if ( Child != None )
	{
		Child.GetDesiredDimensions(tW,tH);
		if ( tW > MaxW )
		{
			MaxW=tW;
		}
		if ( tH > MaxH )
		{
			MaxH=tH;
		}
		Child=Child.PrevSiblingWindow;
		goto JL0021;
	}
	W=MaxW;
	H=MaxH;
}

function TextSize (Canvas C, string Text, out float W, out float H)
{
	C.SetPos(0.00,0.00);
	C.Super.TextSize(Text,W,H);
	W=W / Root.GUIScale;
	H=H / Root.GUIScale;
}

function ResolutionChanged (float W, float H)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.ResolutionChanged(W,H);
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function ShowModal (UWindowWindow W)
{
	ModalWindow=W;
	W.ShowWindow();
	W.BringToFront();
}

function bool WaitModal ()
{
	if ( (ModalWindow != None) && ModalWindow.bWindowVisible )
	{
		return True;
	}
	ModalWindow=None;
	return False;
}

function WindowHidden ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.WindowHidden();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function WindowShown ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.WindowShown();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function bool CheckMousePassThrough (float X, float Y)
{
	return False;
}

function bool WindowIsVisible ()
{
	if (  !bWindowVisible )
	{
		return False;
	}
	return ParentWindow.WindowIsVisible();
}