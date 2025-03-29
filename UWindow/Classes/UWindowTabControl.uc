//================================================================================
// UWindowTabControl.
//================================================================================
class UWindowTabControl expands UWindowListControl;

var UWindowTabControlLeftButton LeftButton;
var UWindowTabControlRightButton RightButton;
var UWindowTabControlTabArea TabArea;
var UWindowTabControlItem SelectedTab;

function Created ()
{
	Super.Created();
	SelectedTab=None;
	TabArea=UWindowTabControlTabArea(CreateWindow(Class'UWindowTabControlTabArea',0.00,0.00,WinWidth - LookAndFeel.Size_ScrollbarWidth - LookAndFeel.Size_ScrollbarWidth - 10,LookAndFeel.Size_TabAreaHeight + LookAndFeel.Size_TabAreaOverhangHeight));
	TabArea.bAlwaysOnTop=True;
	LeftButton=UWindowTabControlLeftButton(CreateWindow(Class'UWindowTabControlLeftButton',WinWidth - 20,0.00,10.00,12.00));
	RightButton=UWindowTabControlRightButton(CreateWindow(Class'UWindowTabControlRightButton',WinWidth - 10,0.00,10.00,12.00));
}

function BeforePaint (Canvas C, float X, float Y)
{
	WinHeight=LookAndFeel.Size_TabAreaHeight + LookAndFeel.Size_TabAreaOverhangHeight;
	TabArea.WinTop=0.00;
	TabArea.WinLeft=0.00;
	TabArea.WinWidth=WinWidth - LookAndFeel.Size_ScrollbarWidth - LookAndFeel.Size_ScrollbarWidth - 10;
	TabArea.WinHeight=WinHeight;
	Super.BeforePaint(C,X,Y);
}

function Paint (Canvas C, float X, float Y)
{
	local Region R;
	local Texture t;

	t=GetLookAndFeelTexture();
	R=LookAndFeel.TabBackground;
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,LookAndFeel.TabUnselectedM.H,R.X,R.Y,R.W,R.H,t);
}

function UWindowTabControlItem AddTab (string Caption)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(Items.Append(ListClass));
	i.Owner=self;
	i.SetCaption(Caption);
	if ( SelectedTab == None )
	{
		SelectedTab=i;
	}
	return i;
}

function UWindowTabControlItem InsertTab (UWindowTabControlItem BeforeTab, string Caption)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(BeforeTab.InsertBefore(ListClass));
	i.Owner=self;
	i.SetCaption(Caption);
	if ( SelectedTab == None )
	{
		SelectedTab=i;
	}
	return i;
}

function GotoTab (UWindowTabControlItem NewSelected)
{
	SelectedTab=NewSelected;
	TabArea.bShowSelected=True;
}

function UWindowTabControlItem GetTab (string Caption)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Caption == Caption )
		{
			return i;
		}
		i=UWindowTabControlItem(i.Next);
		goto JL0019;
	}
	return None;
}

function DeleteTab (UWindowTabControlItem Tab)
{
	Tab.Remove();
	if ( SelectedTab == Tab )
	{
		GotoTab(UWindowTabControlItem(Items.Next));
	}
}

defaultproperties
{
    ListClass=Class'UWindowTabControlItem'
}