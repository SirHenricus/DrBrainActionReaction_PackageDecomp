//================================================================================
// UWindowMenuBarItem.
//================================================================================
class UWindowMenuBarItem expands UWindowList;

var string Caption;
var UWindowMenuBar Owner;
var UWindowPulldownMenu Menu;
var float ItemLeft;
var float ItemWidth;
var bool bHelp;
var byte HotKey;

function SetHelp (bool B)
{
	bHelp=B;
}

function SetCaption (string C)
{
	local string Junk;
	local string Junk2;

	Caption=C;
	HotKey=Owner.ParseAmpersand(C,Junk,Junk2,False);
}

function UWindowPulldownMenu CreateMenu (Class<UWindowPulldownMenu> MenuClass)
{
	Menu=UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass,0.00,0.00,100.00,100.00));
	Menu.HideWindow();
	Menu.Owner=self;
	return Menu;
}

function DeSelect ()
{
	Menu.DeSelect();
	Menu.HideWindow();
}

function Select ()
{
	Menu.ShowWindow();
	Menu.WinLeft=ItemLeft + Owner.WinLeft;
	Menu.WinTop=14.00;
	Menu.WinWidth=100.00;
	Menu.WinHeight=100.00;
}

function CloseUp ()
{
	Owner.CloseUp();
}

function UWindowMenuBar GetMenuBar ()
{
	return Owner.GetMenuBar();
}