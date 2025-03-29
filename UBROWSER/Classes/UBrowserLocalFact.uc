//================================================================================
// UBrowserLocalFact.
//================================================================================
class UBrowserLocalFact expands UBrowserServerListFactory;

var UBrowserLocalLink Link;
var() config string BeaconProduct;
var config int ServerBeaconPort;
var config int BeaconPort;

function Query (optional bool bBySuperset, optional bool bInitial)
{
	Link=GetPlayerOwner().GetEntryLevel().Spawn(Class'UBrowserLocalLink');
	Link.BeaconProduct=BeaconProduct;
	Link.ServerBeaconPort=ServerBeaconPort;
	Link.BeaconPort=BeaconPort;
	Link.OwnerFactory=self;
	Link.Start();
	Super.Query();
}

function UBrowserServerList FoundServer (string IP, int QueryPort, string Category, string GameName, optional string HostName)
{
	local UBrowserServerList L;

	L=Super.FoundServer(IP,QueryPort,Category,GameName);
	L.bLocalServer=True;
	if (  !L.bPinging )
	{
		L.PingServer(True,True,False);
	}
	return L;
}

function QueryFinished (bool bSuccess, optional string ErrorMsg)
{
	Link.Destroy();
	Link=None;
	Super.QueryFinished(bSuccess,ErrorMsg);
}

function Shutdown (optional bool bBySuperset)
{
	if ( Link != None )
	{
		Link.Destroy();
	}
	Link=None;
	Super.Shutdown(bBySuperset);
}

defaultproperties
{
    BeaconProduct="Unreal"
    ServerBeaconPort=7775
    BeaconPort=7776
}