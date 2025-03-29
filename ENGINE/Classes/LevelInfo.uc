//================================================================================
// LevelInfo.
//================================================================================
class LevelInfo expands ZoneInfo
	native;

enum ENetMode {
	NM_Standalone,
	NM_DedicatedServer,
	NM_ListenServer,
	NM_Client
};

enum ELevelAction {
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_Connecting,
	LEVACT_Precaching
};

var() float TimeDilation;
var float TimeSeconds;
var transient int Year;
var transient int Month;
var transient int Day;
var transient int DayOfWeek;
var transient int Hour;
var transient int Minute;
var transient int Second;
var transient int Millisecond;
var() localized string Title;
var() string Author;
var() localized string IdealPlayerCount;
var() int RecommendedEnemies;
var() int RecommendedTeammates;
var() localized string LevelEnterText;
var() string LocalizedPkg;
var string Pauser;
var() bool bLonePlayer;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bHighDetailMode;
var bool bStartup;
var() bool bHumansOnly;
var bool bNoCheating;
var globalconfig bool bEnhancedContent;
var(Audio) const Music Song;
var(Audio) const byte SongSection;
var(Audio) const byte CdTrack;
var(Audio) float PlayerDoppler;
var() float Brightness;
var() Texture Screenshot;
var Texture DefaultTexture;
var int HubStackLevel;
var transient ELevelAction LevelAction;
var ENetMode NetMode;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var() Class<GameInfo> DefaultGameType;
var GameInfo Game;
var const NavigationPoint NavigationPointList;
var const Pawn PawnList;
var string NextURL;
var bool bNextItems;
var float NextSwitchCountdown;
var int AIProfile[8];
var float AvgAITime;
var() bool bCheckWalkSurfaces;

replication
{
	un?reliable if ( Role == 4 )
		TimeDilation,Pauser,bNoCheating;
}

native function string GetLocalURL ();

native function string GetAddressURL ();

event ServerTravel (string URL, bool bItems)
{
	if ( NextURL == "" )
	{
		bNextItems=bItems;
		NextURL=URL;
		if ( Game != None )
		{
			Game.ProcessServerTravel(URL,bItems);
		}
		else
		{
			NextSwitchCountdown=0.00;
		}
	}
}

defaultproperties
{
    TimeDilation=1.00
    Title="Untitled"
    bHighDetailMode=True
    CdTrack=255
    Brightness=1.00
    DefaultTexture=Texture'DefaultTexture'
    bHiddenEd=True
}