//================================================================================
// UWindowTextAreaControl.
//================================================================================
class UWindowTextAreaControl expands UWindowDialogControl;

var string TextArea[750];
var string Prompt;
var int Font;
var Font AbsoluteFont;
var int BufSize;
var int Head;
var int Tail;
var int Lines;
var int VisibleRows;
var bool bCursor;
var bool bScrollable;
var bool bShowCaret;
var UWindowVScrollbar VertSB;
var float LastDrawTime;

function Created ()
{
	Super.Created();
	LastDrawTime=GetLevel().TimeSeconds;
}

function SetScrollable (bool newScrollable)
{
	bScrollable=newScrollable;
	if ( newScrollable )
	{
		VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - 12,0.00,12.00,WinHeight));
		VertSB.bAlwaysOnTop=True;
	}
	else
	{
		if ( VertSB != None )
		{
			VertSB.Close();
			VertSB=None;
		}
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	if ( VertSB != None )
	{
		VertSB.WinTop=0.00;
		VertSB.WinHeight=WinHeight;
		VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
	}
}

function SetAbsoluteFont (Font F)
{
	AbsoluteFont=F;
}

function Paint (Canvas C, float X, float Y)
{
	local int i;
	local int j;
	local int Line;
	local int TempHead;
	local int TempTail;
	local float XL;
	local float YL;
	local float W;
	local float H;

	if ( AbsoluteFont != None )
	{
		C.Font=AbsoluteFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	TextSize(C,"TEST",XL,YL);
	VisibleRows=WinHeight / YL;
	TempHead=Head;
	TempTail=Tail;
	Line=TempHead;
	TextArea[Line]=Prompt;
	if ( Prompt == "" )
	{
		Line--;
		if ( Line < 0 )
		{
			Line += BufSize;
		}
	}
	if ( bScrollable )
	{
		if ( VertSB.MaxPos - VertSB.pos >= 0 )
		{
			Line -= VertSB.MaxPos - VertSB.pos;
			TempTail -= VertSB.MaxPos - VertSB.pos;
			if ( Line < 0 )
			{
				Line += BufSize;
			}
			if ( TempTail < 0 )
			{
				TempTail += BufSize;
			}
		}
	}
	if (  !bCursor )
	{
		bShowCaret=False;
	}
	else
	{
		if ( (GetLevel().TimeSeconds > LastDrawTime + 0.30) || (GetLevel().TimeSeconds < LastDrawTime) )
		{
			LastDrawTime=GetLevel().TimeSeconds;
			bShowCaret= !bShowCaret;
		}
	}
	i=0;
JL0238:
	if ( i < VisibleRows + 1 )
	{
		ClipText(C,2.00,WinHeight - YL * (i + 1),TextArea[Line]);
		if ( (Line == Head) && bShowCaret )
		{
			TextSize(C,TextArea[Line],W,H);
			ClipText(C,W,WinHeight - YL * (i + 1),"|");
		}
		if ( TempTail == Line )
		{
			goto JL031A;
		}
		Line--;
		if ( Line < 0 )
		{
			Line += BufSize;
		}
		i++;
		goto JL0238;
	}
JL031A:
}

function AddText (string NewLine)
{
	local int i;

	TextArea[Head]=NewLine;
	Head=(Head + 1) % BufSize;
	if ( Head == Tail )
	{
		Tail=(Tail + 1) % BufSize;
	}
	Lines=Head - Tail;
	if ( Lines < 0 )
	{
		Lines += BufSize;
	}
	if ( bScrollable )
	{
		VertSB.SetRange(0.00,Lines,VisibleRows);
		VertSB.pos=VertSB.MaxPos;
	}
}

function Resized ()
{
	if ( bScrollable )
	{
		VertSB.SetRange(0.00,Lines,VisibleRows);
		VertSB.pos=VertSB.MaxPos;
	}
}

function SetPrompt (string NewPrompt)
{
	Prompt=NewPrompt;
}

function Clear ()
{
	TextArea[0]="";
	Head=0;
	Tail=0;
}

defaultproperties
{
    BufSize=750
}