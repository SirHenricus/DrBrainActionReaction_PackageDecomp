//================================================================================
// UWindowGrid.
//================================================================================
class UWindowGrid expands UWindowWindow;

var UWindowGridColumn FirstColumn;
var UWindowGridColumn LastColumn;
var UWindowGridClient ClientArea;
var int TopRow;
var float RowHeight;
var UWindowVScrollbar VertSB;
var UWindowHScrollbar HorizSB;
var bool bShowHorizSB;
var bool bSizingColumn;

function Created ()
{
	ClientArea=UWindowGridClient(CreateWindow(Class'UWindowGridClient',0.00,0.00,WinWidth - 12,WinHeight));
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - 12,0.00,12.00,WinHeight));
	VertSB.bAlwaysOnTop=True;
	HorizSB=UWindowHScrollbar(CreateWindow(Class'UWindowHScrollbar',0.00,WinHeight - 12,WinWidth,12.00));
	HorizSB.bAlwaysOnTop=True;
	HorizSB.HideWindow();
	bShowHorizSB=False;
	SetAcceptsFocus();
	Super.Created();
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	Resized();
}

function Resized ()
{
	local float Offset;
	local UWindowGridColumn colColumn;
	local float TotalWidth;

	TotalWidth=0.00;
	colColumn=FirstColumn;
JL0016:
	if ( colColumn != None )
	{
		TotalWidth=TotalWidth + colColumn.WinWidth;
		colColumn=colColumn.NextColumn;
		goto JL0016;
	}
	if (  !bSizingColumn )
	{
		HorizSB.SetRange(0.00,TotalWidth,WinWidth - LookAndFeel.Size_ScrollbarWidth,10.00);
	}
	if (  !HorizSB.bDisabled )
	{
		HorizSB.ShowWindow();
		bShowHorizSB=True;
	}
	else
	{
		HorizSB.HideWindow();
		bShowHorizSB=False;
		HorizSB.pos=0.00;
	}
	ClientArea.WinTop=0.00;
	ClientArea.WinLeft=0.00;
	ClientArea.WinWidth=WinWidth - LookAndFeel.Size_ScrollbarWidth;
	if ( bShowHorizSB )
	{
		ClientArea.WinHeight=WinHeight - LookAndFeel.Size_ScrollbarWidth;
	}
	else
	{
		ClientArea.WinHeight=WinHeight;
	}
	if ( bShowHorizSB )
	{
		HorizSB.WinTop=WinHeight - LookAndFeel.Size_ScrollbarWidth;
		HorizSB.WinLeft=0.00;
		HorizSB.WinWidth=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		HorizSB.WinHeight=LookAndFeel.Size_ScrollbarWidth;
	}
	VertSB.WinTop=0.00;
	VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	if ( bShowHorizSB )
	{
		VertSB.WinHeight=WinHeight - LookAndFeel.Size_ScrollbarWidth;
	}
	else
	{
		VertSB.WinHeight=WinHeight;
	}
	if ( bShowHorizSB )
	{
		Offset=1.00 - HorizSB.pos;
	}
	else
	{
		Offset=1.00;
	}
	colColumn=FirstColumn;
JL02D2:
	if ( colColumn != None )
	{
		colColumn.WinLeft=Offset;
		colColumn.WinTop=0.00;
		colColumn.WinHeight=WinHeight;
		Offset=Offset + colColumn.WinWidth;
		colColumn=colColumn.NextColumn;
		goto JL02D2;
	}
}

function UWindowGridColumn AddColumn (string ColumnHeading, float DefaultWidth)
{
	local UWindowGridColumn NewColumn;
	local UWindowGridColumn OldLastColumn;

	OldLastColumn=LastColumn;
	if ( LastColumn == None )
	{
		NewColumn=UWindowGridColumn(ClientArea.CreateWindow(Class'UWindowGridColumn',0.00,0.00,DefaultWidth,WinHeight));
		FirstColumn=NewColumn;
		NewColumn.ColumnNum=0;
	}
	else
	{
		NewColumn=UWindowGridColumn(ClientArea.CreateWindow(Class'UWindowGridColumn',LastColumn.WinLeft + LastColumn.WinWidth,0.00,DefaultWidth,WinHeight));
		LastColumn.NextColumn=NewColumn;
		NewColumn.ColumnNum=LastColumn.ColumnNum + 1;
	}
	LastColumn=NewColumn;
	NewColumn.NextColumn=None;
	NewColumn.PrevColumn=OldLastColumn;
	NewColumn.ColumnHeading=ColumnHeading;
	return NewColumn;
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local Texture t;
	local Region R;

	X=LastColumn.WinWidth + LastColumn.WinLeft;
	t=GetLookAndFeelTexture();
	DrawUpBevel(C,X,0.00,WinWidth - X,LookAndFeel.ColumnHeadingHeight,t);
	if ( bShowHorizSB )
	{
		DrawStretchedTextureSegment(C,WinWidth - LookAndFeel.Size_ScrollbarWidth,WinHeight - LookAndFeel.Size_ScrollbarWidth,LookAndFeel.Size_ScrollbarWidth,LookAndFeel.Size_ScrollbarWidth,R.X,R.Y,R.W,R.H,t);
	}
}

function PaintColumn (Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
}

function SortColumn (UWindowGridColumn Column)
{
}

function SelectRow (int Row)
{
}

function RightClickRow (int Row, float X, float Y)
{
}

function DoubleClickRow (int Row)
{
}

function MouseLeaveColumn (UWindowGridColumn Column)
{
}

function KeyDown (int Key, float X, float Y)
{
	switch (Key)
	{
		case 38:
		case 236:
		VertSB.Scroll(-1.00);
		break;
		case 40:
		case 237:
		VertSB.Scroll(1.00);
		break;
		case 33:
		VertSB.Scroll( -VertSB.MaxVisible - 1);
		break;
		case 34:
		VertSB.Scroll(VertSB.MaxVisible - 1);
		break;
		default:
	}
}

defaultproperties
{
    RowHeight=10.00
}