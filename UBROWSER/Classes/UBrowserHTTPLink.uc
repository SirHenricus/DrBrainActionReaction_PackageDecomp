//================================================================================
// UBrowserHTTPLink.
//================================================================================
class UBrowserHTTPLink expands UBrowserBufferedTCPLink
	transient;

const FoundServer= 2;
const FoundHeader= 1;
var UBrowserHTTPFact OwnerFactory;
var IpAddr MasterServerIpAddr;
var bool bHasOpened;
var string MasterServerAddress;
var string MasterServerURI;
var int MasterServerTCPPort;
var localized string ResolveFailedError;
var localized string TimeOutError;
var localized string CouldNotConnectError;

function BeginPlay ()
{
	bHasOpened=False;
	Disable('Tick');
	Super.BeginPlay();
}

function Start ()
{
	ResetBuffer();
	MasterServerIpAddr.Port=MasterServerTCPPort;
	Resolve(MasterServerAddress);
}

function DoBufferQueueIO ()
{
	Super.DoBufferQueueIO();
	if ( bHasOpened && (PeekChar() == 0) &&  !IsConnected() )
	{
		OwnerFactory.QueryFinished(True);
		GotoState('Done');
	}
}

function Resolved (IpAddr Addr)
{
	MasterServerIpAddr.Addr=Addr.Addr;
	if ( MasterServerIpAddr.Addr == 0 )
	{
		Log("UBrowserHTTPLink: Invalid master server address, aborting.");
		return;
	}
	Log("UBrowserHTTPLink: Master Server is " $ MasterServerAddress $ ":" $ string(MasterServerIpAddr.Port));
	if (  !BindPort() )
	{
		Log("UBrowserHTTPLink: Error binding local port, aborting.");
		return;
	}
	Open(MasterServerIpAddr);
	SetTimer(10.00,False);
}

event Timer ()
{
	if (  !bHasOpened )
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
	Log("UBrowserHTTPLink: Failed to resolve master server address, aborting.");
	OwnerFactory.QueryFinished(False,ResolveFailedError $ MasterServerAddress);
	GotoState('Done');
}

event Opened ()
{
	Enable('Tick');
	bHasOpened=True;
	SendBufferedData("GET " $ MasterServerURI $ " HTTP/1.0" $ CR $ LF);
	SendBufferedData("User-Agent: Unreal" $ CR $ LF);
	SendBufferedData("Host:" $ MasterServerAddress $ ":" $ string(MasterServerTCPPort) $ CR $ LF $ CR $ LF);
	WaitFor("200",10.00,1);
}

function Tick (float DeltaTime)
{
	DoBufferQueueIO();
}

function HandleServer (string Text)
{
	local string Address;
	local string Port;

	Address=ParseDelimited(Text," ",1);
	Port=ParseDelimited(Text," ",3);
	OwnerFactory.FoundServer(Address,int(Port),"","Unreal");
}

function GotMatch (int MatchData)
{
	switch (MatchData)
	{
		case 1:
		Enable('Tick');
		if ( (Chr(PeekChar()) == CR) || (Chr(PeekChar()) == LF) )
		{
			ReadChar();
		}
JL003E:
		if ( (Right(WaitResult,1) == CR) || (Right(WaitResult,1) == LF) )
		{
			WaitResult=Left(WaitResult,Len(WaitResult) - 1);
			goto JL003E;
		}
		if ( WaitResult != "" )
		{
			WaitFor(CR,10.00,1);
		}
		else
		{
			WaitFor(CR,10.00,2);
		}
		break;
		case 2:
		Enable('Tick');
		if ( (Chr(PeekChar()) == CR) || (Chr(PeekChar()) == LF) )
		{
			ReadChar();
		}
JL00EB:
		if ( (Right(WaitResult,1) == CR) || (Right(WaitResult,1) == LF) )
		{
			WaitResult=Left(WaitResult,Len(WaitResult) - 1);
			goto JL00EB;
		}
		HandleServer(WaitResult);
		WaitFor(CR,10.00,2);
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