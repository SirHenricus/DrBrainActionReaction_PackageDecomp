//================================================================================
// UBrowserHTTPFact.
//================================================================================
class UBrowserHTTPFact expands UBrowserServerListFactory;

var UBrowserHTTPLink Link;
var() config string MasterServerAddress;
var() config string MasterServerURI;
var() config int MasterServerTCPPort;

function Query (optional bool bBySuperset, optional bool bInitial)
{
	Link=GetPlayerOwner().GetEntryLevel().Spawn(Class'UBrowserHTTPLink');
	Link.MasterServerAddress=MasterServerAddress;
	Link.MasterServerURI=MasterServerURI;
	Link.MasterServerTCPPort=MasterServerTCPPort;
	Link.OwnerFactory=self;
	Link.Start();
	Super.Query();
}

function QueryFinished (bool bSuccess, optional string ErrorMsg)
{
	Log("HTTPFact: QueryFinished called. " $ ErrorMsg);
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
    MasterServerAddress="master.telefragged.com"
    MasterServerURI="/servers.txt"
    MasterServerTCPPort=80
}