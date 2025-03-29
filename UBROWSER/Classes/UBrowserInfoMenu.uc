//================================================================================
// UBrowserInfoMenu.
//================================================================================
class UBrowserInfoMenu expands UWindowPulldownMenu;

var UWindowPulldownMenuItem Refresh;
var UWindowPulldownMenuItem CloseItem;
var localized string RefreshName;
var localized string CloseName;
var UBrowserInfoWindow Info;

function Created ()
{
	bTransient=True;
	Super.Created();
	Refresh=AddMenuItem(RefreshName,None);
	AddMenuItem("-",None);
	CloseItem=AddMenuItem(CloseName,None);
}

function ExecuteItem (UWindowPulldownMenuItem i)
{
	switch (i)
	{
		case Refresh:
		Info.Server.ServerStatus();
		break;
		case CloseItem:
		Info.Close();
		break;
		default:
	}
	Super.ExecuteItem(i);
}

function RMouseDown (float X, float Y)
{
	LMouseDown(X,Y);
}

function RMouseUp (float X, float Y)
{
	LMouseUp(X,Y);
}

function CloseUp ()
{
	HideWindow();
}

defaultproperties
{
    RefreshName="&Refresh Info"
    CloseName="&Close"
}