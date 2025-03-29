//================================================================================
// ClientBeaconReceiver.
//================================================================================
class ClientBeaconReceiver expands UdpBeacon
	transient;

var BeaconInfo Beacons[32];
struct BeaconInfo
{
	var IpAddr Addr;
	var float Time;
	var string Text;
};


function string GetBeaconAddress (int i)
{
	return IpAddrToString(Beacons[i].Addr);
}

function string GetBeaconText (int i)
{
	return Beacons[i].Text;
}

function BeginPlay ()
{
	if ( BindPort(BeaconPort,True) )
	{
		SetTimer(1.00,True);
		Log("ClientBeaconReceiver initialized.");
	}
	else
	{
		Log("ClientBeaconReceiver failed: Beacon port in use.");
	}
	BroadcastBeacon();
}

function Destroyed ()
{
	Log("ClientBeaconReceiver finished.");
}

function Timer ()
{
	local int i;
	local int j;

	i=0;
JL0007:
	if ( i < 32 )
	{
		if ( (Beacons[i].Addr.Addr != 0) && (Level.TimeSeconds - Beacons[i].Time < BeaconTimeout) )
		{
			Beacons[j++ ]=Beacons[i];
		}
		i++;
		goto JL0007;
	}
	j=j;
JL0088:
	if ( j < 32 )
	{
		Beacons[j].Addr.Addr=0;
		j++;
		goto JL0088;
	}
}

function BroadcastBeacon ()
{
	local IpAddr Addr;

	Addr.Addr=BroadcastAddr;
	Addr.Port=ServerBeaconPort;
	SendText(Addr,"REPORT");
}

event ReceivedText (IpAddr Addr, string Text)
{
	local int i;
	local int N;

	N=Len(BeaconProduct);
	if ( Left(Text,N) == BeaconProduct )
	{
		Text=Mid(Text,N + 1);
		Addr.Port=int(Text);
		i=0;
JL0050:
		if ( i < 32 )
		{
			if ( Beacons[i].Addr==Addr )
			{
				goto JL0086;
			}
			i++;
			goto JL0050;
		}
JL0086:
		if ( i == 32 )
		{
			i=0;
JL0099:
			if ( i < 32 )
			{
				if ( Beacons[i].Addr.Addr == 0 )
				{
					goto JL00CD;
				}
				i++;
				goto JL0099;
			}
		}
JL00CD:
		if ( i == 32 )
		{
			return;
		}
		Beacons[i].Addr=Addr;
		Beacons[i].Time=Level.TimeSeconds;
		Beacons[i].Text=Mid(Text,InStr(Text," ") + 1);
	}
}