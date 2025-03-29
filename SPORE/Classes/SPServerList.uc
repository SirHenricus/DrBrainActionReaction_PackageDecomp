//================================================================================
// SPServerList.
//================================================================================
class SPServerList expands UBrowserServerList;

var SPServerListMenu MenuOwner;

function PlayerPawn GetPlayerOwner ()
{
	return SPServerList(Sentinel).MenuOwner.PlayerOwner;
}

function QueryFinished (UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
	MenuOwner.QueryFinished(Fact,bSuccess,ErrorMsg);
}

function bool Compare (UWindowList t, UWindowList B)
{
}

function ConsiderForSubsets ()
{
}

function PingDone (bool bInitial, bool bJustThisServer, bool bSuccess, bool bNoSort)
{
	local UBrowserServerListWindow W;
	local UBrowserServerList OldSentinel;

	if ( ServerPing != None )
	{
		ServerPing.Destroy();
	}
	ServerPing=None;
	bPinging=False;
	bPingFailed= !bSuccess;
	bPinged=True;
	if (  !bNoSort )
	{
		OldSentinel=UBrowserServerList(Sentinel);
		if ( bPingFailed )
		{
			Remove();
		}
		else
		{
			OldSentinel.MoveItemSorted(self);
		}
	}
	if ( Sentinel != None )
	{
		UBrowserServerList(Sentinel).bNeedUpdateCount=True;
		if ( bInitial )
		{
			ConsiderForSubsets();
		}
	}
	if (  !bJustThisServer )
	{
		if ( OldSentinel != None )
		{
			OldSentinel.PingNext(bInitial);
		}
	}
}