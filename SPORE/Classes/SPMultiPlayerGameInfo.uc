//================================================================================
// SPMultiPlayerGameInfo.
//================================================================================
class SPMultiPlayerGameInfo expands SPGameInfo;

var() globalconfig int TimeLimitInSeconds;
var() globalconfig int SecondsBeforeRestart;
var() globalconfig bool bWriteLogFiles;
var bool bGameOver;

event BeginPlay ()
{
	MultiPlayerStartGame();
	SetTimer(1.00,True);
	SaveConfig();
}

event PostBeginPlay ()
{
	if ( bWriteLogFiles )
	{
		WorldLog=Spawn(Class'StatLogFile');
		WorldLog.StartLog();
		WorldLog.LogGameStart();
		WorldLog.LogMapTitle();
		WorldLogFileName=WorldLog.GetLogFileName();
	}
}

function Logout (Pawn Exiting)
{
	Level.Game.WorldLog.LogPlayerScore(SPPlayer(Exiting));
	Super.Logout(Exiting);
}

event Timer ()
{
	if (  !bGameOver )
	{
		TimeLimitInSeconds--;
		if ( TimeLimitInSeconds < 0 )
		{
			bGameOver=True;
			MultiPlayerEndGame();
			SetTimer(1.00,True);
		}
	}
	else
	{
		SecondsBeforeRestart--;
		if ( SecondsBeforeRestart <= 0 )
		{
			MultiPlayerRestart();
		}
	}
}

function MultiPlayerStartGame ()
{
	local SPPlayer P;

	foreach AllActors(Class'SPPlayer',P)
	{
		P.AdventureLinkStartGame();
	}
}

function MultiPlayerEndGame ()
{
	local SPPlayer P;

	foreach AllActors(Class'SPPlayer',P)
	{
		WorldLog.LogPlayerScore(P);
		P.AdventureLinkGameOver();
	}
}

function MultiPlayerRestart ()
{
	Level.ServerTravel("?Restart",False);
}

function NavigationPoint FindPlayerStart (byte Team, optional string incomingName)
{
	local PlayerStart Dest;
	local Teleporter Tel;
	local int NumPlayerStarts;
	local int ChosenPlayerStart;
	local int CurrentPlayerStart;

	if ( incomingName != "" )
	{
		foreach AllActors(Class'Teleporter',Tel)
		{
			if ( string(Tel.Tag) ~= incomingName )
			{
				return Tel;
			}
		}
	}
	foreach AllActors(Class'PlayerStart',Dest)
	{
		NumPlayerStarts++;
	}
	ChosenPlayerStart=Rand(NumPlayerStarts) + 1;
	foreach AllActors(Class'PlayerStart',Dest)
	{
		CurrentPlayerStart++;
		if ( ChosenPlayerStart == CurrentPlayerStart )
		{
			return Dest;
		}
	}
	Log("<ERROR> No player start found");
	return None;
}

function bool AllowsBroadcast (Actor broadcaster, int Len)
{
	return True;
}

defaultproperties
{
    TimeLimitInSeconds=1800
    SecondsBeforeRestart=10
    ScoreBoardType=Class'SPScoreBoard'
    bLoggingGame=True
}