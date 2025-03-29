//================================================================================
// UWindowPulldownMenu.
//================================================================================
class UWindowPulldownMenu expands UWindowListControl;

var UWindowPulldownMenuItem Selected;
var UWindowList Owner;
var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;

function UWindowPulldownMenuItem AddMenuItem (string C, Texture G)
{
	local UWindowPulldownMenuItem i;

	i=UWindowPulldownMenuItem(Items.Append(Class'UWindowPulldownMenuItem'));
	i.Owner=self;
	i.SetCaption(C);
	i.Graphic=G;
	return i;
}

function Created ()
{
	ListClass=Class'UWindowPulldownMenuItem';
	SetAcceptsFocus();
	Super.Created();
	ItemHeight=15;
	VBorder=3;
	HBorder=3;
	TextBorder=9;
}

function DeSelect ()
{
	if ( Selected != None )
	{
		Selected.DeSelect();
		Selected=None;
	}
}

function Select (UWindowPulldownMenuItem i)
{
}

function PerformSelect (UWindowPulldownMenuItem NewSelected)
{
	if ( (Selected != None) && (NewSelected != Selected) )
	{
		Selected.DeSelect();
	}
	if ( NewSelected == None )
	{
		Selected=None;
	}
	else
	{
		Selected=NewSelected;
		if ( Selected != None )
		{
			Selected.Select();
			Select(Selected);
		}
	}
}

function SetSelected (float X, float Y)
{
	local UWindowPulldownMenuItem NewSelected;

	NewSelected=UWindowPulldownMenuItem(Items.FindEntry((Y - VBorder) / ItemHeight));
	PerformSelect(NewSelected);
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	SetSelected(X,Y);
	FocusWindow();
}

function LMouseUp (float X, float Y)
{
	if ( (Selected != None) && (Selected.Caption != "-") &&  !Selected.bDisabled )
	{
		ExecuteItem(Selected);
	}
	Super.LMouseUp(X,Y);
}

