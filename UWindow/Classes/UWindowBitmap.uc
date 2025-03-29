//================================================================================
// UWindowBitmap.
//================================================================================
class UWindowBitmap expands UWindowWindow;

var Texture t;
var Region R;
var bool bStretch;
var bool bCenter;

function Paint (Canvas C, float X, float Y)
{
	if ( bStretch )
	{
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,R.X,R.Y,R.W,R.H,t);
	}
	else
	{
		if ( bCenter )
		{
			DrawStretchedTextureSegment(C,(WinWidth - R.W) / 2,(WinHeight - R.H) / 2,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		}
		else
		{
			DrawStretchedTextureSegment(C,0.00,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		}
	}
}