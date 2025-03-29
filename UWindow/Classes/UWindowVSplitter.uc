//================================================================================
// UWindowVSplitter.
//================================================================================
class UWindowVSplitter expands UWindowWindow;

var UWindowWindow TopClientWindow;
var UWindowWindow BottomClientWindow;
var bool bSizing;
var float SplitPos;
var float MinWinHeight;
var float OldWinHeight;
var bool bBottomGrow;
var bool bSizable;

function Created ()
{
	Super.Created();
	bAlwaysBehind=True;
	SplitPos=WinHeight / 2;
	MinWinHeight=24.00;
	OldWinHeight=WinHeight;
}

function Paint (Canvas C, float X, float Y)
{
	local Texture t;

	t=GetLookAndFeelTexture();
	DrawUpBevel(C,0.00,SplitPos,WinWidth,7.00,t);
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float NewW;
	local float NewH;

	if ( (OldWinHeight != WinHeight) &&  !bBottomGrow )
	{
		SplitPos=SplitPos + WinHeight - OldWinHeight;
	}
	SplitPos=FClamp(SplitPos,MinWinHeight,WinHeight - 7 - MinWinHeight);
	NewW=WinWidth;
	NewH=SplitPos;
	if ( (NewW != TopClientWindow.WinWidth) || (NewH != TopClientWindow.WinHeight) )
	{
		TopClientWindow.SetSize(NewW,NewH);
	}
	NewH=WinHeight - SplitPos - 7;
	if ( (NewW != BottomClientWindow.WinWidth) || (NewH != BottomClientWindow.WinHeight) )
	{
		BottomClientWindow.SetSize(NewW,NewH);
	}
	BottomClientWindow.WinTop=SplitPos + 7;
	BottomClientWindow.WinLeft=0.00;
	OldWinHeight=WinHeight;
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bSizable && (Y >= SplitPos) && (Y <= SplitPos + 7) )
	{
		bSizing=True;
		Root.CaptureMouse();
	}
}

function MouseMove (float X, float Y)
{
	if ( bSizable && (Y >= SplitPos) && (Y <= SplitPos + 7) )
	{
		Cursor=Root.VSplitCursor;
	}
	else
	{
		Cursor=Root.NormalCursor;
	}
	if ( bSizing && bMouseDown )
	{
		SplitPos=Y;
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