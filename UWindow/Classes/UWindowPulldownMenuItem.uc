//================================================================================
// UWindowPulldownMenuItem.
//================================================================================
class UWindowPulldownMenuItem expands UWindowList;

var string Caption;
var Texture Graphic;
var byte HotKey;
var UWindowPulldownMenu SubMenu;
var bool bChecked;
var bool bDisabled;
var UWindowPulldownMenu Owner;
var float ItemTop;

function UWindowPulldownMenu CreateSubMenu (Class<UWindowPulldownMenu> MenuClass)
{
	SubMenu=UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass,0.00,0.00,100.00,100.00));
	SubMenu.HideWindow();
	SubMenu.Owner=self;
	return SubMenu;
}

function Select ()
{
	if ( (SubMenu != None) &&  !SubMenu.bWindowVisible )
	{
		SubMenu.WinLeft=Owner.WinLeft + Owner.WinWidth - Owner.HBorder;
		SubMenu.WinTop=ItemTop - Owner.VBorder;
		SubMenu.ShowWindow();
	}
}

function SetCaption (string C)
{
	local string Junk;
	local string Junk2;

	Caption=C;
	HotKey=Owner.ParseAmpersand(C,Junk,Junk2,False);
}

function DeSelect ()
{
	if ( SubMenu != None )
	{
		SubMenu.DeSelect();
		SubMenu.HideWindow();
	}
}

function CloseUp ()
{
	Owner.CloseUp();
}

function UWindowMenuBar GetMenuBar ()
{
	return Owner.GetMenuBar();
}