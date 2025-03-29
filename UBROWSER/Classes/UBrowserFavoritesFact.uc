//================================================================================
// UBrowserFavoritesFact.
//================================================================================
class UBrowserFavoritesFact expands UBrowserServerListFactory;

var config int FavoriteCount;
var config string FavoriteNames[50];
var config string FavoriteIPs[50];
var config int FavoritePorts[50];

function Query (optional bool bBySuperset, optional bool bInitial)
{
	local int i;

	i=0;
JL0007:
	if ( i < FavoriteCount )
	{
		FoundServer(FavoriteIPs[i],FavoritePorts[i],"","Unreal",FavoriteNames[i]);
		i++;
		goto JL0007;
	}
	Super.Query();
	QueryFinished(True);
}

function SaveFavorites ()
{
	local UBrowserServerList i;

	FavoriteCount=0;
	i=UBrowserServerList(Owner.Next);
JL0020:
	if ( i != None )
	{
		FavoriteIPs[FavoriteCount]=i.IP;
		FavoritePorts[FavoriteCount]=i.QueryPort;
		FavoriteNames[FavoriteCount]=i.HostName;
		FavoriteCount++;
		i=UBrowserServerList(i.Next);
		goto JL0020;
	}
	if ( FavoriteCount < 50 )
	{
		FavoriteIPs[FavoriteCount]="";
		FavoritePorts[FavoriteCount]=0;
		FavoriteNames[FavoriteCount]="";
	}
	SaveConfig();
}