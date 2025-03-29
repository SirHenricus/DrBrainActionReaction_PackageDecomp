//================================================================================
// UdpBeacon.
//================================================================================
class UdpBeacon expands UdpLink
	transient;

var() globalconfig bool DoBeacon;
var() globalconfig int ServerBeaconPort;
var() globalconfig int BeaconPort;
var() globalconfig float BeaconTimeout;
var() globalconfig string BeaconProduct;
var int UdpServerQueryPort;

function BeginPlay ()
{
	if ( BindPort(ServerBeaconPort) )
	{
		Log("ServerBeacon listening on port " $ string(ServerBeaconPort));
	}
	else
	{
		Log("ServerBeacon failed: Could not bind port " $ string(ServerBeaconPort));
	}
	BroadcastBeacon();
}

function BroadcastBeacon ()
{
	local IpAddr Addr;
	local string BeaconText;

	Log("Broadcasting Beacon");
	Addr.Addr=BroadcastAddr;
	Addr.Port=BeaconPort;
	BeaconText=Level.Game.GetBeaconText();
	SendText(Addr,BeaconProduct @ Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":") + 1) @ BeaconText);
}

function BroadcastBeaconQuery ()
{
	local IpAddr Addr;

	Log("Broadcasting Query Beacon");
	Addr.Addr=BroadcastAddr;
	Addr.Port=BeaconPort;
	SendText(Addr,BeaconProduct @ string(UdpServerQueryPort));
}

event ReceivedText (IpAddr Addr, string Text)
{
	if ( Text == "REPORT" )
	{
		BroadcastBeacon();
	}
	if ( Text == "REPORTQUERY" )
	{
		BroadcastBeaconQuery();
	}
}

function Destroyed ()
{
	Super.Destroyed();
	Log("ServerBeacon Destroyed");
}

defaultproperties
{
    DoBeacon=True
    ServerBeaconPort=7775
    BeaconPort=7776
    BeaconTimeout=5.00
    BeaconProduct="Unreal"
}