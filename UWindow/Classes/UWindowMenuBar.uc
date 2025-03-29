//================================================================================
// UWindowMenuBar.
//================================================================================
class UWindowMenuBar expands UWindowListControl;

var UWindowMenuBarItem Selected;
var UWindowMenuBarItem Over;
var bool bAltDown;
var int Spacing;

function Created ()
{
	ListClass=Class'UWindowMenuBarItem';
	SetAcceptsHotKeys(True);
	Super.Created();
	Spacing=10;
}

function UWindowMenuBarItem AddHelpItem (string Caption)
{
	local UWindowMenuBarItem i;

	i=AddItem(Caption);
	i.SetHelp(True);
	return i;
}

function UWindowMenuBarItem AddItem (string Caption)
{
	local UWindowMenuBarItem i;

	i=UWindowMenuBarItem(Items.Append(Class'UWindowMenuBarItem'));
	i.Owner=self;
	i.SetCaption(Caption);
	return i;
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float W;
	local float H;
	local UWindowMenuBarItem i;

	DrawMenuBar(C);
	i=UWindowMenuBarItem(Items.Next);
JL0024:
	if ( i != None )
	{
		C.Font=Root.Fonts[0];
		TextSize(C,RemoveAmpersand(i.Caption),W,H);
		if ( i.bHelp )
		{
			DrawItem(C,i,WinWidth - W + Spacing,1.00,W + Spacing,14.00);
		}
		else
		{
			DrawItem(C,i,X,1.00,W + Spacing,14.00);
			X=X + W + Spacing;
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0024;
	}
}

function MouseMove (float X, float Y)
{
	local UWindowMenuBarItem i;

	Super.MouseMove(X,Y);
	Over=None;
	i=UWindowMenuBarItem(Items.Next);
JL0030:
	if ( i != None )
	{
		if ( (X >= i.ItemLeft) && (X <= i.ItemLeft + i.ItemWidth) )
		{
			if ( Selected != None )
			{
				if ( Selected != i )
				{
					Selected.DeSelect();
					Selected=i;
					Selected.Select();
					Select(Selected);
				}
			}
			else
			{
				Over=i;
			}
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0030;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	Over=None;
}

function Select (UWindowMenuBarItem i)
{
}

function LMouseDown (float X, float Y)
{
	local UWindowMenuBarItem i;

	i=UWindowMenuBarItem(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( (X >= i.ItemLeft) && (X <= i.ItemLeft + i.ItemWidth) )
		{
			if ( Selected != None )
			{
				Selected.DeSelect();
			}
			if ( Selected == i )
			{
				Selected=None;
				Over=i;
			}
			else
			{
				Selected=i;
				Selected.Select();
			}
			Select(Selected);
			return;
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0019;
	}
	if ( Selected != None )
	{
		Selected.DeSelect();
	}
	Selected=None;
	Select(Selected);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local string Text;
	local string Underline;

	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	UWindowMenuBarItem(Item).ItemLeft=X;
	UWindowMenuBarItem(Item).ItemWidth=W;
	if ( Selected == Item )
	{
		DrawClippedTexture(C,X,1.00,Texture'MenuHighlightL');
		DrawClippedTexture(C,X + W - 1,1.00,Texture'MenuHighlightR');
		DrawStretchedTexture(C,X + 1,1.00,W - 2,16.00,Texture'MenuHighlightM');
	}
	C.Font=Root.Fonts[0];
	C.DrawColor.R=0;
	C.DrawColor.G=0;
	C.DrawColor.B=0;
	ClipText(C,X + Spacing / 2,2.00,UWindowMenuBarItem(Item).Caption,True);
}

function DrawMenuBar (Canvas C)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,16.00,Texture'MenuBar');
}

function CloseUp ()
{
	if ( Selected != None )
	{
		Selected.DeSelect();
		Selected=None;
	}
}

function Close (optional bool bByParent)
{
	Root.Console.CloseUWindow();
}

function UWindowMenuBar GetMenuBar ()
{
	return self;
}

function bool HotKeyDown (int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	if ( Key == 18 )
	{
		bAltDown=True;
	}
	if ( bAltDown )
	{
		i=UWindowMenuBarItem(Items.Next);
JL0036:
		if ( i != None )
		{
			if ( Key == i.HotKey )
			{
				if ( Selected != None )
				{
					Selected.DeSelect();
				}
				Selected=i;
				Selected.Select();
				Select(Selected);
				return True;
			}
			i=UWindowMenuBarItem(i.Next);
			goto JL0036;
		}
	}
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	if ( Key == 18 )
	{
		bAltDown=False;
	}
	return False;
}

function KeyDown (int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	switch (Key)
	{
		case 37:
		i=UWindowMenuBarItem(Selected.Prev);
		if ( (i == None) || (i == Items) )
		{
			i=UWindowMenuBarItem(Items.Last);
		}
		if ( Selected != None )
		{
			Selected.DeSelect();
		}
		Selected=i;
		Selected.Select();
		Select(Selected);
		break;
		case 39:
		i=UWindowMenuBarItem(Selected.Next);
		if ( i == None )
		{
			i=UWindowMenuBarItem(Items.Next);
		}
		if ( Selected != None )
		{
			Selected.DeSelect();
		}
		Selected=i;
		Selected.Select();
		Select(Selected);
		break;
		default:
	}
}