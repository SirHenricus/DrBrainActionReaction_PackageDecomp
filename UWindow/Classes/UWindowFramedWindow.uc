//================================================================================
// UWindowFramedWindow.
//================================================================================
class UWindowFramedWindow expands UWindowWindow;

var Class<UWindowWindow> ClientClass;
var UWindowWindow ClientArea;
var string WindowTitle;
var string StatusBarText;
var float MoveX;
var float MoveY;
var float MinWinWidth;
var float MinWinHeight;
var bool bTLSizing;
var bool bTSizing;
var bool bTRSizing;
var bool bLSizing;
var bool bRSizing;
var bool bBLSizing;
var bool bBSizing;
var bool bBRSizing;
var bool bMoving;
var bool bSizable;
var bool bStatusBar;
var UWindowFrameCloseBox CloseBox;

function Created ()
{
	MinWinWidth=50.00;
	MinWinHeight=50.00;
	ClientArea=CreateWindow(ClientClass,4.00,16.00,WinWidth - 8,WinHeight - 20,OwnerWindow);
	CloseBox=UWindowFrameCloseBox(CreateWindow(Class'UWindowFrameCloseBox',WinWidth - 20,WinHeight - 20,11.00,10.00));
}

function Texture GetLookAndFeelTexture ()
{
	return LookAndFeel.GetTexture(self);
}

function bool IsActive ()
{
	return ParentWindow.ActiveWindow == self;
}

function BeforePaint (Canvas C, float X, float Y)
{
	LookAndFeel.FW_SetupFrameButtons(self,C);
	Super.BeforePaint(C,X,Y);
	Resized();
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.FW_DrawWindowFrame(self,C);
}

function LMouseDown (float X, float Y)
{
	local FrameHitTest H;

	H=LookAndFeel.FW_HitTest(self,X,Y);
	Super.LMouseDown(X,Y);
	if ( H == 8 )
	{
		MoveX=X;
		MoveY=Y;
		bMoving=True;
		Root.CaptureMouse();
		return;
	}
	if ( bSizable )
	{
		switch (H)
		{
			case 0:
			bTLSizing=True;
			Root.CaptureMouse();
			return;
			case 2:
			bTRSizing=True;
			Root.CaptureMouse();
			return;
			case 5:
			bBLSizing=True;
			Root.CaptureMouse();
			return;
			case 7:
			bBRSizing=True;
			Root.CaptureMouse();
			return;
			case 1:
			bTSizing=True;
			Root.CaptureMouse();
			return;
			case 6:
			bBSizing=True;
			Root.CaptureMouse();
			return;
			case 3:
			bLSizing=True;
			Root.CaptureMouse();
			return;
			case 4:
			bRSizing=True;
			Root.CaptureMouse();
			return;
			default:
		}
	}
}

function Resized ()
{
	local Region R;

	if ( ClientArea == None )
	{
		Log("Client Area is None for " $ string(self));
		return;
	}
	R=LookAndFeel.FW_GetClientArea(self);
	ClientArea.WinLeft=R.X;
	ClientArea.WinTop=R.Y;
	if ( (R.W != ClientArea.WinWidth) || (R.H != ClientArea.WinHeight) )
	{
		ClientArea.SetSize(R.W,R.H);
	}
}

function MouseMove (float X, float Y)
{
	local float OldW;
	local float OldH;
	local FrameHitTest H;

	H=LookAndFeel.FW_HitTest(self,X,Y);
	if ( bMoving && bMouseDown )
	{
		WinLeft=WinLeft + X - MoveX;
		WinTop=WinTop + Y - MoveY;
	}
	else
	{
		bMoving=False;
	}
	Cursor=Root.NormalCursor;
	if ( bSizable &&  !bMoving )
	{
		switch (H)
		{
			case 0:
			case 7:
			Cursor=Root.DiagCursor1;
			break;
			case 2:
			case 5:
			Cursor=Root.DiagCursor2;
			break;
			case 3:
			case 4:
			Cursor=Root.WECursor;
			break;
			case 1:
			case 6:
			Cursor=Root.NSCursor;
			break;
			default:
		}
	}
	if ( bTLSizing && bMouseDown )
	{
		Cursor=Root.DiagCursor1;
		OldW=WinWidth;
		OldH=WinHeight;
		SetSize(Max(MinWinWidth,WinWidth - X),Max(MinWinHeight,WinHeight - Y));
		WinLeft=WinLeft + OldW - WinWidth;
		WinTop=WinTop + OldH - WinHeight;
	}
	else
	{
		bTLSizing=False;
	}
	if ( bTSizing && bMouseDown )
	{
		Cursor=Root.NSCursor;
		OldH=WinHeight;
		SetSize(WinWidth,Max(MinWinHeight,WinHeight - Y));
		WinTop=WinTop + OldH - WinHeight;
	}
	else
	{
		bTSizing=False;
	}
	if ( bTRSizing && bMouseDown )
	{
		Cursor=Root.DiagCursor2;
		OldH=WinHeight;
		SetSize(Max(MinWinWidth,X),Max(MinWinHeight,WinHeight - Y));
		WinTop=WinTop + OldH - WinHeight;
	}
	else
	{
		bTRSizing=False;
	}
	if ( bLSizing && bMouseDown )
	{
		Cursor=Root.WECursor;
		OldW=WinWidth;
		SetSize(Max(MinWinWidth,WinWidth - X),WinHeight);
		WinLeft=WinLeft + OldW - WinWidth;
	}
	else
	{
		bLSizing=False;
	}
	if ( bRSizing && bMouseDown )
	{
		Cursor=Root.WECursor;
		SetSize(Max(MinWinWidth,X),WinHeight);
	}
	else
	{
		bRSizing=False;
	}
	if ( bBLSizing && bMouseDown )
	{
		Cursor=Root.DiagCursor2;
		OldW=WinWidth;
		SetSize(Max(MinWinWidth,WinWidth - X),Max(MinWinHeight,Y));
		WinLeft=WinLeft + OldW - WinWidth;
	}
	else
	{
		bBLSizing=False;
	}
	if ( bBSizing && bMouseDown )
	{
		Cursor=Root.NSCursor;
		SetSize(WinWidth,Max(MinWinHeight,Y));
	}
	else
	{
		bBSizing=False;
	}
	if ( bBRSizing && bMouseDown )
	{
		Cursor=Root.DiagCursor1;
		SetSize(Max(MinWinWidth,X),Max(MinWinHeight,Y));
	}
	else
	{
		bBRSizing=False;
	}
}

function ToolTip (string strTip)
{
	StatusBarText=strTip;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	if ( (Msg == 9) ||  !WaitModal() )
	{
		Super.WindowEvent(Msg,C,X,Y,Key);
	}
}

defaultproperties
{
    ClientClass=Class'UWindowClientWindow'
}