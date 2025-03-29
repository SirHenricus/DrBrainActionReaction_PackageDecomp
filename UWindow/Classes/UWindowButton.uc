//================================================================================
// UWindowButton.
//================================================================================
class UWindowButton expands UWindowDialogControl;

var bool bDisabled;
var bool bStretched;
var Texture UpTexture;
var Texture DownTexture;
var Texture DisabledTexture;
var Texture OverTexture;
var Region UpRegion;
var Region DownRegion;
var Region DisabledRegion;
var Region OverRegion;
var bool bUseRegion;
var float RegionScale;
var string ToolTipString;
var float ImageX;
var float ImageY;
var Sound OverSound;
var Sound DownSound;

function Created ()
{
	Super.Created();
	ImageX=0.00;
	ImageY=0.00;
	TextX=0.00;
	TextY=0.00;
	RegionScale=1.00;
}

function BeforePaint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[Font];
}

function Paint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[Font];
	if ( bDisabled )
	{
		if ( DisabledTexture != None )
		{
			if ( bUseRegion )
			{
				DrawStretchedTextureSegment(C,ImageX,ImageY,DisabledRegion.W * RegionScale,DisabledRegion.H * RegionScale,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
			}
			else
			{
				if ( bStretched )
				{
					DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DisabledTexture);
				}
				else
				{
					DrawClippedTexture(C,ImageX,ImageY,DisabledTexture);
				}
			}
		}
	}
	else
	{
		if ( bMouseDown )
		{
			if ( DownTexture != None )
			{
				if ( bUseRegion )
				{
					DrawStretchedTextureSegment(C,ImageX,ImageY,DownRegion.W * RegionScale,DownRegion.H * RegionScale,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
				}
				else
				{
					if ( bStretched )
					{
						DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DownTexture);
					}
					else
					{
						DrawClippedTexture(C,ImageX,ImageY,DownTexture);
					}
				}
			}
		}
		else
		{
			if ( MouseIsOver() )
			{
				if ( OverTexture != None )
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,OverRegion.W * RegionScale,OverRegion.H * RegionScale,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,OverTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,OverTexture);
						}
					}
				}
			}
			else
			{
				if ( UpTexture != None )
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,UpRegion.W * RegionScale,UpRegion.H * RegionScale,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,UpTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,UpTexture);
						}
					}
				}
			}
		}
	}
	if ( Text != "" )
	{
		C.DrawColor=TextColor;
		ClipText(C,TextX,TextY,Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	Notify(9);
	if ( ToolTipString != "" )
	{
		ToolTip("");
	}
}

function MouseEnter ()
{
	MouseLeave();
	Notify(12);
	if ( ToolTipString != "" )
	{
		ToolTip(ToolTipString);
	}
	if (  !bDisabled && (OverSound != None) )
	{
		GetPlayerOwner().PlaySound(OverSound,6);
	}
}

function Click (float X, float Y)
{
	Notify(2);
	if (  !bDisabled && (DownSound != None) )
	{
		GetPlayerOwner().PlaySound(DownSound,3);
	}
}

function DoubleClick (float X, float Y)
{
	Notify(11);
}

function RClick (float X, float Y)
{
	Notify(6);
}

function MClick (float X, float Y)
{
	Notify(5);
}

function KeyDown (int Key, float X, float Y)
{
	local PlayerPawn P;

	P=Root.GetPlayerOwner();
	switch (Key)
	{
		case P.32:
		LMouseDown(X,Y);
		LMouseUp(X,Y);
		break;
		default:
		Super.KeyDown(Key,X,Y);
		break;
	}
}