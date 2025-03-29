//================================================================================
// PlayerReplicationInfo.
//================================================================================
class PlayerReplicationInfo expands ReplicationInfo
	native;

var string PlayerName;
var int PlayerID;
var string TeamName;
var travel byte Team;
var int TeamID;
var float Score;
var float Spree;
var Class<VoicePack> VoiceType;
var Decoration HasFlag;
var int Ping;
var bool bIsFemale;
var bool bIsABot;
var bool bFeigningDeath;
var bool bIsSpectator;
var Texture TalkTexture;
var ZoneInfo PlayerZone;

replication
{
	un?reliable if ( Role == 4 )
		PlayerName,TeamName,Team,TeamID,Score,VoiceType,HasFlag,Ping,bIsABot,bFeigningDeath,bIsSpectator,TalkTexture,PlayerZone;
}

function PostBeginPlay ()
{
	Timer();
	SetTimer(2.00,True);
	bIsFemale=Pawn(Owner).bIsFemale;
}

function Timer ()
{
	if ( PlayerPawn(Owner) != None )
	{
		Ping=int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
	}
}

defaultproperties
{
    Team=255
}