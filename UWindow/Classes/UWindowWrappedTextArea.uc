//================================================================================
// UWindowWrappedTextArea.
//================================================================================
class UWindowWrappedTextArea expands UWindowTextAreaControl;

function Paint (Canvas C, float X, float Y)
{
	local int i;
	local int j;
	local int Line;
	local int TempHead;
	local int TempTail;
	local float XL;
	local float YL;

	C.Font=Root.Fonts[Font];
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	TextSize(C,"TEST",XL,YL);
	VisibleRows=WinHeight / YL;
	if ( bScrollable )
	{
		VertSB.SetRange(0.00,Lines,VisibleRows);
	}
	TempHead=Head;
	TempTail=Tail;
	Line=TempHead;
	TextArea[Line]=Prompt;
	if ( bScrollable )
	{
		if ( VertSB.MaxPos - VertSB.pos > 0 )
		{
			Line -= VertSB.MaxPos - VertSB.pos;
			TempTail -= VertSB.MaxPos - VertSB.pos;
		}
	}
	i=0;
JL0172:
	if ( i < VisibleRows )
	{
		WrapClipText(C,2.00,YL * (VisibleRows - i - 1),TextArea[Line - 1]);
		Line--;
		if ( TempTail == Line )
		{
			goto JL01F2;
		}
		if ( Line < 0 )
		{
			Line=BufSize - 1;
		}
		i++;
		goto JL0172;
	}
JL01F2:
}