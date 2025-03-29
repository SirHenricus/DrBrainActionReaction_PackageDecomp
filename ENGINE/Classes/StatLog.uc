//================================================================================
// StatLog.
//================================================================================
class StatLog expands Info
	native;

var int Context;
var bool bWorld;
var float TimeStamp;
var() string LocalStandard;
var() string WorldStandard;
var() string LogVersion;
var() string LogInfoURL;
var() string GameName;
var() string GameCreator;
var() string GameCreatorURL;
var() string DecoderRingURL;
var() string LocalLogDir;
var() string WorldLogDir;

function BeginPlay ()
{
}

function Timer ()
{
	LogPings();
}

function StartLog ()
{
}

function StopLog ()
{
}

function FlushLog ()
{
}

function LogEventString (string EventString)
{
	Log(EventString);
}

native final function string GetGMTRef ();

function string GetAbsoluteTime ()
{
	local string AbsoluteTime;
	local string GMTRef;

	AbsoluteTime=string(Level.Year);
	if ( Level.Month < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Month);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Month);
	}
	if ( Level.Day < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Day);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Day);
	}
	if ( Level.Hour < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Hour);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Hour);
	}
	if ( Level.Minute < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Minute);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Minute);
	}
	if ( Level.Second < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Second);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Second);
	}
	if ( Level.Millisecond < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Millisecond);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Millisecond);
	}
	GMTRef=GetGMTRef();
	AbsoluteTime=AbsoluteTime $ "." $ GMTRef;
	TimeStamp=0.00;
	return AbsoluteTime;
}

function string GetShortAbsoluteTime ()
{
	local string AbsoluteTime;

	AbsoluteTime=string(Level.Year);
	if ( Level.Month < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Month);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Month);
	}
	if ( Level.Day < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Day);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Day);
	}
	if ( Level.Hour < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Hour);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Hour);
	}
	if ( Level.Minute < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Minute);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Minute);
	}
	if ( Level.Second < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Second);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Second);
	}
	TimeStamp=0.00;
	return AbsoluteTime;
}

function string GetTimeStamp ()
{
	local string Time;
	local int pos;

	Time=string(TimeStamp);
	Time=Left(Time,InStr(Time,".") + 3);
	return Time;
}

function string GetLogFileName ()
{
	return "";
}

function Tick (float Delta)
{
	TimeStamp += Delta;
}

function LogStandardInfo ()
{
	if ( bWorld )
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Standard" $ Chr(9) $ WorldStandard);
	}
	else
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Standard" $ Chr(9) $ LocalStandard);
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Version" $ Chr(9) $ LogVersion);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Info_URL" $ Chr(9) $ LogInfoURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Name" $ Chr(9) $ GameName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Version" $ Chr(9) $ Level.EngineVersion);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Creator" $ Chr(9) $ GameCreator);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Creator_URL" $ Chr(9) $ GameCreatorURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Decoder_Ring_URL" $ Chr(9) $ DecoderRingURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Absolute_Time" $ Chr(9) $ GetAbsoluteTime());
}

function LogServerInfo ()
{
	local string NetworkNumber;

	NetworkNumber=Level.Game.GetNetworkNumber();
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_ServerName" $ Chr(9) $ Level.Game.GameReplicationInfo.ServerName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_AdminName" $ Chr(9) $ Level.Game.GameReplicationInfo.AdminName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_AdminEmail" $ Chr(9) $ Level.Game.GameReplicationInfo.AdminEmail);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Region" $ Chr(9) $ string(Level.Game.GameReplicationInfo.Region));
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine1" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine1);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine2" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine2);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine3" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine3);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine4" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine4);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_IP" $ Chr(9) $ NetworkNumber);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Port" $ Chr(9) $ string(Level.Game.GetServerPort()));
}

native final function string GetMapFileName ();

function LogMapParameters ()
{
	local string MapName;

	MapName=GetMapFileName();
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Name" $ Chr(9) $ MapName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Title" $ Chr(9) $ Level.Title);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Author" $ Chr(9) $ Level.Author);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "IdealPlayerCount" $ Chr(9) $ Level.IdealPlayerCount);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "LevelEnterText" $ Chr(9) $ Level.LevelEnterText);
}

function LogPlayerConnect (Pawn Player)
{
}

function LogPlayerInfo (Pawn Player)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "TeamName" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ Player.PlayerReplicationInfo.TeamName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Team" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.Team));
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "TeamID" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.TeamID));
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Ping" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.Ping));
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "IsABot" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.bIsABot));
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Skill" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.Skill));
}

function LogPlayerDisconnect (Pawn Player)
{
}

function LogKill (int KillerID, int VictimID, string KillerWeaponName, string VictimWeaponName, name DamageType)
{
}

function LogSuicide (Pawn Killed, name DamageType)
{
	local int KilledID;

	KilledID=Killed.PlayerReplicationInfo.PlayerID;
}

function LogTypingEvent (bool bTyping, Pawn Other)
{
}

function LogPickup (Inventory Item, Pawn Other)
{
}

function LogItemActivate (Inventory Item, Pawn Other)
{
}

function LogItemDeactivate (Inventory Item, Pawn Other)
{
}

function LogPlayerScore (PlayerPawn Player)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player_score" $ Chr(9) $ Player.PlayerReplicationInfo.PlayerName $ Chr(9) $ string(Player.PlayerReplicationInfo.Score));
}

function LogMapTitle ()
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Title" $ Chr(9) $ Level.Title);
}

function LogSpecialEvent (string EventType, optional coerce string Arg1, optional coerce string Arg2, optional coerce string Arg3, optional coerce string Arg4)
{
	local string Event;

	Event=EventType;
	if ( Arg1 != "" )
	{
		Event=Event $ Chr(9) $ Arg1;
	}
	if ( Arg2 != "" )
	{
		Event=Event $ Chr(9) $ Arg2;
	}
	if ( Arg3 != "" )
	{
		Event=Event $ Chr(9) $ Arg3;
	}
	if ( Arg4 != "" )
	{
		Event=Event $ Chr(9) $ Arg4;
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ Event);
}

function LogPings ()
{
	local PlayerReplicationInfo PRI;

	foreach AllActors(Class'PlayerReplicationInfo',PRI)
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Ping" $ Chr(9) $ string(PRI.PlayerID) $ Chr(9) $ string(PRI.Ping));
	}
}

function LogGameStart ()
{
}

function LogGameEnd (string Reason)
{
}

defaultproperties
{
    LocalStandard="ngLog"
    WorldStandard="ngLog"
    LogVersion="1.2"
    LogInfoURL="http://www.netgamesusa.com/ngLog/"
    GameName="Unreal"
    GameCreator="Epic MegaGames, Inc."
    GameCreatorURL="http://www.epicgames.com/"
    DecoderRingURL="http://unreal.epicgames.com/Unreal_Log_Decoder_Ring.html"
    LocalLogDir=".."
    WorldLogDir="..tGamesUSA.com"
}