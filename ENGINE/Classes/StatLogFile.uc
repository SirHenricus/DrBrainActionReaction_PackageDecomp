//================================================================================
// StatLogFile.
//================================================================================
class StatLogFile expands StatLog
	native;

var bool bWatermark;
var int LogAr;
var string StatLogFile;

native final function OpenLog ();

native final function CloseLog ();

native final function Watermark (string EventString);

native final function string GetChecksum ();

native final function string GetPlayerChecksum (string PlayerName, string Secret);

native final function FileFlush ();

native final function FileLog (string EventString);

function StartLog ()
{
	local string AbsoluteTime;

	AbsoluteTime=GetShortAbsoluteTime();
	if (  !bWorld )
	{
		StatLogFile="Log" $ AbsoluteTime $ ".log";
	}
	else
	{
		StatLogFile="Log" $ AbsoluteTime $ ".log";
	}
	OpenLog();
}

function StopLog ()
{
	FlushLog();
	CloseLog();
}

function FlushLog ()
{
	FileFlush();
}

function LogEventString (string EventString)
{
	if ( bWatermark )
	{
		Watermark(EventString);
	}
	FileLog(EventString);
	FlushLog();
}

function string GetLogFileName ()
{
	return StatLogFile;
}

function LogPlayerConnect (Pawn Player)
{
	local string Checksum;

	if ( bWorld )
	{
		if ( Player.PlayerReplicationInfo.bIsABot )
		{
			Checksum="IsABot";
		}
		else
		{
			Checksum=GetPlayerChecksum(Player.PlayerReplicationInfo.PlayerName,PlayerPawn(Player).ngWorldSecret);
		}
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Connect" $ Chr(9) $ Player.PlayerReplicationInfo.PlayerName $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ Checksum);
		LogPlayerInfo(Player);
	}
	else
	{
		Super.LogPlayerConnect(Player);
	}
}

function LogGameEnd (string Reason)
{
	if ( bWorld )
	{
		bWatermark=False;
		LogEventString(GetTimeStamp() $ Chr(9) $ "game_end" $ Chr(9) $ Reason $ Chr(9) $ GetChecksum() $ "");
	}
	else
	{
		Super.LogGameEnd(Reason);
	}
}

defaultproperties
{
    StatLogFile=".."
}