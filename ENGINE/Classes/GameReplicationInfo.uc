//================================================================================
// GameReplicationInfo.
//================================================================================
class GameReplicationInfo expands ReplicationInfo;

var string GameName;
var bool bTeamGame;
var int RemainingTime;
var int ElapsedTime;
var() globalconfig string ServerName;
var() globalconfig string ShortName;
var() globalconfig string AdminName;
var() globalconfig string AdminEmail;
var() globalconfig int Region;
var() globalconfig bool ShowMOTD;
var() globalconfig string MOTDLine1;
var() globalconfig string MOTDLine2;
var() globalconfig string MOTDLine3;
var() globalconfig string MOTDLine4;
var string GameEndedComments;

replication
{
	un?reliable if ( Role == 4 )
		GameName,bTeamGame,ServerName,ShortName,AdminName,AdminEmail,Region,ShowMOTD,MOTDLine1,MOTDLine2,MOTDLine3,MOTDLine4;
	un?reliable if ( bNetInitial && (Role == 4) )
		RemainingTime,ElapsedTime;
}

simulated function PostBeginPlay ()
{
	if ( Level.NetMode == 3 )
	{
		SetTimer(1.00,True);
	}
}

simulated function Timer ()
{
	ElapsedTime++;
	if ( RemainingTime > 0 )
	{
		RemainingTime--;
	}
}

defaultproperties
{
    ServerName="Another Unreal Server"
    ShortName="Unreal Server"
    RemoteRole=ROLE_DumbProxy
}