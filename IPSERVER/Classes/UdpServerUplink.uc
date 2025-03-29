//================================================================================
// UdpServerUplink.
//================================================================================
class UdpServerUplink expands UdpLink
	transient;

var() config bool DoUplink;
var() config int UpdateMinutes;
var() config string MasterServerAddress;
var() config int MasterServerPort;
var() config int Region;
var() name TargetQueryName;
var IpAddr MasterServerIpAddr;
var string HeartbeatMessage;
var UdpServerQuery Query;

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
	HeartbeatMessage="\heartbeat\" $ string(Query.Port) $ "\gamename\unreal";
	MasterServerIpAddr.Port=MasterServerPort;
	if ( MasterServerAddress == "" )
	{
		MasterServerAddress="master" $ string(Region) $ ".gamespy.com";
	}
	Resolve(MasterServerAddress);
}

function Resolved (IpAddr Addr)
{
	local bool Result;
	local int UplinkPort;

	MasterServerIpAddr.Addr=Addr.Addr;
	if ( MasterServerIpAddr.Addr == 0 )
	{
		Log("UdpServerUplink: Invalid master server address, aborting.");
		return;
	}
	Log("UdpServerUplink: Master Server is " $ MasterServerAddress $ ":" $ string(MasterServerIpAddr.Port));
	UplinkPort=Query.Port + 1;
	if (  !BindPort(UplinkPort,True) )
	{
		Log("UdpServerUplink: Error binding port, aborting.");
		return;
	}
	Log("UdpServerUplink: Port " $ string(UplinkPort) $ " successfully bound.");
	Resume();
}

function ResolveFailed ()
{
	Log("UdpServerUplink: Failed to resolve master server address, aborting.");
}

function Timer ()
{
	local bool Result;

	Result=SendText(MasterServerIpAddr,HeartbeatMessage);
	if (  !Result )
	{
		Log("Failed to send heartbeat to master server.");
	}
}

function Halt ()
{
	Log("UdpServerUplink: Halting by request.");
	SetTimer(0.00,False);
}

function Resume ()
{
	Log("UdpServerUplink: Resuming by request.");
	SetTimer(UpdateMinutes * 60,True);
	Timer();
}

defaultproperties
{
    UpdateMinutes=1
    MasterServerPort=27900
    TargetQueryName=MasterUplink
}