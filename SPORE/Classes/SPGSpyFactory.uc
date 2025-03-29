//================================================================================
// SPGSpyFactory.
//================================================================================
class SPGSpyFactory expands UBrowserServerListFactory;

var SPGSpyLink Link;
var() config string MasterServerAddress;
var() config int MasterServerTCPPort;
var() config int Region;

function Query (optional bool bBySuperset, optional bool bInitial)
{
	Link=GetPlayerOwner().GetEntryLevel().Spawn(Class'SPGSpyLink');
	Link.MasterServerAddress=MasterServerAddress;
	Link.MasterServerTCPPort=MasterServerTCPPort;
	Link.Region=Region;
	Link.OwnerFactory=self;
	Link.Start();
	Super.Query();
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
	SaveConfig();
}

defaultproperties
{
    MasterServerAddress="192.168.150.42"
    MasterServerTCPPort=28900
}