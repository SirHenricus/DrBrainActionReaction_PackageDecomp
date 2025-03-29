//================================================================================
// UWindowScrollingDialogClient.
//================================================================================
class UWindowScrollingDialogClient expands UWindowPageWindow;

var bool bShowHorizSB;
var bool bShowVertSB;
var UWindowDialogClientWindow ClientArea;
var UWindowDialogClientWindow FixedArea;
var Class<UWindowDialogClientWindow> ClientClass;
var Class<UWindowDialogClientWindow> FixedAreaClass;
var UWindowVScrollbar VertSB;
var UWindowHScrollbar HorizSB;
var UWindowBitmap BRBitmap;

function Created ()
{
	Super.Created();
	if ( FixedAreaClass != None )
	{
		FixedArea=UWindowDialogClientWindow(CreateWindow(FixedAreaClass,0.00,0.00,100.00,100.00,OwnerWindow));
		FixedArea.bAlwaysOnTop=True;
	}
	else
	{
		FixedArea=None;
	}
	ClientArea=UWindowDialogClientWindow(CreateWindow(ClientClass,0.00,0.00,WinWidth,WinHeight,OwnerWindow));
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - 12,0.00,12.00,WinHeight));
	VertSB.bAlwaysOnTop=True;
	VertSB.HideWindow();
	HorizSB=UWindowHScrollbar(CreateWindow(Class'UWindowHScrollbar',0.00,WinHeight - 12,WinWidth,12.00));
	HorizSB.bAlwaysOnTop=True;
	HorizSB.HideWindow();
	BRBitmap=UWindowBitmap(CreateWindow(Class'UWindowBitmap',WinWidth - 12,WinHeight - 12,12.00,12.00));
	BRBitmap.bAlwaysOnTop=True;
	BRBitmap.HideWindow();
	BRBitmap.bStretch=True;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float ClientWidth;
	local float ClientHeight;
	local float FixedHeight;

	if ( FixedArea != None )
	{
		FixedHeight=FixedArea.WinHeight;
	}
	else
	{
		FixedHeight=0.00;
	}
	ClientWidth=ClientArea.DesiredWidth;
	ClientHeight=ClientArea.DesiredHeight;
	if ( ClientWidth <= WinWidth )
	{
		ClientWidth=WinWidth;
	}
	if ( ClientHeight <= WinHeight - FixedHeight )
	{
		ClientHeight=WinHeight - FixedHeight;
	}
	ClientArea.SetSize(ClientWidth,ClientHeight);
	bShowVertSB=ClientHeight > WinHeight - FixedHeight;
	bShowHorizSB=ClientWidth > WinWidth;
	if ( bShowHorizSB )
	{
		ClientHeight=ClientArea.DesiredHeight;
		if ( ClientHeight <= WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight )
		{
			ClientHeight=WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
		}
		bShowVertSB=ClientHeight > WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
	}
	if ( bShowVertSB )
	{
		VertSB.ShowWindow();
		VertSB.WinTop=0.00;
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
		if ( bShowHorizSB )
		{
			BRBitmap.ShowWindow();
			BRBitmap.WinWidth=LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinHeight=LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinTop=WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
			BRBitmap.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.t=GetLookAndFeelTexture();
			VertSB.WinHeight=WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
		}
		else
		{
			BRBitmap.HideWindow();
			VertSB.WinHeight=WinHeight - FixedHeight;
		}
		VertSB.SetRange(0.00,ClientHeight,VertSB.WinHeight,10.00);
	}
	else
	{
		BRBitmap.HideWindow();
		VertSB.HideWindow();
		VertSB.pos=0.00;
	}
	if ( bShowHorizSB )
	{
		HorizSB.ShowWindow();
		HorizSB.WinLeft=0.00;
		HorizSB.WinTop=WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
		HorizSB.WinHeight=LookAndFeel.Size_ScrollbarWidth;
		if ( bShowVertSB )
		{
			HorizSB.WinWidth=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		}
		else
		{
			HorizSB.WinWidth=WinWidth;
		}
		HorizSB.SetRange(0.00,ClientWidth,HorizSB.WinWidth,10.00);
	}
	else
	{
		HorizSB.HideWindow();
		HorizSB.pos=0.00;
	}
	ClientArea.WinLeft= -HorizSB.pos;
	ClientArea.WinTop= -VertSB.pos;
	if ( FixedArea != None )
	{
		FixedArea.WinLeft=0.00;
		FixedArea.WinTop=WinHeight - FixedHeight;
		FixedArea.WinWidth=WinWidth;
	}
	Super.BeforePaint(C,X,Y);
}

function GetDesiredDimensions (out float W, out float H)
{
	Super(UWindowWindow).GetDesiredDimensions(W,H);
}

function Paint (Canvas C, float X, float Y)
{
}

defaultproperties
{
    ClientClass=Class'UWindowDialogClientWindow'
}