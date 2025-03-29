//================================================================================
// UBrowserGSpyLink.
//================================================================================
class UBrowserGSpyLink expands UBrowserBufferedTCPLink
	transient;

const NextAddress= 4;
const NextIP= 3;
const FoundSecret= 2;
const FoundSecureRequest= 1;
var UBrowserGSpyFact OwnerFactory;
var IpAddr MasterServerIpAddr;
var UdpLink JunkUdpLink;
var bool bOpened;
var string MasterServerAddress;
var int MasterServerTCPPort;
var int Region;
var localized string ResolveFailedError;
var localized string TimeOutError;
var localized string CouldNotConnectError;

function BeginPlay ()
{
	Disable('Tick');
	Super.BeginPlay();
}

function Start ()
{
	ResetBuffer();
	JunkUdpLink=Spawn(Class'UdpLink');
	MasterServerIpAddr.Port=MasterServerTCPPort;
	if ( MasterServerAddress == "" )
	{
		MasterServerAddress="master" $ string(Region) $ ".gamespy.com";
	}
	Resolve(MasterServerAddress);
}

event Destroyed ()
{
	if ( JunkUdpLink != None )
	{
		JunkUdpLink.Destroy();
	}
}

function DoBufferQueueIO ()
{
	Super.DoBufferQueueIO();
}

function Resolved (IpAddr Addr)
{
	MasterServerIpAddr.Addr=Addr.Addr;
	if ( MasterServerIpAddr.Addr == 0 )
	{
		Log("UBrowserGSpyLink: Invalid master server address, aborting.");
		return;
	}
	Log("UBrowserGSpyLink: Master Server is " $ MasterServerAddress $ ":" $ string(MasterServerIpAddr.Port));
	if (  !BindPort() )
	{
		Log("UBrowserGSpyLink: Error binding local port, aborting.");
		return;
	}
	Open(MasterServerIpAddr);
	SetTimer(10.00,False);
}

event Timer ()
{
	if (  !bOpened )
	{
		Log("UBrowserGSpyLink: Couldn't connect to master server.");
		OwnerFactory.QueryFinished(False,CouldNotConnectError $ MasterServerAddress);
		GotoState('Done');
	}
}

event Closed ()
{
}

function ResolveFailed ()
{
	Log("UBrowserGSpyLink: Failed to resolve master server address, aborting.");
	OwnerFactory.QueryFinished(False,ResolveFailedError $ MasterServerAddress);
	GotoState('Done');
}

event Opened ()
{
	bOpened=True;
	Enable('Tick');
	WaitFor("\basic\\secure\",5.00,1);
}

function Tick (float DeltaTime)
{
	DoBufferQueueIO();
}

function HandleServer (string Text)
{
	local string Address;
	local string Port;

	Address=ParseDelimited(Text,":",1);
	Port=ParseDelimited(ParseDelimited(Text,":",2),"\",1);
	OwnerFactory.FoundServer(Address,int(Port),"","Unreal");
}

function GotMatch (int MatchData)
{
	switch (MatchData)
	{
		case 1:
		Enable('Tick');
		WaitForCount(6,5.00,2);
		break;
		case 2:
		Enable('Tick');
		SendBufferedData("\gamename\unreal\location\" $ string(Region) $ "\validate\" $ JunkUdpLink.Validate(WaitResult) $ "\final\");
		JunkUdpLink.Destroy();
		JunkUdpLink=None;
		GotoState('FoundSecretState');
		break;
		case 3:
		Enable('Tick');
		if ( WaitResult == "final\" )
		{
			OwnerFactory.QueryFinished(True);
			GotoState('Done');
		}
		else
		{
			WaitFor("\",10.00,4);
		}
		break;
		case 4:
		Enable('Tick');
		HandleServer(WaitResult);
		WaitFor("\",5.00,3);
		break;
		default:
		break;
	}
}

function GotMatchTimeout (int MatchData)
{
	OwnerFactory.QueryFinished(False,TimeOutError);
	GotoState('Done');
}

state FoundSecretState
{
Begin:
	Enable('Tick');
	Sleep(2.00);
	SendBufferedData("\list\\gamename\unreal\final\");
	WaitFor("ip\",30.00,3);
}

state Done
{
Begin:
	Disable('Tick');
}

defaultproperties
{
    ResolveFailedError="The master server could not be resolved: "
    TimeOutError="The master server timed out during protocol negotiations"
    CouldNotConnectError="Connecting to the master server timed out: "
}