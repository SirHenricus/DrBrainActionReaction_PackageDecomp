//================================================================================
// UWindowVScrollbar.
//================================================================================
class UWindowVScrollbar expands UWindowWindow;

var UWindowSBUpButton UpButton;
var UWindowSBDownButton DownButton;
var bool bDisabled;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbHeight;
var float NextClickTime;
var float DragY;
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
	DownButton.bDisabled=bDisabled;
	UpButton.bDisabled=bDisabled;
	if ( bDisabled )
	{
		pos=0.00;
	}
	else
	{
		ThumbStart=(pos - MinPos) * (WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight) / (MaxPos + MaxVisible - MinPos);
		ThumbHeight=MaxVisible * (WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight) / (MaxPos + MaxVisible - MinPos);
		if ( ThumbHeight < LookAndFeel.Size_MinScrollbarHeight )
		{
			ThumbHeight=LookAndFeel.Size_MinScrollbarHeight;
		}
		if ( ThumbHeight + ThumbStart > WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight )
		{
			ThumbStart=WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight - ThumbHeight;
		}
		ThumbStart=ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight;
	}
}

function Created ()
{
	Super.Created();
	UpButton=UWindowSBUpButton(CreateWindow(Class'UWindowSBUpButton',0.00,0.00,12.00,10.00));
	DownButton=UWindowSBDownButton(CreateWindow(Class'UWindowSBDownButton',0.00,WinHeight - 10,12.00,10.00));
}

function BeforePaint (Canvas C, float X, float Y)
{
	UpButton.WinTop=0.00;
	UpButton.WinLeft=0.00;
	UpButton.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	UpButton.WinHeight=LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinTop=WinHeight - LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinLeft=0.00;
	DownButton.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	DownButton.WinHeight=LookAndFeel.Size_ScrollbarButtonHeight;
	CheckRange();
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.SB_VDraw(self,C);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( Y < ThumbStart )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.50;
		return;
	}
	if ( Y > ThumbStart + ThumbHeight )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.50;
		return;
	}
	if ( (Y >= ThumbStart) && (Y <= ThumbStart + ThumbHeight) )
	{
		DragY=Y - ThumbStart;
		bDragging=True;
		Root.CaptureMouse();
		return;
	}
}

function Tick (float Delta)
{
	local bool bUp;
	local bool bDown;
	local float X;
	local float Y;

	if ( bDragging )
	{
		return;
	}
	bUp=False;
	bDown=False;
	if ( bMouseDown )
	{
		GetMouseXY(X,Y);
		bUp=Y < ThumbStart;
		bDown=Y > ThumbStart + ThumbHeight;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetLevel().TimeSeconds) && bUp )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.10;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetLevel().TimeSeconds) && bDown )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetLevel().TimeSeconds + 0.10;
	}
	if (  !bMouseDown ||  !bUp &&  !bDown )
	{
		NextClickTime=0.00;
	}
}

function MouseMove (float X, float Y)
{
	if ( bDragging && bMouseDown &&  !bDisabled )
	{
JL0021:
		if ( (Y < ThumbStart + DragY) && (pos > MinPos) )
		{
			Scroll(-1.00);
			goto JL0021;
		}
JL0056:
		if ( (Y > ThumbStart + DragY) && (pos < MaxPos) )
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