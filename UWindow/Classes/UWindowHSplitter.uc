//================================================================================
// UWindowHSplitter.
//================================================================================
class UWindowHSplitter expands UWindowWindow;

var UWindowWindow LeftClientWindow;
var UWindowWindow RightClientWindow;
var bool bSizing;
var float SplitPos;
var float MinWinWidth;
var float OldWinWidth;
var bool bRightGrow;
var bool bSizable;

function Created ()
{
	Super.Created();
	bAlwaysBehind=True;
	SplitPos=WinWidth / 2;
	MinWinWidth=24.00;
	OldWinWidth=WinWidth;
}

function Paint (Canvas C, float X, float Y)
{
	local Texture t;

	t=GetLookAndFeelTexture();
	DrawUpBevel(C,SplitPos,0.00,7.00,WinHeight,t);
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float NewW;
	local float NewH;

	if ( (OldWinWidth != WinWidth) &&  !bRightGrow )
	{
		SplitPos=SplitPos + WinWidth - OldWinWidth;
	}
	SplitPos=FClamp(SplitPos,MinWinWidth,WinWidth - 7 - MinWinWidth);
	NewW=SplitPos;
	NewH=WinHeight;
	if ( (NewH != LeftClientWindow.WinHeight) || (NewW != LeftClientWindow.WinWidth) )
	{
		LeftClientWindow.SetSize(NewW,NewH);
	}
	LeftClientWindow.WinTop=0.00;
	LeftClientWindow.WinLeft=0.00;
	NewW=WinWidth - SplitPos - 7;
	if ( (NewH != RightClientWindow.WinHeight) || (NewW != RightClientWindow.WinWidth) )
	{
		RightClientWindow.SetSize(NewW,NewH);
	}
	RightClientWindow.WinTop=0.00;
	RightClientWindow.WinLeft=SplitPos + 7;
	OldWinWidth=WinWidth;
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bSizable && (X >= SplitPos) && (X <= SplitPos + 7) )
	{
		bSizing=True;
		Root.CaptureMouse();
	}
}

function MouseMove (float X, float Y)
{
	if ( bSizable && (X >= SplitPos) && (X <= SplitPos + 7) )
	{
		Cursor=Root.HSplitCursor;
	}
	else
	{
		Cursor=Root.NormalCursor;
	}
	if ( bSizing && bMouseDown )
	{
		SplitPos=X;
	}
	else
	{
		bSizing=False;
	}
}

defaultproperties
{
    bSizable=True
}