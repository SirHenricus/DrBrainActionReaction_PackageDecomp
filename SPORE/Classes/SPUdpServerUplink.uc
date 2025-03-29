//================================================================================
// SPUdpServerUplink.
//================================================================================
class SPUdpServerUplink expands UdpServerUplink
	transient;

function PreBeginPlay ()
{
	if (  !DoUplink )
	{
		Log("DoUplink is not set.  Not connecting to GameSpy.");
		return;
	}
	foreach AllActors(Class'UdpServerQuery',Query,TargetQueryName)
	{
		goto JL005A;
	}
	if ( Query == None )
	{
		Log("UdpServerUplink: Could not find a UdpServerQuery object, aborting.");
		return;
	}
	HeartbeatMessage="\heartbeat\" $ string(Query.Port) $ "\gamename\drbrain";
	MasterServerIpAddr.Port=MasterServerPort;
	if ( MasterServerAddress == "" )
	{
		MasterServerAddress="master" $ string(Region) $ ".gamespy.com";
	}
	Resolve(MasterServerAddress);
}