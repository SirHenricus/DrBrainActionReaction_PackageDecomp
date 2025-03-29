//================================================================================
// SPGSpyLink.
//================================================================================
class SPGSpyLink expands UBrowserBufferedTCPLink
	transient;

const NextAddress= 4;
const NextIP= 3;
const FoundSecret= 2;
const FoundSecureRequest= 1;
var SPGSpyFactory OwnerFactory;
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
	Log("Connection to Master server closed");
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
	Log("Successfully connected to Master server");
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
	OwnerFactory.FoundServer(Address,int(Port),"","DrBrain");
}

function GotMatch (int MatchData)
{
	local string Line;

	switch (MatchData)
	{
		case 1:
		Enable('Tick');
		Log("FoundSecureRequest >>" $ WaitResult $ "<<");
		WaitForCount(6,5.00,2);
		break;
		case 2:
		Enable('Tick');
		Log("FoundSecret >>" $ WaitResult $ "<<");
		SendBufferedData("\gamename\drbrain\location\" $ string(Region) $ "\validate\" $ JunkUdpLink.Validate(WaitResult) $ "\final\");
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
		Log("Unknown waitfor data: " $ string(MatchData));
		break;
	}
}

function GotMatchTimeout (int MatchData)
{
	Log("Timeout in WaitFor >>" $ WaitResult $ "<<");
	Log("Match data was " $ string(MatchData));
	OwnerFactory.QueryFinished(False,TimeOutError);
	GotoState('Done');
}

state FoundSecretState
{
Begin:
	Enable('Tick');
	Sleep(2.00);
	SendBufferedData("\list\\gamename\drbrain\final\");
	WaitFor("ip\",30.00,3);
}

state Done
{
Begin:
	Disable('Tick');
}