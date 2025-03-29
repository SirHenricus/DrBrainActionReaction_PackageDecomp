//================================================================================
// UWindowProgressBar.
//================================================================================
class UWindowProgressBar expands UWindowWindow;

const BlockWidth=7;
var float Percent;

function SetPercent (float NewPercent)
{
	Percent=NewPercent;
}

function Paint (Canvas C, float X, float Y)
{
	local float BlockX;
	local float BlockW;

	DrawMiscBevel(C,0.00,0.00,WinWidth,WinHeight,LookAndFeel.Misc,2);
	C.DrawColor.R=192;
	C.DrawColor.G=192;
	C.DrawColor.B=192;
	DrawStretchedTextureSegment(C,LookAndFeel.MiscBevelL[2].W,LookAndFeel.MiscBevelT[2].H,WinWidth - LookAndFeel.MiscBevelL[2].W - LookAndFeel.MiscBevelR[2].W,WinHeight - LookAndFeel.MiscBevelT[2].H - LookAndFeel.MiscBevelB[2].H,0.00,0.00,1.00,1.00,Texture'WhiteTexture');
	C.DrawColor.R=0;
	C.DrawColor.G=0;
	C.DrawColor.B=255;
	BlockX=LookAndFeel.MiscBevelL[2].W + 1;
JL0194:
	if ( BlockX < 1 + LookAndFeel.MiscBevelL[2].W + Percent * (WinWidth - LookAndFeel.MiscBevelL[2].W - LookAndFeel.MiscBevelR[2].W - 2) / 100 )
	{
		BlockW=Min(7,WinWidth - LookAndFeel.MiscBevelR[2].W - BlockX - 1);
		DrawStretchedTextureSegment(C,BlockX,LookAndFeel.MiscBevelT[2].H + 1,BlockW,WinHeight - LookAndFeel.MiscBevelT[2].H - LookAndFeel.MiscBevelB[2].H - 1,0.00,0.00,1.00,1.00,Texture'WhiteTexture');
		BlockX += 7 + 1;
		goto JL0194;
	}
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
}