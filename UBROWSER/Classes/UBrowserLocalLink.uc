//================================================================================
// UBrowserLocalLink.
//================================================================================
class UBrowserLocalLink expands UdpLink
	transient;

var UBrowserLocalFact OwnerFactory;
var string BeaconProduct;
var int ServerBeaconPort;
var int BeaconPort;

function Start ()
{
	if ( BindPort(BeaconPort,True) )
	{
		SetTimer(8.00,False);
	}
	else
	{
		OwnerFactory.QueryFinished(False,"Beacon port in use.");
		return;
	}
	BroadcastBeacon();
}

function Timer ()
{
	OwnerFactory.QueryFinished(True);
}

function BroadcastBeacon ()
{
	local IpAddr Addr;

	Addr.Addr=BroadcastAddr;
	Addr.Port=ServerBeaconPort;
	SendText(Addr,"REPORTQUERY");
}

event ReceivedText (IpAddr Addr, string Text)
{
	local int N;
	local int QueryPort;
	local string Address;

	N=Len(BeaconProduct);
	if ( Left(Text,N) == BeaconProduct )
	{
		QueryPort=int(Mid(Text,N + 1,255));
		Address=IpAddrToString(Addr);
		Address=Left(Address,InStr(Address,":"));
		OwnerFactory.FoundServer(Address,QueryPort,"",BeaconProduct);
	}
}