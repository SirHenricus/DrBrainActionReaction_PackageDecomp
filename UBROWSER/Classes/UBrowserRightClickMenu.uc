//================================================================================
// UBrowserRightClickMenu.
//================================================================================
class UBrowserRightClickMenu expands UWindowPulldownMenu;

var UWindowPulldownMenuItem Refresh;
var UWindowPulldownMenuItem Info;
var UWindowPulldownMenuItem Favorites;
var localized string RefreshName;
var localized string InfoName;
var localized string FavoritesName;
var localized string RemoveFavoritesName;
var UBrowserServerGrid Grid;
var UBrowserServerList List;

function Created ()
{
	bTransient=True;
	Super.Created();
	Info=AddMenuItem(InfoName,None);
	Favorites=AddMenuItem(FavoritesName,None);
	AddMenuItem("-",None);
	Refresh=AddMenuItem(RefreshName,None);
}

function ExecuteItem (UWindowPulldownMenuItem i)
{
	switch (i)
	{
		case Info:
		if (  !Info.bDisabled )
		{
			Grid.ShowInfo(List);
		}
		break;
		case Favorites:
		if ( UBrowserFavoriteServers(UBrowserServerList(List.Sentinel).Owner) != None )
		{
			UBrowserFavoriteServers(UBrowserServerList(List.Sentinel).Owner).RemoveFavorite(List);
		}
		else
		{
			UBrowserServerListWindow(Grid.GetParent(Class'UBrowserServerListWindow')).AddFavorite(List);
		}
		break;
		case Refresh:
		Grid.Refresh();
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

function ShowWindow ()
{
	Info.bDisabled=(List == None) || (List.GamePort == 0);
	if ( (List != None) && (UBrowserFavoriteServers(UBrowserServerList(List.Sentinel).Owner) != None) )
	{
		Favorites.SetCaption(RemoveFavoritesName);
	}
	else
	{
		Favorites.SetCaption(FavoritesName);
	}
	Favorites.bDisabled=List == None;
	Selected=None;
	Super.ShowWindow();
}

function CloseUp ()
{
	HideWindow();
}

defaultproperties
{
    RefreshName="&Refresh Servers"
    InfoName="&Info"
    FavoritesName="Add to &Favorites"
    RemoveFavoritesName="Remove from &Favorites"
}