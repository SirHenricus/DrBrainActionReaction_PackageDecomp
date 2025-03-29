//================================================================================
// GameInfo.
//================================================================================
class GameInfo expands Info
	native;

var int ItemGoals;
var int KillGoals;
var int SecretGoals;
var byte Difficulty;
var() config bool bNoMonsters;
var() globalconfig bool bMuteSpectators;
var() config bool bHumansOnly;
var() bool bRestartLevel;
var() bool bPauseable;
var() config bool bCoopWeaponMode;
var() config bool bClassicDeathmessages;
var globalconfig bool bLowGore;
var bool bCanChangeSkin;
var() bool bTeamGame;
var globalconfig bool bVeryLowGore;
var() globalconfig bool bNoCheating;
var() bool bDeathMatch;
var bool bGameEnded;
var bool bOverTime;
var() globalconfig float AutoAim;
var() float GameSpeed;
var float StartTime;
var() Class<PlayerPawn> DefaultPlayerClass;
var() Class<Weapon> DefaultWeapon;
var() globalconfig int MaxSpectators;
var int NumSpectators;
var() globalconfig private string AdminPassword;
var() globalconfig private string GamePassword;
var() Class<ScoreBoard> ScoreBoardType;
var() Class<Menu> GameMenuType;
var() string BotMenuType;
var() string RulesMenuType;
var() string SettingsMenuType;
var() string GameUMenuType;
var() string MultiplayerUMenuType;
var() string GameOptionsMenuType;
var() Class<HUD> HUDType;
var() Class<MapList> MapListType;
var() string MapPrefix;
var() string BeaconName;
var() string SpecialDamageString;
var localized string SwitchLevelMessage;
var int SentText;
var localized string DefaultPlayerName;
var localized string LeftMessage;
var localized string FailedSpawnMessage;
var localized string FailedPlaceMessage;
var localized string FailedTeamMessage;
var localized string NameChangedMessage;
var localized string EnteredMessage;
var localized string GameName;
var localized string MaxedOutMessage;
var localized string WrongPassword;
var localized string NeedPassword;
var() globalconfig int MaxPlayers;
var int NumPlayers;
var int CurrentID;
var Class<Mutator> MutatorClass;
var Mutator BaseMutator;
var Class<ZoneInfo> WaterZoneType;
var name DefaultPlayerState;
var() Class<GameReplicationInfo> GameReplicationInfoClass;
var GameReplicationInfo GameReplicationInfo;
var globalconfig string ServerLogName;
var StatLog LocalLog;
var StatLog WorldLog;
var globalconfig bool bLocalLog;
var globalconfig bool bLocalLogQuery;
var globalconfig bool bWorldLog;
var bool bLoggingGame;
var string LocalLogFileName;
var string WorldLogFileName;
var() globalconfig string LocalBatcherURL;
var() globalconfig string LocalBatcherParams;
var() globalconfig string LocalStatsURL;
var() globalconfig string WorldBatcherURL;
var() globalconfig string WorldBatcherParams;
var() globalconfig string WorldStatsURL;

function PreBeginPlay ()
{
	StartTime=0.00;
	SetTimer(1.00,True);
	SetGameSpeed(GameSpeed);
	Level.bNoCheating=bNoCheating;
	if ( GameReplicationInfoClass != None )
	{
		GameReplicationInfo=Spawn(GameReplicationInfoClass);
	}
	else
	{
		GameReplicationInfo=Spawn(Class'GameReplicationInfo');
	}
	InitGameReplicationInfo();
}

