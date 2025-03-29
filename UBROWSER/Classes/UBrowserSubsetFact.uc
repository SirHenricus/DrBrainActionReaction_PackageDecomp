//================================================================================
// UBrowserSubsetFact.
//================================================================================
class UBrowserSubsetFact expands UBrowserServerListFactory;

var() config string GameMode;
var() config string GameType;
var() config float Ping;
var() config string SupersetTag;
var() config bool bLocalServersOnly;
var() config bool bCompatibleServersOnly;
var() config int MinPlayers;
var localized string NotFoundError;
var localized string NotReadyError;
var UBrowserServerListWindow SupersetWindow;

function Query (optional bool bBySuperset, optional bool bInitial)
{
	local UBrowserMainClientWindow W;
	local int i;
	local UBrowserServerList L;
	local UBrowserServerList List;

	W=UBrowserMainClientWindow(Owner.Owner.GetParent(Class'UBrowserMainClientWindow'));
	i=0;
JL002F:
	if ( i < 20 )
	{
		if ( W.ServerListTags[i] == SupersetTag )
		{
			SupersetWindow=W.FactoryWindows[i];
			List=W.FactoryWindows[i].List;
		}
		else
		{
			i++;
			goto JL002F;
		}
	}
	if ( SupersetWindow != None )
	{
		SupersetWindow.AddSubset(self);
		UBrowserServerListWindow(Owner.Owner).AddSuperSet(SupersetWindow);
	}
	else
	{
		QueryFinished(False,NotFoundError $ SupersetTag);
	}
	if ( List == None )
	{
		QueryFinished(False,NotReadyError $ SupersetTag);
	}
	else
	{
		if (  !bBySuperset &&  !bInitial )
		{
			UBrowserServerListWindow(List.Owner).Refresh();
			return;
		}
		L=UBrowserServerList(List.Next);
JL0167:
		if ( L != None )
		{
			ConsiderItem(L);
			L=UBrowserServerList(L.Next);
			goto JL0167;
		}
		QueryFinished(True);
	}
	Super.Query();
}

function Shutdown (optional bool bBySuperset)
{
	Super.Shutdown(bBySuperset);
	SupersetWindow.RemoveSubset(self);
}

function ConsiderItem (UBrowserServerList L)
{
	local UBrowserServerList NewItem;

	if (  !L.bPinged )
	{
		return;
	}
	if ( bLocalServersOnly &&  !L.bLocalServer )
	{
		return;
	}
	if ( bCompatibleServersOnly && (int(Owner.Owner.GetPlayerOwner().Level.MinNetVersion) > L.GameVer) )
	{
		return;
	}
	if ( (GameMode != "") && (GameMode != L.GameMode) )
	{
		return;
	}
	if ( (GameType != "") && (GameType != L.GameType) )
	{
		return;
	}
	if ( Owner.FindExistingServer(L.IP,L.QueryPort) != None )
	{
		return;
	}
	if ( (MinPlayers != 0) && (L.NumPlayers < MinPlayers) )
	{
		return;
	}
	NewItem=UBrowserServerList(Owner.CopyExistingListItem(Class'UBrowserServerList',L));
	Owner.MoveItemSorted(NewItem);
	Owner.bNeedUpdateCount=True;
}

function QueryFinished (bool bSuccess, optional string ErrorMsg)
{
	Super.QueryFinished(bSuccess,ErrorMsg);
}

defaultproperties
{
    Ping=9999.00
    SupersetTag="All"
    NotFoundError="Could not find the window: "
    NotReadyError="Window is not ready: "
}