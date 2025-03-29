//================================================================================
// UBrowserInfoWindow.
//================================================================================
class UBrowserInfoWindow expands UWindowFramedWindow;

var UBrowserServerList Server;
var UBrowserInfoMenu Menu;

function BeginPlay ()
{
	Super.BeginPlay();
	ClientClass=Class'UBrowserInfoClientWindow';
}

function Created ()
{
	bSizable=True;
	bStatusBar=True;
	Menu=UBrowserInfoMenu(Root.CreateWindow(Class'UBrowserInfoMenu',0.00,0.00,100.00,100.00));
	Menu.Info=self;
	Menu.HideWindow();
	Super.Created();
	MinWinHeight=100.00;
}