function PostBeginPlay ()
{
	local ZoneInfo W;

	if ( bVeryLowGore )
	{
		bLowGore=True;
	}
	if ( WaterZoneType != None )
	{
		foreach AllActors(Class'ZoneInfo',W)
		{
			if ( W.bWaterZone )
			{
				if ( W.EntryActor == None )
				{
					W.EntryActor=WaterZoneType.Default.EntryActor;
				}
				if ( W.ExitActor == None )
				{
					W.ExitActor=WaterZoneType.Default.ExitActor;
				}
				if ( W.EntrySound == None )
				{
					W.EntrySound=WaterZoneType.Default.EntrySound;
				}
				if ( W.ExitSound == None )
				{
					W.ExitSound=WaterZoneType.Default.ExitSound;
				}
			}
		}
	}
	if ( bLocalLog && bLoggingGame )
	{
		Log("Initiating local logging...");
		LocalLog=Spawn(Class'StatLogFile');
		LocalLog.bWorld=False;
		LocalLog.StartLog();
		LocalLog.LogStandardInfo();
		LocalLog.LogServerInfo();
		LocalLog.LogMapParameters();
		LogGameParameters(LocalLog);
		LocalLog.LogGameStart();
		LocalLogFileName=LocalLog.GetLogFileName();
	}
	if ( bWorldLog && bLoggingGame )
	{
		Log("Initiating world logging...");
		WorldLog=Spawn(Class'StatLogFile');
		WorldLog.bWorld=True;
		WorldLog.StartLog();
		WorldLog.LogStandardInfo();
		WorldLog.LogServerInfo();
		WorldLog.LogMapParameters();
		LogGameParameters(WorldLog);
		WorldLog.LogGameStart();
		WorldLogFileName=WorldLog.GetLogFileName();
	}
	Super.PostBeginPlay();
}

function Timer ()
{
	SentText=0;
}

event GameEnding ()
{
	if ( LocalLog != None )
	{
		LocalLog.LogGameEnd("serverquit");
		LocalLog.StopLog();
		LocalLog.Destroy();
		LocalLog=None;
	}
	if ( WorldLog != None )
	{
		WorldLog.LogGameEnd("serverquit");
		WorldLog.StopLog();
		WorldLog.Destroy();
		WorldLog=None;
	}
}

function InitGameReplicationInfo ()
{
	GameReplicationInfo.bTeamGame=bTeamGame;
	GameReplicationInfo.GameName=GameName;
}

native function string GetNetworkNumber ();

function string GetRules ()
{
	local string ResultSet;

	if ( WorldLog != None )
	{
		ResultSet="\worldlog\true";
	}
	else
	{
		ResultSet="\worldlog\false";
	}
}

function int GetServerPort ()
{
	local string S;
	local int i;

	S=Level.GetAddressURL();
	i=InStr(S,":");
	assert (i >= 0);
	return int(Mid(S,i + 1));
}

function bool SetPause (bool bPause, PlayerPawn P)
{
	if ( bPauseable || P.bAdmin || (Level.NetMode == 0) )
	{
		if ( bPause )
		{
			Level.Pauser=P.PlayerReplicationInfo.PlayerName;
		}
		else
		{
			Level.Pauser="";
		}
		return True;
	}
	else
	{
		return False;
	}
}

function LogGameParameters (StatLog StatLog)
{
	if ( StatLog == None )
	{
		return;
	}
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameName" $ Chr(9) $ GameName);
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "NoMonsters" $ Chr(9) $ string(bNoMonsters));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MuteSpectators" $ Chr(9) $ string(bMuteSpectators));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "HumansOnly" $ Chr(9) $ string(bHumansOnly));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "WeaponsStay" $ Chr(9) $ string(bCoopWeaponMode));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "ClassicDeathmessages" $ Chr(9) $ string(bClassicDeathmessages));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "LowGore" $ Chr(9) $ string(bLowGore));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "VeryLowGore" $ Chr(9) $ string(bVeryLowGore));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "TeamGame" $ Chr(9) $ string(bTeamGame));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameSpeed" $ Chr(9) $ string(GameSpeed * 100));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MaxSpectators" $ Chr(9) $ string(MaxSpectators));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MaxPlayers" $ Chr(9) $ string(MaxPlayers));
}

native function ExecuteLocalLogBatcher ();

native function ExecuteWorldLogBatcher ();

native static function BrowseRelativeLocalURL (string URL);

function SetGameSpeed (float t)
{
	GameSpeed=FMax(t,0.10);
	Level.TimeDilation=GameSpeed;
}

static function ResetGame ();

event DetailChange ()
{
	local Actor A;
	local ZoneInfo Z;
	local SkyZoneInfo S;

	if (  !Level.bHighDetailMode )
	{
		foreach AllActors(Class'Actor',A)
		{
			if ( A.bHighDetail &&  !A.bGameRelevant )
			{
				A.Destroy();
			}
		}
	}
	foreach AllActors(Class'ZoneInfo',Z)
	{
		Z.LinkToSkybox();
	}
}

