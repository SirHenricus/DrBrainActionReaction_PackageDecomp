//================================================================================
// UWindowTabControlTabArea.
//================================================================================
class UWindowTabControlTabArea expands UWindowWindow;

var int TabOffset;
var bool bShowSelected;
var UWindowTabControlItem FirstShown;

function Created ()
{
	TabOffset=0;
	Super.Created();
}

function BeforePaint (Canvas C, float X, float Y)
{
	local UWindowTabControlItem i;
	local UWindowTabControlItem Selected;
	local UWindowTabControlItem LastHidden;
	local int Count;
	local int TabCount;
	local float ItemX;
	local float W;
	local float H;
	local bool bHaveMore;

	ItemX=LookAndFeel.Size_TabXOffset;
	TabCount=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL0042:
	if ( i != None )
	{
		LookAndFeel.Tab_GetTabSize(self,C,RemoveAmpersand(i.Caption),W,H);
		i.TabWidth=W;
		i.TabHeight=H;
		TabCount++;
		i=UWindowTabControlItem(i.Next);
		goto JL0042;
	}
	Selected=UWindowTabControl(ParentWindow).SelectedTab;
JL00E4:
	if ( True )
	{
		ItemX=LookAndFeel.Size_TabXOffset;
		Count=0;
		LastHidden=None;
		FirstShown=None;
		i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL0138:
		if ( i != None )
		{
			if ( Count < TabOffset )
			{
				i.TabLeft=-1.00;
				LastHidden=i;
			}
			else
			{
				if ( FirstShown == None )
				{
					FirstShown=i;
				}
				i.TabLeft=ItemX;
				if ( i.TabLeft + i.TabWidth >= WinWidth + 5 )
				{
					bHaveMore=True;
				}
				ItemX += i.TabWidth;
			}
			Count++;
			i=UWindowTabControlItem(i.Next);
			goto JL0138;
		}
		if ( (TabOffset > 0) && (LastHidden != None) && (LastHidden.TabWidth + 5 < WinWidth - ItemX) )
		{
			TabOffset--;
		}
		else
		{
			if ( bShowSelected && (TabOffset < TabCount - 1) && (Selected != None) && (Selected != FirstShown) && (Selected.TabLeft + Selected.TabWidth > WinWidth - 5) )
			{
				TabOffset++;
			}
			else
			{
				goto JL02CD;
			}
		}
		goto JL00E4;
	}
JL02CD:
	bShowSelected=False;
	UWindowTabControl(ParentWindow).LeftButton.bDisabled=TabOffset <= 0;
	UWindowTabControl(ParentWindow).RightButton.bDisabled= !bHaveMore;
	Super.BeforePaint(C,X,Y);
}

function Paint (Canvas C, float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL002E:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			DrawItem(C,i,i.TabLeft,0.00,i.TabWidth,i.TabHeight);
		}
		i=UWindowTabControlItem(i.Next);
		goto JL002E;
	}
}

function LMouseDown (float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	Super.LMouseDown(X,Y);
	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL003E:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			if ( (X >= i.TabLeft) && (X <= i.TabLeft + i.TabWidth) )
			{
				UWindowTabControl(ParentWindow).GotoTab(i);
			}
		}
		i=UWindowTabControlItem(i.Next);
		goto JL003E;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	if ( Item == UWindowTabControl(ParentWindow).SelectedTab )
	{
		LookAndFeel.Tab_DrawTab(self,C,True,FirstShown == Item,X,Y,W,H,UWindowTabControlItem(Item).Caption);
	}
	else
	{
		LookAndFeel.Tab_DrawTab(self,C,False,FirstShown == Item,X,Y,W,H,UWindowTabControlItem(Item).Caption);
	}
}

function bool CheckMousePassThrough (float X, float Y)
{
	return Y >= LookAndFeel.Size_TabAreaHeight;
}