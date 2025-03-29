//================================================================================
// UWindowComboList.
//================================================================================
class UWindowComboList expands UWindowListControl;

var UWindowComboControl Owner;
var UWindowVScrollbar VertSB;
var UWindowComboListItem Selected;
var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;
var int MaxVisible;

function Sort ()
{
	Items.Sort();
}

function Clear ()
{
	Items.Clear();
}

function Texture GetLookAndFeelTexture ()
{
	return LookAndFeel.Active;
}

function Setup ()
{
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',0.00,WinWidth - 16,16.00,WinHeight));
}

function Created ()
{
	ListClass=Class'UWindowComboListItem';
	bAlwaysOnTop=True;
	bTransient=True;
	Super.Created();
	ItemHeight=15;
	VBorder=3;
	HBorder=3;
	TextBorder=9;
	Super.Created();
}

function int FindItemIndex (string Value, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( bIgnoreCase && (i.Value ~= Value) )
		{
			return Count;
		}
		if ( i.Value == Value )
		{
			return Count;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return -1;
}

function int FindItemIndex2 (string Value2, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( bIgnoreCase && (i.Value2 ~= Value2) )
		{
			return Count;
		}
		if ( i.Value2 == Value2 )
		{
			return Count;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return -1;
}

function string GetItemValue (int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( Count == Index )
		{
			return i.Value;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return "";
}

function string GetItemValue2 (int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( Count == Index )
		{
			return i.Value2;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return "";
}

function AddItem (string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i=UWindowComboListItem(Items.Append(Class'UWindowComboListItem'));
	i.Value=Value;
	i.Value2=Value2;
	i.SortWeight=SortWeight;
}

function InsertItem (string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i=UWindowComboListItem(Items.Insert(Class'UWindowComboListItem'));
	i.Value=Value;
	i.Value2=Value2;
	i.SortWeight=SortWeight;
}

function SetSelected (float X, float Y)
{
	local UWindowComboListItem NewSelected;
	local UWindowComboListItem Item;
	local int i;
	local int Count;

	Count=0;
	Item=UWindowComboListItem(Items.Next);
JL0020:
	if ( Item != None )
	{
		Count++;
		Item=UWindowComboListItem(Item.Next);
		goto JL0020;
	}
	i=(Y - VBorder) / ItemHeight + VertSB.pos;
	if ( i < 0 )
	{
		i=0;
	}
	if ( i >= VertSB.pos + Min(Count,MaxVisible) )
	{
		i=VertSB.pos + Min(Count,MaxVisible) - 1;
	}
	NewSelected=UWindowComboListItem(Items.FindEntry(i));
	if ( NewSelected != Selected )
	{
		if ( NewSelected == None )
		{
			Selected=None;
		}
		else
		{
			Selected=NewSelected;
		}
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	if ( Y > WinHeight )
	{
		VertSB.Scroll(1.00);
	}
	if ( Y < 0 )
	{
		VertSB.Scroll(-1.00);
	}
	SetSelected(X,Y);
	FocusWindow();
}

function LMouseUp (float X, float Y)
{
	if ( (Y >= 0) && (Y <= WinHeight) && (Selected != None) )
	{
		ExecuteItem(Selected);
	}
	Super.LMouseUp(X,Y);
}

function LMouseDown (float X, float Y)
{
	Root.CaptureMouse();
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float MaxWidth;
	local int Count;
	local UWindowComboListItem i;
	local float ListX;
	local float ListY;

	C.Font=Root.Fonts[0];
	C.SetPos(0.00,0.00);
	MaxWidth=Owner.EditBox.WinWidth + Owner.Button.WinWidth;
	Count=0;
	i=UWindowComboListItem(Items.Next);
JL008E:
	if ( i != None )
	{
		Count++;
		TextSize(C,RemoveAmpersand(i.Value),W,H);
		if ( W > MaxWidth )
		{
			MaxWidth=W;
		}
		i=UWindowComboListItem(i.Next);
		goto JL008E;
	}
	if ( Count > MaxVisible )
	{
		MaxWidth += LookAndFeel.Size_ScrollbarWidth;
		WinHeight=ItemHeight * MaxVisible + VBorder * 2;
	}
	else
	{
		VertSB.pos=0.00;
		WinHeight=ItemHeight * Count + VBorder * 2;
	}
	WinWidth=MaxWidth + (HBorder + TextBorder) * 2;
	ListX=Owner.Button.WinLeft + Owner.Button.WinWidth - WinWidth;
	ListY=Owner.Button.WinTop + Owner.Button.WinHeight;
	if ( Count > MaxVisible )
	{
		VertSB.ShowWindow();
		VertSB.SetRange(0.00,Count,MaxVisible);
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth - HBorder;
		VertSB.WinTop=HBorder;
		VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinHeight=WinHeight - 2 * VBorder;
		ListX += HBorder;
	}
	else
	{
		VertSB.HideWindow();
	}
	Owner.WindowToGlobal(ListX,ListY,WinLeft,WinTop);
}

function Paint (Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem i;

	DrawMenuBackground(C);
	Count=0;
	i=UWindowComboListItem(Items.Next);
JL002B:
	if ( i != None )
	{
		if ( VertSB.bWindowVisible )
		{
			if ( Count >= VertSB.pos )
			{
				DrawItem(C,i,HBorder,VBorder + ItemHeight * (Count - VertSB.pos),WinWidth - 2 * HBorder - VertSB.WinWidth,ItemHeight);
			}
		}
		else
		{
			DrawItem(C,i,HBorder,VBorder + ItemHeight * Count,WinWidth - 2 * HBorder,ItemHeight);
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL002B;
	}
}

function DrawMenuBackground (Canvas C)
{
	DrawClippedTexture(C,0.00,0.00,Texture'MenuTL');
	DrawStretchedTexture(C,2.00,0.00,WinWidth - 4,2.00,Texture'MenuT');
	DrawClippedTexture(C,WinWidth - 2,0.00,Texture'MenuTR');
	DrawClippedTexture(C,0.00,WinHeight - 2,Texture'MenuBL');
	DrawStretchedTexture(C,2.00,WinHeight - 2,WinWidth - 4,2.00,Texture'MenuB');
	DrawClippedTexture(C,WinWidth - 2,WinHeight - 2,Texture'MenuBR');
	DrawStretchedTexture(C,0.00,2.00,2.00,WinHeight - 4,Texture'MenuL');
	DrawStretchedTexture(C,WinWidth - 2,2.00,2.00,WinHeight - 4,Texture'MenuR');
	DrawStretchedTexture(C,2.00,2.00,WinWidth - 4,WinHeight - 4,Texture'MenuArea');
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local string Text;
	local string Underline;

	UWindowComboListItem(Item).ItemTop=Y + WinTop;
	if ( Selected == Item )
	{
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
		DrawStretchedTexture(C,X,Y,W,H,Texture'MenuHighlight');
	}
	else
	{
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
	}
	C.Font=Root.Fonts[0];
	ParseAmpersand(UWindowComboListItem(Item).Value,Text,Underline,True);
	ClipText(C,X + TextBorder + 2,Y + 3,Text);
	ClipText(C,X + TextBorder + 2,Y + 5,Underline);
}

function ExecuteItem (UWindowComboListItem i)
{
	Owner.SetValue(i.Value,i.Value2);
	CloseUp();
}

function CloseUp ()
{
	Owner.CloseUp();
}

function FocusOtherWindow (UWindowWindow W)
{
	Super.FocusOtherWindow(W);
	if ( bWindowVisible && (W.ParentWindow.ParentWindow != self) && (W.ParentWindow != self) && (W.ParentWindow != Owner) )
	{
		CloseUp();
	}
}

defaultproperties
{
    MaxVisible=10
}