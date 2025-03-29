//================================================================================
// UWindowHScrollbar.
//================================================================================
class UWindowHScrollbar expands UWindowWindow;

var UWindowSBLeftButton LeftButton;
var UWindowSBRightButton RightButton;
var bool bDisabled;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbWidth;
var float NextClickTime;
var float DragX;
var bool bDragging;
var float ScrollAmount;

function Show (float P)
{
	if ( P < 0 )
	{
		return;
	}
	if ( P > MaxPos + MaxVisible )
	{
		return;
	}
JL0026:
	if ( P < pos )
	{
		Scroll(-1.00);
		goto JL0026;
	}
JL0043:
	if ( P - pos > MaxVisible - 1 )
	{
		Scroll(1.00);
		goto JL0043;
	}
}

function Scroll (float Delta)
{
	pos=pos + Delta;
	CheckRange();
}

function SetRange (float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if ( NewScrollAmount == 0 )
	{
		NewScrollAmount=1.00;
	}
	ScrollAmount=NewScrollAmount;
	MinPos=NewMinPos;
	MaxPos=NewMaxPos - NewMaxVisible;
	MaxVisible=NewMaxVisible;
	CheckRange();
}

function CheckRange ()
{
	if ( pos < MinPos )
	{
		pos=MinPos;
	}
	else
	{
		if ( pos > MaxPos )
		{
			pos=MaxPos;
		}
	}
	bDisabled=MaxPos <= MinPos;
	LeftButton.bDisabled=bDisabled;
	RightButton.bDisabled=bDisabled;
	if ( bDisabled )
	{
		pos=0.00;
	}
	else
	{
		ThumbStart=(pos - MinPos) * (WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight) / (MaxPos + MaxVisible - MinPos);
		ThumbWidth=MaxVisible * (WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight) / (MaxPos + MaxVisible - MinPos);
		if ( ThumbWidth < LookAndFeel.Size_MinScrollbarHeight )
		{
			ThumbWidth=LookAndFeel.Size_MinScrollbarHeight;
		}
		if ( ThumbWidth + ThumbStart > WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight )
		{
			ThumbStart=WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight - ThumbWidth;
		}
		ThumbStart=ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight;
	}
}

function Created ()
{
	Super.Created();
	LeftButton=UWindowSBLeftButton(CreateWindow(Class'UWindowSBLeftButton',0.00,0.00,10.00,12.00));
	RightButton=UWindowSBRightButton(CreateWindow(Class'UWindowSBRightButton',WinWidth - 10,0.00,10.00,12.00));
}

function BeforePaint (Canvas C, float X, float Y)
{
	LeftButton.WinTop=0.00;
	LeftButton.WinLeft=0.00;
	LeftButton.WinWidth=LookAndFeel.Size_ScrollbarButtonHeight;
	LeftButton.WinHeight=LookAndFeel.Size_ScrollbarWidth;
	RightButton.WinTop=0.00;
	RightButton.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarButtonHeight;
	RightButton.WinWidth=LookAndFeel.Size_ScrollbarButtonHeight;
	RightButton.WinHeight=LookAndFeel.Size_ScrollbarWidth;
	CheckRange();
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.SB_HDraw(self,C);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( X < ThumbStart )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.50;
		return;
	}
	if ( X > ThumbStart + ThumbWidth )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.50;
		return;
	}
	if ( (X >= ThumbStart) && (X <= ThumbStart + ThumbWidth) )
	{
		DragX=X - ThumbStart;
		bDragging=True;
		Root.CaptureMouse();
		return;
	}
}

function Tick (float Delta)
{
	local bool bLeft;
	local bool bRight;
	local float X;
	local float Y;

	if ( bDragging )
	{
		return;
	}
	bLeft=False;
	bRight=False;
	if ( bMouseDown )
	{
		GetMouseXY(X,Y);
		bLeft=X < ThumbStart;
		bRight=X > ThumbStart + ThumbWidth;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetLevel().TimeSeconds) && bLeft )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.10;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetLevel().TimeSeconds) && bRight )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.10;
	}
	if (  !bMouseDown ||  !bLeft &&  !bRight )
	{
		NextClickTime=0.00;
	}
}

function MouseMove (float X, float Y)
{
	if ( bDragging && bMouseDown &&  !bDisabled )
	{
JL0021:
		if ( (X < ThumbStart + DragX) && (pos > MinPos) )
		{
			Scroll(-1.00);
			goto JL0021;
		}
JL0056:
		if ( (X > ThumbStart + DragX) && (pos < MaxPos) )
		{
			Scroll(1.00);
			goto JL0056;
		}
	}
	else
	{
		bDragging=False;
	}
}