function bool IsRelevant (Actor Other)
{
	local byte bSuperRelevant;

	if ( BaseMutator.IsRelevant(Other,bSuperRelevant) )
	{
		if ( bSuperRelevant == 1 )
		{
			return True;
		}
	}
	else
	{
		return False;
	}
	if ( (Difficulty == 0) &&  !Other.bDifficulty0 || (Difficulty == 1) &&  !Other.bDifficulty1 || (Difficulty == 2) &&  !Other.bDifficulty2 || (Difficulty == 3) &&  !Other.bDifficulty3 ||  !Other.bSinglePlayer && (Level.NetMode == 0) ||  !Other.bNet && ((Level.NetMode == 1) || (Level.NetMode == 2)) ||  !Other.bNetSpecial && (Level.NetMode == 3) )
	{
		return False;
	}
	if ( bNoMonsters && (Pawn(Other) != None) &&  !Pawn(Other).bIsPlayer )
	{
		return False;
	}
	if ( FRand() > Other.OddsOfAppearing )
	{
		return False;
	}
	if ( Other.bIsSecretGoal )
	{
		SecretGoals++;
	}
	if ( Other.bIsItemGoal )
	{
		ItemGoals++;
	}
	if ( Other.bIsKillGoal )
	{
		KillGoals++;
	}
	return True;
}

function bool GrabOption (out string Options, out string Result)
{
	if ( Left(Options,1) == "?" )
	{
		Result=Mid(Options,1);
		if ( InStr(Result,"?") >= 0 )
		{
			Result=Left(Result,InStr(Result,"?"));
		}
		Options=Mid(Options,1);
		if ( InStr(Options,"?") >= 0 )
		{
			Options=Mid(Options,InStr(Options,"?"));
		}
		else
		{
			Options="";
		}
		return True;
	}
	else
	{
		return False;
	}
}

function GetKeyValue (string Pair, out string Key, out string Value)
{
	if ( InStr(Pair,"=") >= 0 )
	{
		Key=Left(Pair,InStr(Pair,"="));
		Value=Mid(Pair,InStr(Pair,"=") + 1);
	}
	else
	{
		Key=Pair;
		Value="";
	}
}

function bool HasOption (string Options, string InKey)
{
	local string Pair;
	local string Key;
	local string Value;

JL0000:
	if ( GrabOption(Options,Pair) )
	{
		GetKeyValue(Pair,Key,Value);
		if ( Key ~= InKey )
		{
			return True;
		}
		goto JL0000;
	}
	return False;
}

function string ParseOption (string Options, string InKey)
{
	local string Pair;
	local string Key;
	local string Value;

JL0000:
	if ( GrabOption(Options,Pair) )
	{
		GetKeyValue(Pair,Key,Value);
		if ( Key ~= InKey )
		{
			return Value;
		}
		goto JL0000;
	}
	return "";
}

event InitGame (string Options, out string Error)
{
	local string InOpt;
	local string LeftOpt;
	local int pos;
	local Class<Mutator> MClass;

	Log("InitGame:" @ Options);
	MaxPlayers=GetIntOption(Options,"MaxPlayers",MaxPlayers);
	InOpt=ParseOption(Options,"Difficulty");
	if ( InOpt != "" )
	{
		Difficulty=int(InOpt);
	}
	Log("Difficulty" @ string(Difficulty));
	InOpt=ParseOption(Options,"AdminPassword");
	if ( InOpt != "" )
	{
		AdminPassword=InOpt;
	}
	Log("Remote Administration with Password" @ AdminPassword);
	InOpt=ParseOption(Options,"GameSpeed");
	if ( InOpt != "" )
	{
		Log("GameSpeed" @ InOpt);
		SetGameSpeed(float(InOpt));
	}
	BaseMutator=Spawn(MutatorClass);
	Log("Base Mutator is " $ string(BaseMutator));
	InOpt=ParseOption(Options,"Mutator");
	if ( InOpt != "" )
	{
		Log("Mutators" @ InOpt);
JL0192:
		if ( InOpt != "" )
		{
			pos=InStr(InOpt,",");
			if ( pos > 0 )
			{
				LeftOpt=Left(InOpt,pos);
				InOpt=Right(InOpt,Len(InOpt) - pos - 1);
			}
			else
			{
				LeftOpt=InOpt;
				InOpt="";
			}
			Log("Add mutator " $ LeftOpt);
			MClass=Class<Mutator>(DynamicLoadObject(LeftOpt,Class'Class'));
			BaseMutator.AddMutator(Spawn(MClass));
			goto JL0192;
		}
	}
	InOpt=ParseOption(Options,"GamePassword");
	if ( InOpt != "" )
	{
		GamePassword=InOpt;
		Log("GamePassword" @ InOpt);
	}
	InOpt=ParseOption(Options,"LocalLog");
	if ( InOpt ~= "true" )
	{
		bLocalLog=True;
	}
	InOpt=ParseOption(Options,"WorldLog");
	if ( InOpt ~= "true" )
	{
		bWorldLog=True;
	}
}

