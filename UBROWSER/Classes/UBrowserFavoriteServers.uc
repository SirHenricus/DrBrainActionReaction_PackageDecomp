//================================================================================
// UBrowserFavoriteServers.
//================================================================================
class UBrowserFavoriteServers expands UBrowserServerListWindow;

function Created ()
{
	Super.Created();
	Refresh();
}

function AddFavorite (UBrowserServerList Server)
{
	local UBrowserServerList NewItem;

	if ( List.FindExistingServer(Server.IP,Server.QueryPort) == None )
	{
		NewItem=UBrowserServerList(List.CopyExistingListItem(Class'UBrowserServerList',Server));
	}
	List.Sort();
	UBrowserFavoritesFact(Factories[0]).SaveFavorites();
}

function RemoveFavorite (UBrowserServerList Item)
{
	Item.Remove();
	UBrowserFavoritesFact(Factories[0]).SaveFavorites();
}

defaultproperties
{
    ListFactories="UBrowser.UBrowserFavoritesFact"
}