function LMouseDown (float X, float Y)
{
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float MaxWidth;
	local int Count;
	local UWindowPulldownMenuItem i;

	MaxWidth=100.00;
	Count=0;
	C.Font=Root.Fonts[0];
	C.SetPos(0.00,0.00);
	i=UWindowPulldownMenuItem(Items.Next);
JL0063:
	if ( i != None )
	{
		Count++;
		TextSize(C,RemoveAmpersand(i.Caption),W,H);
		if ( W > MaxWidth )
		{
			MaxWidth=W;
		}
		i=UWindowPulldownMenuItem(i.Next);
		goto JL0063;
	}
	WinWidth=MaxWidth + (HBorder + TextBorder) * 2;
	WinHeight=ItemHeight * Count + VBorder * 2;
	if ( (UWindowMenuBarItem(Owner) != None) && UWindowMenuBarItem(Owner).bHelp )
	{
		WinLeft=ParentWindow.WinWidth - WinWidth;
	}
	if ( UWindowPulldownMenuItem(Owner) != None )
	{
		i=UWindowPulldownMenuItem(Owner);
		if ( WinWidth + WinLeft > ParentWindow.WinWidth )
		{
			WinLeft=i.Owner.WinLeft + i.Owner.HBorder - WinWidth;
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local int Count;
	local UWindowPulldownMenuItem i;

	DrawMenuBackground(C);
	Count=0;
	i=UWindowPulldownMenuItem(Items.Next);
JL002B:
	if ( i != None )
	{
		DrawItem(C,i,HBorder,VBorder + ItemHeight * Count,WinWidth - 2 * HBorder,ItemHeight);
		Count++;
		i=UWindowPulldownMenuItem(i.Next);
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
	UWindowPulldownMenuItem(Item).ItemTop=Y + WinTop;
	if ( UWindowPulldownMenuItem(Item).Caption == "-" )
	{
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
		DrawStretchedTexture(C,X,Y + 5,W,2.00,Texture'MenuDivider');
		return;
	}
	if ( Selected == Item )
	{
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
		DrawStretchedTexture(C,X,Y,W,H,Texture'MenuHighlight');
		if ( UWindowPulldownMenuItem(Item).bDisabled )
		{
			C.DrawColor.R=96;
			C.DrawColor.G=96;
			C.DrawColor.B=96;
		}
	}
	else
	{
		if ( UWindowPulldownMenuItem(Item).bDisabled )
		{
			C.DrawColor.R=96;
			C.DrawColor.G=96;
			C.DrawColor.B=96;
		}
		else
		{
			C.DrawColor.R=0;
			C.DrawColor.G=0;
			C.DrawColor.B=0;
		}
	}
	if ( UWindowPulldownMenuItem(Item).bChecked )
	{
		C.Style=GetPlayerOwner().2;
		DrawClippedTexture(C,X + 1,Y + 3,Texture'MenuTick');
		C.Style=GetPlayerOwner().1;
	}
	if ( UWindowPulldownMenuItem(Item).SubMenu != None )
	{
		C.Style=GetPlayerOwner().2;
		DrawClippedTexture(C,X + W - 9,Y + 3,Texture'MenuSubArrow');
		C.Style=GetPlayerOwner().1;
	}
	C.Font=Root.Fonts[0];
	ClipText(C,X + TextBorder + 2,Y + 3,UWindowPulldownMenuItem(Item).Caption,True);
}

function ExecuteItem (UWindowPulldownMenuItem i)
{
	CloseUp();
}

function CloseUp ()
{
	if ( UWindowPulldownMenuItem(Owner) != None )
	{
		UWindowPulldownMenuItem(Owner).CloseUp();
	}
	if ( UWindowMenuBarItem(Owner) != None )
	{
		UWindowMenuBarItem(Owner).CloseUp();
	}
}

function UWindowMenuBar GetMenuBar ()
{
	if ( UWindowPulldownMenuItem(Owner) != None )
	{
		return UWindowPulldownMenuItem(Owner).GetMenuBar();
	}
	if ( UWindowMenuBarItem(Owner) != None )
	{
		return UWindowMenuBarItem(Owner).GetMenuBar();
	}
}

function FocusOtherWindow (UWindowWindow W)
{
	Super.FocusOtherWindow(W);
	if ( Selected != None )
	{
		if ( W == Selected.SubMenu )
		{
			return;
		}
	}
	if ( UWindowPulldownMenuItem(Owner) != None )
	{
		if ( UWindowPulldownMenuItem(Owner).Owner == W )
		{
			return;
		}
	}
	if ( bWindowVisible )
	{
		CloseUp();
	}
}

function KeyDown (int Key, float X, float Y)
{
	local UWindowPulldownMenuItem i;

	i=Selected;
	switch (Key)
	{
		case 38:
		if ( (i == None) || (i == Items.Next) )
		{
			i=UWindowPulldownMenuItem(Items.Last);
		}
		else
		{
			i=UWindowPulldownMenuItem(i.Prev);
		}
		if ( i == None )
		{
			i=UWindowPulldownMenuItem(Items.Last);
		}
		else
		{
			if ( i.Caption == "-" )
			{
				i=UWindowPulldownMenuItem(i.Prev);
			}
		}
		if ( i == None )
		{
			i=UWindowPulldownMenuItem(Items.Last);
		}
		if ( i.SubMenu == None )
		{
			PerformSelect(i);
		}
		else
		{
			Selected=i;
		}
		break;
		case 40:
		if ( i == None )
		{
			i=UWindowPulldownMenuItem(Items.Next);
		}
		else
		{
			i=UWindowPulldownMenuItem(i.Next);
		}
		if ( i == None )
		{
			i=UWindowPulldownMenuItem(Items.Next);
		}
		else
		{
			if ( i.Caption == "-" )
			{
				i=UWindowPulldownMenuItem(i.Next);
			}
		}
		if ( i == None )
		{
			i=UWindowPulldownMenuItem(Items.Next);
		}
		if ( i.SubMenu == None )
		{
			PerformSelect(i);
		}
		else
		{
			Selected=i;
		}
		break;
		case 37:
		if ( UWindowPulldownMenuItem(Owner) != None )
		{
			UWindowPulldownMenuItem(Owner).Owner.PerformSelect(None);
			UWindowPulldownMenuItem(Owner).Owner.Selected=UWindowPulldownMenuItem(Owner);
		}
		if ( UWindowMenuBarItem(Owner) != None )
		{
			UWindowMenuBarItem(Owner).Owner.KeyDown(Key,X,Y);
		}
		break;
		case 39:
		if ( (i != None) && (i.SubMenu != None) )
		{
			Selected=None;
			PerformSelect(i);
			i.SubMenu.Selected=UWindowPulldownMenuItem(i.SubMenu.Items.Next);
		}
		else
		{
			if ( UWindowPulldownMenuItem(Owner) != None )
			{
				UWindowPulldownMenuItem(Owner).Owner.PerformSelect(None);
				UWindowPulldownMenuItem(Owner).Owner.KeyDown(Key,X,Y);
			}
			if ( UWindowMenuBarItem(Owner) != None )
			{
				UWindowMenuBarItem(Owner).Owner.KeyDown(Key,X,Y);
			}
		}
		break;
		case 13:
		if ( i.SubMenu != None )
		{
			Selected=None;
			PerformSelect(i);
		}
		else
		{
			if ( (Selected != None) && (Selected.Caption != "-") &&  !Selected.bDisabled )
			{
				ExecuteItem(Selected);
			}
		}
		break;
		default:
	}
}

function KeyUp (int Key, float X, float Y)
{
	local UWindowPulldownMenuItem i;

	if ( (Key >= 65) && (Key <= 96) )
	{
		i=UWindowPulldownMenuItem(Items.Next);
JL0033:
		if ( i != None )
		{
			if ( Key == i.HotKey )
			{
				PerformSelect(i);
				if ( (i != None) && (i.Caption != "-") &&  !i.bDisabled )
				{
					ExecuteItem(i);
				}
			}
			i=UWindowPulldownMenuItem(i.Next);
			goto JL0033;
		}
	}
}

defaultproperties
{
    bAlwaysOnTop=True
}