event string GetBeaconText ()
{
	return Level.ComputerName $ " " $ Left(Level.Title,24) $ " " $ BeaconName $ " " $ string(NumPlayers) $ "/" $ string(MaxPlayers);
}

function ProcessServerTravel (string URL, bool bItems)
{
	local PlayerPawn P;

	if ( LocalLog != None )
	{
		LocalLog.LogGameEnd("mapchange");
		LocalLog.StopLog();
		LocalLog.Destroy();
		LocalLog=None;
	}
	if ( WorldLog != None )
	{
		WorldLog.LogGameEnd("mapchange");
		WorldLog.StopLog();
		WorldLog.Destroy();
		WorldLog=None;
	}
	Log("ProcessServerTravel:" @ URL);
	foreach AllActors(Class'PlayerPawn',P)
	{
		if ( NetConnection(P.Player) != None )
		{
			P.ClientTravel(URL,2,bItems);
		}
		else
		{
			P.PreClientTravel();
		}
	}
	if ( (Level.NetMode != 1) && (Level.NetMode != 2) )
	{
		Level.NextSwitchCountdown=0.00;
	}
}

event PreLogin (string Options, out string Error)
{
	local string InPassword;

	Error="";
	InPassword=ParseOption(Options,"Password");
	if ( (MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
	{
		Error=MaxedOutMessage;
	}
	else
	{
		if ( (GamePassword != "") && (Caps(InPassword) != Caps(GamePassword)) && ((AdminPassword == "") || (Caps(InPassword) != Caps(AdminPassword))) )
		{
			if ( InPassword == "" )
			{
				Error=NeedPassword;
			}
			else
			{
				Error=WrongPassword;
			}
		}
	}
}

function int GetIntOption (string Options, string ParseString, int CurrentValue)
{
	local string InOpt;

	InOpt=ParseOption(Options,ParseString);
	if ( InOpt != "" )
	{
		Log(ParseString @ InOpt);
		return int(InOpt);
	}
	return CurrentValue;
}

event PlayerPawn Login (string Portal, string Options, out string Error, Class<PlayerPawn> SpawnClass)
{
	local NavigationPoint StartSpot;
	local PlayerPawn NewPlayer;
	local PlayerPawn TestPlayer;
	local Pawn PawnLink;
	local string InName;
	local string InPassword;
	local string InSkin;
	local string InFace;
	local byte InTeam;

	if ( (MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
	{
		Error=MaxedOutMessage;
		return None;
	}
	InName=Left(ParseOption(Options,"Name"),20);
	InTeam=GetIntOption(Options,"Team",255);
	InPassword=ParseOption(Options,"Password");
	InSkin=ParseOption(Options,"Skin");
	InFace=ParseOption(Options,"Face");
	Log("Login:" @ InName);
	if ( InPassword != "" )
	{
		Log("Password" @ InPassword);
	}
	StartSpot=FindPlayerStart(InTeam,Portal);
	if ( StartSpot == None )
	{
		Error=FailedPlaceMessage;
		return None;
	}
	PawnLink=Level.PawnList;
JL0119:
	if ( PawnLink != None )
	{
		TestPlayer=PlayerPawn(PawnLink);
		if ( (TestPlayer != None) && (TestPlayer.Player == None) )
		{
			if ( (Level.NetMode == 0) || (TestPlayer.PlayerReplicationInfo.PlayerName ~= InName) && (TestPlayer.Password ~= InPassword) )
			{
				NewPlayer=TestPlayer;
			}
			else
			{
				PawnLink=PawnLink.nextPawn;
				goto JL0119;
			}
		}
	}
	if ( NewPlayer == None )
	{
		if ( (bHumansOnly || Level.bHumansOnly) &&  !SpawnClass.Default.bIsHuman &&  !ClassIsChildOf(SpawnClass,Class'Spectator') )
		{
			SpawnClass=DefaultPlayerClass;
		}
		if ( (NumSpectators >= MaxSpectators) && ClassIsChildOf(SpawnClass,Class'Spectator') )
		{
			Error="Max spectators exceeded";
			return None;
		}
		NewPlayer=Spawn(SpawnClass,,,StartSpot.Location,StartSpot.Rotation);
		if ( NewPlayer != None )
		{
			NewPlayer.ViewRotation=StartSpot.Rotation;
		}
	}
	if ( NewPlayer == None )
	{
		Log("Couldn't spawn player at " $ string(StartSpot));
		Error=FailedSpawnMessage;
		return None;
	}
	if ( InSkin != "" )
	{
		NewPlayer.SetMultiSkin(NewPlayer,InSkin,InFace,InTeam);
	}
	if (  !ChangeTeam(NewPlayer,InTeam) )
	{
		Error=FailedTeamMessage;
		return None;
	}
	if ( NewPlayer.IsA('Spectator') && (Level.NetMode == 1) )
	{
		NumSpectators++;
	}
	NewPlayer.Password=InPassword;
	NewPlayer.bAdmin=(AdminPassword != "") && (Caps(InPassword) == Caps(AdminPassword));
	if ( NewPlayer.bAdmin )
	{
		Log("Administrator logged in");
	}
	NewPlayer.ClientSetRotation(NewPlayer.Rotation);
	if ( InName == "" )
	{
		InName=DefaultPlayerName;
	}
	if ( (Level.NetMode != 0) || (NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName) )
	{
		ChangeName(NewPlayer,InName,False);
	}
	NewPlayer.GameReplicationInfo=GameReplicationInfo;
	if ( (Level.NetMode == 1) || (Level.NetMode == 2) )
	{
		BroadcastMessage(NewPlayer.PlayerReplicationInfo.PlayerName $ EnteredMessage,False);
	}
	StartSpot.PlayTeleportEffect(NewPlayer,True);
	NewPlayer.PlayerReplicationInfo.PlayerID=CurrentID++ ;
	if ( LocalLog != None )
	{
		LocalLog.LogPlayerConnect(NewPlayer);
	}
	if ( WorldLog != None )
	{
		WorldLog.LogPlayerConnect(NewPlayer);
	}
	if (  !NewPlayer.IsA('Spectator') )
	{
		NumPlayers++;
	}
	return NewPlayer;
}

event PostLogin (PlayerPawn NewPlayer)
{
	NewPlayer.ClientSetMusic(Level.Song,Level.SongSection,Level.CdTrack,3);
}

function bool AddBot ();

function Logout (Pawn Exiting)
{
	if ( Exiting.IsA('PlayerPawn') &&  !Exiting.IsA('Spectator') )
	{
		NumPlayers--;
	}
	if ( Spectator(Exiting) != None )
	{
		if ( Level.NetMode == 1 )
		{
			NumSpectators--;
		}
	}
	else
	{
		if ( (Level.NetMode == 1) || (Level.NetMode == 2) )
		{
			BroadcastMessage(Exiting.PlayerReplicationInfo.PlayerName $ LeftMessage,False);
		}
	}
	if ( LocalLog != None )
	{
		LocalLog.LogPlayerDisconnect(Exiting);
	}
	if ( WorldLog != None )
	{
		WorldLog.LogPlayerDisconnect(Exiting);
	}
}

event AcceptInventory (Pawn PlayerPawn)
{
	local Inventory Inv;

	AddDefaultInventory(PlayerPawn);
	Log("All inventory from" @ PlayerPawn.PlayerReplicationInfo.PlayerName @ "is accepted");
}

function AddDefaultInventory (Pawn PlayerPawn)
{
	local Weapon NewWeapon;

	PlayerPawn.JumpZ=PlayerPawn.Default.JumpZ * PlayerJumpZScaling();
	if ( PlayerPawn.IsA('Spectator') )
	{
		return;
	}
	if ( (DefaultWeapon == None) || (PlayerPawn.FindInventoryType(DefaultWeapon) != None) )
	{
		return;
	}
	NewWeapon=Spawn(BaseMutator.MutatedDefaultWeapon());
	if ( NewWeapon != None )
	{
		NewWeapon.Instigator=PlayerPawn;
		NewWeapon.BecomeItem();
		PlayerPawn.AddInventory(NewWeapon);
		NewWeapon.BringUp();
		NewWeapon.GiveAmmo(PlayerPawn);
		NewWeapon.SetSwitchPriority(PlayerPawn);
		NewWeapon.WeaponSet(PlayerPawn);
	}
}

function NavigationPoint FindPlayerStart (byte Team, optional string incomingName)
{
	local PlayerStart Dest;
	local Teleporter Tel;

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
		if ( Dest.bSinglePlayerStart && Dest.bEnabled )
		{
			return Dest;
		}
	}
	Log("WARNING: All single player starts were disabled - picking one anyway!");
	foreach AllActors(Class'PlayerStart',Dest)
	{
		if ( Dest.bSinglePlayerStart )
		{
			return Dest;
		}
	}
	Log("No single player start found");
	return None;
}

function bool RestartPlayer (Pawn aPlayer)
{
	local NavigationPoint StartSpot;
	local bool foundStart;

	if ( bRestartLevel && (Level.NetMode != 1) && (Level.NetMode != 2) )
	{
		return True;
	}
	StartSpot=FindPlayerStart(aPlayer.PlayerReplicationInfo.Team);
	if ( StartSpot == None )
	{
		return False;
	}
	foundStart=aPlayer.SetLocation(StartSpot.Location);
	if ( foundStart )
	{
		StartSpot.PlayTeleportEffect(aPlayer,True);
		aPlayer.SetRotation(StartSpot.Rotation);
		aPlayer.ViewRotation=aPlayer.Rotation;
		aPlayer.Acceleration=vect(0.00,0.00,0.00);
		aPlayer.Velocity=vect(0.00,0.00,0.00);
		aPlayer.Health=aPlayer.Default.Health;
		aPlayer.SetCollision(True,True,True);
		aPlayer.ClientSetLocation(StartSpot.Location,StartSpot.Rotation);
		aPlayer.bHidden=False;
		aPlayer.DamageScaling=aPlayer.Default.DamageScaling;
		aPlayer.SoundDampening=aPlayer.Default.SoundDampening;
		AddDefaultInventory(aPlayer);
	}
	return foundStart;
}

function StartPlayer (PlayerPawn Other)
{
	if ( (Level.NetMode == 1) || (Level.NetMode == 2) ||  !bRestartLevel )
	{
		Other.GotoState('PlayerWalking');
	}
	else
	{
		Other.ClientTravel("?restart",2,False);
	}
}

function Killed (Pawn Killer, Pawn Other, name DamageType)
{
	local string Killed;
	local string Message;
	local string KillerWeaponName;
	local string VictimWeaponName;
	local string DeathMessage;

	if ( Other.bIsPlayer )
	{
		if ( (Killer == Other) || (Killer == None) )
		{
			if ( LocalLog != None )
			{
				LocalLog.LogSuicide(Other,DamageType);
			}
			if ( WorldLog != None )
			{
				WorldLog.LogSuicide(Other,DamageType);
			}
			Message=KillMessage(DamageType,Other);
			BroadcastMessage(Other.PlayerReplicationInfo.PlayerName $ Message,False,'DeathMessage');
		}
		else
		{
			if ( Killer.Weapon != None )
			{
				KillerWeaponName=Killer.Weapon.ItemName;
				DeathMessage=Killer.Weapon.DeathMessage;
			}
			if ( Other.Weapon != None )
			{
				VictimWeaponName=Other.Weapon.ItemName;
			}
			if ( LocalLog != None )
			{
				LocalLog.LogKill(Killer.PlayerReplicationInfo.PlayerID,Other.PlayerReplicationInfo.PlayerID,KillerWeaponName,VictimWeaponName,DamageType);
			}
			if ( WorldLog != None )
			{
				WorldLog.LogKill(Killer.PlayerReplicationInfo.PlayerID,Other.PlayerReplicationInfo.PlayerID,KillerWeaponName,VictimWeaponName,DamageType);
			}
			Killed=Other.PlayerReplicationInfo.PlayerName;
			if ( (DamageType == 'SpecialDamage') && (SpecialDamageString != "") )
			{
				Message=ParseKillMessage(Killer.PlayerReplicationInfo.PlayerName,Other.PlayerReplicationInfo.PlayerName,KillerWeaponName,SpecialDamageString);
				BroadcastMessage(Message,False,'DeathMessage');
			}
			else
			{
				if ( bClassicDeathmessages || (Killer.Weapon == None) || (DamageType != Killer.Weapon.MyDamageType) && (DamageType != Killer.Weapon.AltDamageType) )
				{
					Message=Killer.KillMessage(DamageType,Other);
					BroadcastMessage(Killed $ Message,False,'DeathMessage');
				}
				else
				{
					Message=ParseKillMessage(Killer.PlayerReplicationInfo.PlayerName,Other.PlayerReplicationInfo.PlayerName,KillerWeaponName,DeathMessage);
					BroadcastMessage(Message,False,'DeathMessage');
				}
			}
		}
	}
	ScoreKill(Killer,Other);
}

native function string ParseKillMessage (string KillerName, string VictimName, string WeaponName, string DeathMessage);

function ScoreKill (Pawn Killer, Pawn Other)
{
	Other.DieCount++;
	if ( (Killer == Other) || (Killer == None) )
	{
		Other.PlayerReplicationInfo.Score -= 1;
	}
	else
	{
		if ( Killer != None )
		{
			Killer.KillCount++;
			if ( Killer.PlayerReplicationInfo != None )
			{
				Killer.PlayerReplicationInfo.Score += 1;
			}
		}
	}
}

function string KillMessage (name DamageType, Pawn Other)
{
	return " died.";
}

function bool CanSpectate (Pawn Viewer, Actor ViewTarget)
{
	return True;
}

function int ReduceDamage (int Damage, name DamageType, Pawn injured, Pawn instigatedBy)
{
	if ( injured.Region.Zone.bNeutralZone )
	{
		return 0;
	}
	return Damage;
}

function ScoreEvent (name EventName, Actor EventActor, Pawn instigatedBy)
{
}

function bool ShouldRespawn (Actor Other)
{
	if ( Level.NetMode == 0 )
	{
		return False;
	}
	return (Inventory(Other) != None) && (Inventory(Other).RespawnTime != 0.00);
}

function bool PickupQuery (Pawn Other, Inventory Item)
{
	if ( Other.Inventory == None )
	{
		return True;
	}
	else
	{
		return  !Other.Inventory.HandlePickupQuery(Item);
	}
}

function DiscardInventory (Pawn Other)
{
	local Actor dropped;
	local Inventory Inv;
	local Weapon weap;
	local float speed;

	if ( Other.DropWhenKilled != None )
	{
		dropped=Spawn(Other.DropWhenKilled,,,Other.Location);
		Inv=Inventory(dropped);
		if ( Inv != None )
		{
			Inv.RespawnTime=0.00;
			Inv.BecomePickup();
		}
		if ( dropped != None )
		{
			dropped.RemoteRole=1;
			dropped.SetPhysics(2);
			dropped.bCollideWorld=True;
			dropped.Velocity=Other.Velocity + VRand() * 280;
		}
		if ( Inv != None )
		{
			Inv.GotoState('Pickup','dropped');
		}
	}
	if ( (Other.Weapon != None) && (Other.Weapon.Class != DefaultWeapon) && Other.Weapon.bCanThrow )
	{
		speed=VSize(Other.Velocity);
		weap=Other.Weapon;
		weap.Velocity=Normal(Other.Velocity / speed + 0.50 * VRand()) * (speed + 280);
		Other.TossWeapon();
		if ( weap.PickupAmmoCount == 0 )
		{
			weap.PickupAmmoCount=1;
		}
	}
	Other.Weapon=None;
	Other.SelectedItem=None;
	Inv=Other.Inventory;
JL0222:
	if ( Inv != None )
	{
		Inv.Destroy();
		Inv=Inv.Inventory;
		goto JL0222;
	}
}

function float PlayerJumpZScaling ()
{
	return 1.00;
}

function ChangeName (Pawn Other, coerce string S, bool bNameChange)
{
	if ( S == "" )
	{
		return;
	}
	Other.PlayerReplicationInfo.PlayerName=S;
	if ( bNameChange )
	{
		Other.ClientMessage(NameChangedMessage $ Other.PlayerReplicationInfo.PlayerName);
	}
}

function bool ChangeTeam (Pawn Other, int N)
{
	Other.PlayerReplicationInfo.Team=N;
	return True;
}

function float PlaySpawnEffect (Inventory Inv)
{
	return 0.30;
}

function string PlayerKillMessage (name DamageType, Pawn Other)
{
	local string Message;

	Message=" was killed by ";
	return Message;
}

function string CreatureKillMessage (name DamageType, Pawn Other)
{
	return " was killed by a ";
}

function SendPlayer (PlayerPawn aPlayer, string URL)
{
	aPlayer.ClientTravel(URL,2,True);
}

function PlayTeleportEffect (Actor Incoming, bool bOut, bool bSound);

function RestartGame ()
{
	Level.ServerTravel("?Restart",False);
}

function bool AllowsBroadcast (Actor broadcaster, int Len)
{
	SentText += Len;
	return SentText < 260;
}

function EndGame (string Reason)
{
	local Actor A;

	if (  !SetEndCams(Reason) )
	{
		bOverTime=True;
		return;
	}
	bGameEnded=True;
	foreach AllActors(Class'Actor',A,'EndGame')
	{
		A.Trigger(self,None);
	}
	if ( LocalLog != None )
	{
		LocalLog.LogGameEnd(Reason);
		LocalLog.StopLog();
		LocalLog.Destroy();
		LocalLog=None;
		ExecuteLocalLogBatcher();
	}
	if ( WorldLog != None )
	{
		WorldLog.LogGameEnd(Reason);
		WorldLog.StopLog();
		WorldLog.Destroy();
		WorldLog=None;
		ExecuteWorldLogBatcher();
	}
}

function bool SetEndCams (string Reason)
{
	local Pawn aPawn;

	aPawn=Level.PawnList;
JL0014:
	if ( aPawn != None )
	{
		if ( aPawn.bIsPlayer )
		{
			aPawn.GotoState('GameEnded');
			aPawn.ClientGameEnded();
		}
		aPawn=aPawn.nextPawn;
		goto JL0014;
	}
	return True;
}

defaultproperties
{
    Difficulty=1
    bRestartLevel=True
    bPauseable=True
    bCanChangeSkin=True
    bNoCheating=True
    AutoAim=0.93
    GameSpeed=1.00
    MaxSpectators=2
    BotMenuType="UMenu.UMenuBotConfigSClient"
    RulesMenuType="UMenu.UMenuGameRulesSClient"
    SettingsMenuType="UMenu.UMenuGameSettingsSClient"
    GameUMenuType="UMenu.UMenuGameMenu"
    MultiplayerUMenuType="UMenu.UMenuMultiplayerMenu"
    GameOptionsMenuType="UMenu.UMenuOptionsMenu"
    SwitchLevelMessage="Switching Levels"
    DefaultPlayerName="Player"
    LeftMessage=" left the game."
    FailedSpawnMessage="Failed to spawn player actor"
    FailedPlaceMessage="Could not find starting spot (level might need a 'PlayerStart' actor)"
    FailedTeamMessage="Could not find team for player"
    NameChangedMessage="Name changed to "
    EnteredMessage=" entered the game."
    GameName="Game"
    MaxedOutMessage="Server is already at capacity."
    WrongPassword="The password you entered is incorrect."
    NeedPassword="You need to enter a password to join this game."
    MaxPlayers=16
    MutatorClass=Class'Mutator'
    DefaultPlayerState=PlayerWalking
    ServerLogName="server.log"
    bLocalLogQuery=True
    LocalBatcherURL="..\NetGamesUSA.com\ngStats\ngStatsUT.exe"
    LocalStatsURL="..\NetGamesUSA.com\ngStats\html\ngStats_Main.html"
    WorldBatcherURL="..\NetGamesUSA.com\ngWorldStats\bin\ngWorldStats.exe"
    WorldBatcherParams="-d ..\NetGamesUSA.com\ngWorldStats\logs"
    WorldStatsURL="http://www.netgamesusa.com"
}