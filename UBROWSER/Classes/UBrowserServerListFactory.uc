//================================================================================
// UBrowserServerListFactory.
//================================================================================
class UBrowserServerListFactory expands UWindowList
	abstract;

var UBrowserServerList Owner;

function Query (optional bool bBySuperset, optional bool bInitial)
{
}

function Shutdown (optional bool bBySuperset)
{
	Owner=None;
}

function QueryFinished (bool bSuccess, optional string ErrorMsg)
{
	Owner.QueryFinished(self,bSuccess,ErrorMsg);
}

function UBrowserServerList FoundServer (string IP, int QueryPort, string Category, string GameName, optional string HostName)
{
	local UBrowserServerList NewListEntry;

	NewListEntry=Owner.FindExistingServer(IP,QueryPort);
	if ( NewListEntry == None )
	{
		NewListEntry=UBrowserServerList(Owner.Append(Owner.Class));
		NewListEntry.IP=IP;
		NewListEntry.QueryPort=QueryPort;
		NewListEntry.Ping=9999.00;
		if ( HostName != "" )
		{
			NewListEntry.HostName=HostName;
		}
		else
		{
			NewListEntry.HostName=IP;
		}
		NewListEntry.Category=Category;
		NewListEntry.GameName=GameName;
		NewListEntry.bLocalServer=False;
	}
	return NewListEntry;
}

function PlayerPawn GetPlayerOwner ()
{
	return Owner.GetPlayerOwner();
}