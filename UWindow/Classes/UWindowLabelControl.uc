//================================================================================
// UWindowLabelControl.
//================================================================================
class UWindowLabelControl expands UWindowDialogControl;

function Created ()
{
	TextX=0.00;
	TextY=0.00;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	Super.BeforePaint(C,X,Y);
	TextSize(C,Text,W,H);
	WinHeight=H + 1;
	TextY=(WinHeight - H) / 2;
	switch (Align)
	{
		case 0:
		break;
		case 2:
		TextX=(WinWidth - W) / 2;
		break;
		case 1:
		TextX=WinWidth - W;
		break;
		default:
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( Text != "" )
	{
		C.DrawColor=TextColor;
		C.Font=Root.Fonts[Font];
		ClipText(C,TextX,TextY,Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}