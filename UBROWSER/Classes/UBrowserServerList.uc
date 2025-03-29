//================================================================================
// UBrowserServerList.
//================================================================================
class UBrowserServerList expands UWindowList;

var UWindowWindow Owner;
var int TotalServers;
var int TotalPlayers;
var int TotalMaxPlayers;
var bool bNeedUpdateCount;
var config int MaxSimultaneousPing;
var string IP;
var int QueryPort;
var string Category;
var string GameName;
var UBrowserServerPing ServerPing;
var bool bPinging;
var bool bPingFailed;
var bool bPinged;
var bool bNoInitalPing;
var UBrowserRulesList RulesList;
var UBrowserPlayerList PlayerList;
var bool bLocalServer;
var float Ping;
var string HostName;
var int GamePort;
var string MapName;
var string GameType;
var string GameMode;
var int NumPlayers;
var int MaxPlayers;
var int GameVer;
var int MinGameVer;

function DestroyListItem ()
{
	Owner=None;
	if ( ServerPing != None )
	{
		ServerPing.Destroy();
		ServerPing=None;
	}
	Super.DestroyListItem();
}

function QueryFinished (UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
	UBrowserServerListWindow(Owner).QueryFinished(Fact,bSuccess,ErrorMsg);
}

function PingServer (bool bInitial, bool bJustThisServer, bool bNoSort)
{
	ServerPing=GetPlayerOwner().GetEntryLevel().Spawn(Class'UBrowserServerPing');
	ServerPing.Server=self;
	ServerPing.StartQuery('GetInfo',2);
	ServerPing.bInitial=bInitial;
	ServerPing.bJustThisServer=bJustThisServer;
	ServerPing.bNoSort=bNoSort;
	bPinging=True;
}

function ServerStatus ()
{
	ServerPing=GetPlayerOwner().GetEntryLevel().Spawn(Class'UBrowserServerPing');
	ServerPing.Server=self;
	ServerPing.StartQuery('GetStatus',2);
}

function StatusDone (bool bSuccess)
{
	ServerPing.Destroy();
	ServerPing=None;
	RulesList.SortByColumn(RulesList.SortColumn);
	PlayerList.SortByColumn(PlayerList.SortColumn);
}

function CancelPing ()
{
	if ( bPinging && (ServerPing != None) && ServerPing.bJustThisServer )
	{
		PingDone(False,True,False,True);
	}
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
			W=UBrowserServerListWindow(OldSentinel.Owner);
			if ( W.bPingSuspend )
			{
				W.bPingResume=True;
				W.bPingResumeIntial=bInitial;
			}
			else
			{
				OldSentinel.PingNext(bInitial);
			}
		}
	}
}

function ConsiderForSubsets ()
{
	local UBrowserSubsetList L;

	L=UBrowserSubsetList(UBrowserServerListWindow(UBrowserServerList(Sentinel).Owner).SubsetList.Next);
JL0035:
	if ( L != None )
	{
		L.SubsetFactory.ConsiderItem(self);
		L=UBrowserSubsetList(L.Next);
		goto JL0035;
	}
}

function PingServers (bool bInitial)
{
	local UBrowserServerList L;

	bPinging=False;
	L=UBrowserServerList(Next);
JL0018:
	if ( L != None )
	{
		L.bPinging=False;
		L.bPingFailed=False;
		L.bPinged=False;
		L=UBrowserServerList(L.Next);
		goto JL0018;
	}
	PingNext(bInitial);
}

function PingNext (bool bInitial)
{
	local int TotalPinging;
	local UBrowserServerList L;
	local bool bDone;

	TotalPinging=0;
	bDone=True;
	L=UBrowserServerList(Next);
JL001F:
	if ( L != None )
	{
		if (  !L.bPinged )
		{
			bDone=False;
		}
		if ( L.bPinging )
		{
			TotalPinging++;
		}
		L=UBrowserServerList(L.Next);
		goto JL001F;
	}
	if ( bDone )
	{
		bPinging=False;
	}
	else
	{
		if ( TotalPinging < MaxSimultaneousPing )
		{
			L=UBrowserServerList(Next);
JL00AE:
			if ( L != None )
			{
				if (  !L.bPinging &&  !L.bPinged && ( !bInitial ||  !L.bNoInitalPing) && (TotalPinging < MaxSimultaneousPing) )
				{
					TotalPinging++;
					L.PingServer(bInitial,False,True);
				}
				L=UBrowserServerList(L.Next);
				goto JL00AE;
			}
		}
	}
}

function UBrowserServerList FindExistingServer (string FindIP, int FindQueryPort)
{
	local UWindowList L;

	L=Next;
JL000B:
	if ( L != None )
	{
		if ( (UBrowserServerList(L).IP == FindIP) && (UBrowserServerList(L).QueryPort == FindQueryPort) )
		{
			return UBrowserServerList(L);
		}
		L=L.Next;
		goto JL000B;
	}
	return None;
}

function PlayerPawn GetPlayerOwner ()
{
	return UBrowserServerList(Sentinel).Owner.GetPlayerOwner();
}

function UWindowList CopyExistingListItem (Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	local UBrowserServerList L;

	L=UBrowserServerList(Super.CopyExistingListItem(ItemClass,SourceItem));
	L.bLocalServer=UBrowserServerList(SourceItem).bLocalServer;
	L.IP=UBrowserServerList(SourceItem).IP;
	L.QueryPort=UBrowserServerList(SourceItem).QueryPort;
	L.Ping=UBrowserServerList(SourceItem).Ping;
	L.HostName=UBrowserServerList(SourceItem).HostName;
	L.GamePort=UBrowserServerList(SourceItem).GamePort;
	L.MapName=UBrowserServerList(SourceItem).MapName;
	L.GameType=UBrowserServerList(SourceItem).GameType;
	L.GameMode=UBrowserServerList(SourceItem).GameMode;
	L.NumPlayers=UBrowserServerList(SourceItem).NumPlayers;
	L.MaxPlayers=UBrowserServerList(SourceItem).MaxPlayers;
	L.GameVer=UBrowserServerList(SourceItem).GameVer;
	L.MinGameVer=UBrowserServerList(SourceItem).MinGameVer;
	return L;
}

function bool Compare (UWindowList t, UWindowList B)
{
	return UBrowserServerListWindow(UBrowserServerList(Sentinel).Owner).Grid.Compare(UBrowserServerList(t),UBrowserServerList(B));
}

function UWindowList Append (Class<UWindowList> C)
{
	local UWindowList L;

	L=Super.Append(C);
	UBrowserServerList(Sentinel).bNeedUpdateCount=True;
	return L;
}

function Remove ()
{
	local UBrowserServerList S;

	S=UBrowserServerList(Sentinel);
	Super.Remove();
	S.bNeedUpdateCount=True;
}

function UpdateServerCount ()
{
	local UBrowserServerList L;

	TotalServers=0;
	TotalPlayers=0;
	TotalMaxPlayers=0;
	L=UBrowserServerList(Next);
JL0025:
	if ( L != None )
	{
		TotalServers++;
		TotalPlayers += L.NumPlayers;
		TotalMaxPlayers += L.MaxPlayers;
		L=UBrowserServerList(L.Next);
		goto JL0025;
	}
}

defaultproperties
{
    MaxSimultaneousPing=10
}