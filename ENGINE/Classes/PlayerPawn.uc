//================================================================================
// PlayerPawn.
//================================================================================
class PlayerPawn expands Pawn
	native
	config(User);

var const Player Player;
var globalconfig string Password;
var travel float DodgeClickTimer;
var(Movement) globalconfig float DodgeClickTime;
var(Movement) globalconfig float Bob;
var float bobtime;
var int ShowFlags;
var int RendMap;
var int Misc1;
var int Misc2;
var Actor ViewTarget;
var Vector FlashScale;
var Vector FlashFog;
var HUD myHUD;
var ScoreBoard Scoring;
var Class<HUD> HUDType;
var Class<ScoreBoard> ScoringType;
var float DesiredFlashScale;
var float ConstantGlowScale;
var float InstantFlash;
var Vector DesiredFlashFog;
var Vector ConstantGlowFog;
var Vector InstantFog;
var float DesiredFOV;
var float DefaultFOV;
var Music Song;
var byte SongSection;
var byte CdTrack;
var EMusicTransition Transition;
var float shaketimer;
var int shakemag;
var float shakevert;
var float maxshake;
var float verttimer;
var(Pawn) Class<Carcass> CarcassType;
var travel globalconfig float MyAutoAim;
var travel globalconfig float Handedness;
var(Sounds) Sound JumpSound;
var bool bAdmin;
var() globalconfig bool bLookUpStairs;
var() globalconfig bool bSnapToLevel;
var() globalconfig bool bAlwaysMouseLook;
var globalconfig bool bKeyboardLook;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var bool bIsCrouching;
var bool bShakeDir;
var bool bAnimTransition;
var bool bIsTurning;
var bool bFrozen;
var globalconfig bool bInvertMouse;
var bool bShowScores;
var bool bShowMenu;
var bool bSpecialMenu;
var bool bWokeUp;
var bool bPressedJump;
var bool bUpdatePosition;
var bool bDelayedCommand;
var bool bRising;
var bool bReducedVis;
var bool bCenterView;
var() globalconfig bool bMaxMouseSmoothing;
var bool bMouseZeroed;
var bool bReadyToPlay;
var globalconfig bool bNoFlash;
var globalconfig bool bNoVoices;
var globalconfig bool bMessageBeep;
var bool bZooming;
var() bool bSinglePlayer;
var bool bJustFired;
var bool bJustAltFired;
var bool bIsTyping;
var bool bFixedCamera;
var float ZoomLevel;
var Class<Menu> SpecialMenu;
var string DelayedCommand;
var globalconfig float MouseSensitivity;
var globalconfig name WeaponPriority[20];
var globalconfig int NetSpeed;
var globalconfig int LanSpeed;
var float SmoothMouseX;
var float SmoothMouseY;
var float KbdAccel;
var() globalconfig float MouseSmoothThreshold;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var input float aExtra4;
var input float aExtra3;
var input float aExtra2;
var input float aExtra1;
var input float aExtra0;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float MaxTimeMargin;
var string ProgressMessage[5];
var Color ProgressColor[5];
var float ProgressTimeOut;
var localized string QuickSaveString;
var localized string NoPauseMessage;
var localized string ViewingFrom;
var localized string OwnCamera;
var localized string FailedView;
var localized string CantChangeNameMsg;
var GameReplicationInfo GameReplicationInfo;
var() globalconfig string ngWorldSecret;
var Rotator TargetViewRotation;
var float TargetEyeHeight;
var Vector TargetWeaponViewOffset;

replication
{
	reliable if ( Role < 4 )
		ServerUpdateWeapons,ServerSetWeaponPriority,RememberSpot,ShowPath,Summon,KillAll,ServerSetSloMo,God,ShowInventory,ServerAddBots,SwitchCoopLevel,SwitchLevel,NeverSwitchOnPickup,ViewClass,ViewSelf,ViewPlayer,PlayersOnly,ChangeTeam,ChangeName,Suicide,ActivateItem,PrevItem,SwitchWeapon,ActivateTranslator,Pause,SetPause,Kick,NextWeapon,PrevWeapon,ThrowWeapon,RestartLevel,TeamSay,Say,Typing,Speech,Grab,ServerTaunt,ServerChangeSkin,ServerReStartPlayer,ServerSetHandedness,ServerFeignDeath,ServerReStartGame,Admin,ViewPlayerNum;
	unreliable if ( Role == 3 )
		Ghost,Walk,Fly,ServerMove;
	reliable if ( Role == 4 )
		SetProgressTime,SetProgressColor,SetProgressMessage,ClearProgressMessages,SetDesiredFOV,EndZoom,StopZoom,StartZoom,ToggleZoom,ClientSetMusic,ClientAdjustGlow,ClientTravel;
	unreliable if ( Role < 4 )
		CallForHelp;
	unreliable if ( Role == 4 )
		ClientShake,ClientInstantFlash,ClientFlash,SetFOVAngle;
	unreliable if ( (Role == 4) &&  !bDemoRecording )
		ClientPlaySound;
	unreliable if ( (Role == 4) && (RemoteRole == 3) )
		ClientAdjustPosition;
	un?reliable if ( Role < 4 )
		Password,bReadyToPlay,WeaponPriority;
	un?reliable if ( (Role == 4) && bNetOwner )
		ViewTarget,HUDType,ScoringType,bFixedCamera,GameReplicationInfo;
	un?reliable if ( Role < 3 )
		aBaseX,aBaseY,aBaseZ,aMouseX,aMouseY,aForward,aTurn,aStrafe,aUp,aLookUp,aExtra4,aExtra3,aExtra2,aExtra1,aExtra0;
	un?reliable if ( (Role == 4) && bNetOwner )
		TargetViewRotation,TargetEyeHeight,TargetWeaponViewOffset;
}

native event ClientTravel (string URL, ETravelType TravelType, bool bItems);

native(544) final function ResetKeyboard ();

native(546) final function UpdateURL (string NewOption, string NewValue, bool bSaveDefault);

native final function LevelInfo GetEntryLevel ();

native function string ConsoleCommand (string Command);

event PreClientTravel ()
{
}

exec function Ping ()
{
	ClientMessage("Current ping is" @ string(PlayerReplicationInfo.Ping));
}

simulated event RenderOverlays (Canvas Canvas)
{
	if ( Weapon != None )
	{
		Weapon.RenderOverlays(Canvas);
	}
	if ( myHUD != None )
	{
		myHUD.RenderOverlays(Canvas);
	}
}

exec function ViewPlayerNum (optional int Num)
{
	local Pawn P;

	if ( Num >= 0 )
	{
		P=Pawn(ViewTarget);
		if ( (P != None) && P.bIsPlayer && (P.PlayerReplicationInfo.TeamID == Num) )
		{
			ViewTarget=None;
			bBehindView=False;
			return;
		}
		P=Level.PawnList;
JL0082:
		if ( P != None )
		{
			if ( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) && (P.PlayerReplicationInfo.TeamID == Num) )
			{
				if ( P != self )
				{
					ViewTarget=P;
					bBehindView=True;
				}
				return;
			}
			P=P.nextPawn;
			goto JL0082;
		}
		return;
	}
	if ( Role == 4 )
	{
		ViewClass(Class'Pawn');
JL0142:
		if ( (ViewTarget != None) && ( !Pawn(ViewTarget).bIsPlayer || Pawn(ViewTarget).PlayerReplicationInfo.bIsSpectator) )
		{
			ViewClass(Class'Pawn',True);
			goto JL0142;
		}
		if ( ViewTarget != None )
		{
			ClientMessage(ViewingFrom $ Pawn(ViewTarget).PlayerReplicationInfo.PlayerName,'Event',True);
		}
		else
		{
			ClientMessage(ViewingFrom $ OwnCamera,'Event',True);
		}
	}
}

exec function Profile ()
{
	Log("Average AI Time" @ string(Level.AvgAITime));
	Log(" < 5% " $ string(Level.AIProfile[0]));
	Log(" < 10% " $ string(Level.AIProfile[1]));
	Log(" < 15% " $ string(Level.AIProfile[2]));
	Log(" < 20% " $ string(Level.AIProfile[3]));
	Log(" < 25% " $ string(Level.AIProfile[4]));
	Log(" < 30% " $ string(Level.AIProfile[5]));
	Log(" < 35% " $ string(Level.AIProfile[6]));
	Log(" > 35% " $ string(Level.AIProfile[7]));
}

exec function Admin (string CommandLine)
{
	local string Result;

	if ( bAdmin )
	{
		Result=ConsoleCommand(CommandLine);
	}
	if ( Result != "" )
	{
		ClientMessage(Result);
	}
}

exec function PlayerList ()
{
	local PlayerReplicationInfo PRI;

	Log("Player List:");
	foreach AllActors(Class'PlayerReplicationInfo',PRI)
	{
		Log(PRI.PlayerName @ "( ping" @ string(PRI.Ping) $ ")");
	}
}

event ClientMessage (coerce string S, optional name Type, optional bool bBeep)
{
	if ( Player == None )
	{
		return;
	}
	if ( Type == 'None' )
	{
		Type='Event';
	}
	if ( Player.Console != None )
	{
		Player.Console.Message(PlayerReplicationInfo,S,Type);
	}
	if ( bBeep && bMessageBeep )
	{
		PlayBeepSound();
	}
	if ( myHUD != None )
	{
		myHUD.Message(PlayerReplicationInfo,S,Type);
	}
}

event TeamMessage (PlayerReplicationInfo PRI, coerce string S, name Type)
{
	if ( Player.Console != None )
	{
		Player.Console.Message(PRI,S,Type);
	}
	if ( bMessageBeep )
	{
		PlayBeepSound();
	}
	if ( myHUD != None )
	{
		myHUD.Message(PRI,S,Type);
	}
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	local VoicePack V;

	if ( (Sender.VoiceType == None) || (Player.Console == None) )
	{
		return;
	}
	V=Spawn(Sender.VoiceType,self);
	if ( V != None )
	{
		V.ClientInitialize(Sender,Recipient,messagetype,messageID);
	}
}

simulated function PlayBeepSound ();

function ServerMove (float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbPressedJump, bool bFired, bool bAltFired, EDodgeDir DodgeMove, byte ClientRoll, int View)
{
	local float DeltaTime;
	local float clientErr;
	local Rotator DeltaRot;
	local Rotator Rot;
	local Vector Accel;
	local Vector LocDiff;
	local int maxPitch;
	local int ViewPitch;
	local int ViewYaw;
	local Actor OldBase;

	ViewPitch=View / 32768;
	ViewYaw=2 * (View - 32768 * ViewPitch);
	ViewPitch *= 2;
	Accel=InAccel / 10;
	if ( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}
	if ( bFired )
	{
		if ( bFire == 0 )
		{
			Fire(0.00);
			bFire=1;
		}
	}
	else
	{
		bFire=0;
	}
	if ( bAltFired )
	{
		if ( bAltFire == 0 )
		{
			AltFire(0.00);
			bAltFire=1;
		}
	}
	else
	{
		bAltFire=0;
	}
	DeltaTime=TimeStamp - CurrentTimeStamp;
	if ( ServerTimeStamp > 0 )
	{
		TimeMargin += DeltaTime - Level.TimeSeconds - ServerTimeStamp;
		if ( TimeMargin > MaxTimeMargin )
		{
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.50 )
			{
				MaxTimeMargin=1.00;
			}
			else
			{
				MaxTimeMargin=0.50;
			}
			DeltaTime=0.00;
		}
	}
	CurrentTimeStamp=TimeStamp;
	ServerTimeStamp=Level.TimeSeconds;
	Rot.Roll=256 * ClientRoll;
	Rot.Yaw=ViewYaw;
	if ( (Physics == 3) || (Physics == 4) )
	{
		maxPitch=2;
	}
	else
	{
		maxPitch=1;
	}
	if ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		if ( ViewPitch < 32768 )
		{
			Rot.Pitch=maxPitch * RotationRate.Pitch;
		}
		else
		{
			Rot.Pitch=65536 - maxPitch * RotationRate.Pitch;
		}
	}
	else
	{
		Rot.Pitch=ViewPitch;
	}
	DeltaRot=Rotation - Rot;
	ViewRotation.Pitch=ViewPitch;
	ViewRotation.Yaw=ViewYaw;
	ViewRotation.Roll=0;
	SetRotation(Rot);
	OldBase=Base;
	if ( (Level.Pauser == "") && (DeltaTime > 0) )
	{
		MoveAutonomous(DeltaTime,NewbRun,NewbDuck,NewbPressedJump,DodgeMove,Accel,DeltaRot);
	}
	if ( Level.TimeSeconds - LastUpdateTime > 0.30 )
	{
		clientErr=10000.00;
	}
	else
	{
		if ( Level.TimeSeconds - LastUpdateTime > 0.07 )
		{
			LocDiff=Location - ClientLoc;
			clientErr=LocDiff Dot LocDiff;
		}
	}
	if ( clientErr > 3 )
	{
		if ( Mover(Base) != None )
		{
			ClientLoc=Location - Base.Location;
		}
		else
		{
			ClientLoc=Location;
		}
		LastUpdateTime=Level.TimeSeconds;
		ClientAdjustPosition(TimeStamp,GetStateName(),Physics,ClientLoc.X,ClientLoc.Y,ClientLoc.Z,Velocity.X,Velocity.Y,Velocity.Z,Base);
	}
}

function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
{
	Acceleration=newAccel;
}

final function MoveAutonomous (float DeltaTime, bool NewbRun, bool NewbDuck, bool NewbPressedJump, EDodgeDir DodgeMove, Vector newAccel, Rotator DeltaRot)
{
	if ( NewbRun )
	{
		bRun=1;
	}
	else
	{
		bRun=0;
	}
	if ( NewbDuck )
	{
		bDuck=1;
	}
	else
	{
		bDuck=0;
	}
	bPressedJump=NewbPressedJump;
	HandleWalking();
	ProcessMove(DeltaTime,newAccel,DodgeMove,DeltaRot);
	AutonomousPhysics(DeltaTime);
}

function ClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local Decoration Carried;
	local Vector OldLoc;
	local Vector NewLocation;

	if ( CurrentTimeStamp > TimeStamp )
	{
		return;
	}
	CurrentTimeStamp=TimeStamp;
	NewLocation.X=NewLocX;
	NewLocation.Y=NewLocY;
	NewLocation.Z=NewLocZ;
	Velocity.X=NewVelX;
	Velocity.Y=NewVelY;
	Velocity.Z=NewVelZ;
	SetBase(NewBase);
	if ( Mover(NewBase) != None )
	{
		NewLocation += NewBase.Location;
	}
	Carried=carriedDecoration;
	OldLoc=Location;
	SetLocation(NewLocation);
	if ( Carried != None )
	{
		carriedDecoration=Carried;
		carriedDecoration.SetLocation(NewLocation + carriedDecoration.Location - OldLoc);
		carriedDecoration.SetPhysics(0);
		carriedDecoration.SetBase(self);
	}
	SetPhysics(newPhysics);
	if (  !IsInState(NewState) )
	{
		GotoState(NewState);
	}
	bUpdatePosition=True;
}

function ClientUpdatePosition ()
{
	local SavedMove CurrentMove;
	local int realbRun;
	local int realbDuck;
	local bool bRealJump;

	bUpdatePosition=False;
	realbRun=bRun;
	realbDuck=bDuck;
	bRealJump=bPressedJump;
	CurrentMove=SavedMoves;
JL0038:
	if ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves=CurrentMove.NextMove;
			CurrentMove.NextMove=FreeMoves;
			FreeMoves=CurrentMove;
			FreeMoves.Clear();
			CurrentMove=SavedMoves;
		}
		else
		{
			MoveAutonomous(CurrentMove.Delta,CurrentMove.bRun,CurrentMove.bDuck,CurrentMove.bPressedJump,CurrentMove.DodgeMove,CurrentMove.Acceleration,rot(0,0,0));
			CurrentMove=CurrentMove.NextMove;
		}
		goto JL0038;
	}
	bDuck=realbDuck;
	bRun=realbRun;
	bPressedJump=bRealJump;
}

final function SavedMove GetFreeMove ()
{
	local SavedMove S;

	if ( FreeMoves == None )
	{
		return Spawn(Class'SavedMove');
	}
	else
	{
		S=FreeMoves;
		FreeMoves=FreeMoves.NextMove;
		S.NextMove=None;
		return S;
	}
}

final function ReplicateMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
{
	local SavedMove NewMove;
	local byte ClientRoll;
	local int i;

	if ( (PlayerReplicationInfo != None) && (PlayerReplicationInfo.HasFlag != None) )
	{
		PlayerReplicationInfo.HasFlag.FollowHolder(self);
	}
	if ( SavedMoves == None )
	{
		SavedMoves=GetFreeMove();
		NewMove=SavedMoves;
	}
	else
	{
		NewMove=SavedMoves;
JL006A:
		if ( NewMove.NextMove != None )
		{
			NewMove=NewMove.NextMove;
			goto JL006A;
		}
		if ( NewMove.bSent )
		{
			NewMove.NextMove=GetFreeMove();
			NewMove=NewMove.NextMove;
		}
	}
	NewMove.Delta=DeltaTime;
	if ( VSize(newAccel) > 3072 )
	{
		newAccel=3072 * Normal(newAccel);
	}
	NewMove.Acceleration=newAccel;
	NewMove.DodgeMove=DodgeMove;
	NewMove.TimeStamp=Level.TimeSeconds;
	NewMove.bRun=bRun > 0;
	NewMove.bDuck=bDuck > 0;
	NewMove.bPressedJump=bPressedJump;
	if ( Weapon != None )
	{
		Weapon.bPointing=(bFire != 0) || (bAltFire != 0);
	}
	ProcessMove(DeltaTime,newAccel,DodgeMove,DeltaRot);
	AutonomousPhysics(DeltaTime);
	NewMove.bSent=True;
	ClientRoll=Rotation.Roll >> 8 & 255;
	ServerMove(NewMove.TimeStamp,NewMove.Acceleration * 10,Location,NewMove.bRun,NewMove.bDuck,NewMove.bPressedJump,bJustFired || (bFire != 0),bJustAltFired || (bAltFire != 0),NewMove.DodgeMove,ClientRoll,(32767 & ViewRotation.Pitch / 2) * 32768 + (32767 & ViewRotation.Yaw / 2));
	bJustFired=False;
	bJustAltFired=False;
}

function HandleWalking ()
{
	local Rotator Carried;

	bIsWalking=((bRun != 0) || (bDuck != 0)) &&  !Region.Zone.IsA('WarpZoneInfo');
	if ( (Role == 4) && (StandingCount == 0) )
	{
		carriedDecoration=None;
	}
	if ( carriedDecoration != None )
	{
		bIsWalking=True;
		if ( Role == 4 )
		{
			Carried=rotator(carriedDecoration.Location - Location);
			Carried.Yaw=(Carried.Yaw & 65535) - (Rotation.Yaw & 65535) & 65535;
			if ( (Carried.Yaw > 3072) && (Carried.Yaw < 62463) )
			{
				DropDecoration();
			}
		}
	}
}

event Destroyed ()
{
	Super.Destroyed();
	if ( myHUD != None )
	{
		myHUD.Destroy();
	}
	if ( Scoring != None )
	{
		Scoring.Destroy();
	}
}

function ServerReStartGame ()
{
	Level.Game.RestartGame();
}

function PlayHit (float Damage, Vector HitLocation, name DamageType, float MomentumZ)
{
	Level.Game.SpecialDamageString="";
}

function SetFOVAngle (float newFOV)
{
	FovAngle=newFOV;
}

function ClientFlash (float Scale, Vector fog)
{
	DesiredFlashScale=Scale;
	DesiredFlashFog=0.00 * fog;
}

function ClientInstantFlash (float Scale, Vector fog)
{
	InstantFlash=Scale;
	InstantFog=0.00 * fog;
}

simulated function ClientPlaySound (Sound ASound)
{
	if ( ViewTarget != None )
	{
		ViewTarget.PlaySound(ASound,0,255.00,True);
	}
	PlaySound(ASound,0,255.00,True);
}

function ClientAdjustGlow (float Scale, Vector fog)
{
	ConstantGlowScale += Scale;
	ConstantGlowFog += 0.00 * fog;
}

function ClientShake (Vector shake)
{
	if ( (shakemag < shake.X) || (shaketimer <= 0.01 * shake.Y) )
	{
		shakemag=shake.X;
		shaketimer=0.01 * shake.Y;
		maxshake=0.01 * shake.Z;
		verttimer=0.00;
		shakevert=-1.10 * maxshake;
	}
}

function ShakeView (float shaketime, float RollMag, float vertmag)
{
	local Vector shake;

	shake.X=RollMag;
	shake.Y=100.00 * shaketime;
	shake.Z=100.00 * vertmag;
	ClientShake(shake);
}

function ClientSetMusic (Music NewSong, byte NewSection, byte NewCdTrack, EMusicTransition NewTransition)
{
	Song=NewSong;
	SongSection=NewSection;
	CdTrack=NewCdTrack;
	Transition=NewTransition;
}

function ServerFeignDeath ()
{
	PendingWeapon=Weapon;
	if ( Weapon != None )
	{
		Weapon.PutDown();
	}
	GotoState('FeigningDeath');
}

function ServerSetHandedness (float hand)
{
	Handedness=hand;
	if ( Weapon != None )
	{
		Weapon.SetHand(Handedness);
	}
}

function ServerReStartPlayer ()
{
	if ( Level.NetMode == 3 )
	{
		return;
	}
	if ( Level.Game.RestartPlayer(self) )
	{
		ServerTimeStamp=0.00;
		TimeMargin=0.00;
		Level.Game.StartPlayer(self);
		PlayWaiting();
		ClientReStart();
	}
	else
	{
		Log("Restartplayer failed");
	}
}

function ServerChangeSkin (coerce string SkinName, coerce string FaceName, byte TeamNum)
{
	local string MeshName;

	MeshName=GetItemName(string(Mesh));
	if ( Level.Game.bCanChangeSkin )
	{
		self.SetMultiSkin(self,SkinName,FaceName,TeamNum);
	}
}

exec function ShowSpecialMenu (string ClassName)
{
	local Class<Menu> aMenuClass;

	aMenuClass=Class<Menu>(DynamicLoadObject(ClassName,Class'Class'));
	if ( aMenuClass != None )
	{
		bSpecialMenu=True;
		SpecialMenu=aMenuClass;
		ShowMenu();
	}
}

exec function Jump (optional float F)
{
	bPressedJump=True;
}

exec function CauseEvent (name N)
{
	local Actor A;

	if ( (bAdmin || (Level.NetMode == 0)) && (N != 'None') )
	{
		foreach AllActors(Class'Actor',A,N)
		{
			A.Trigger(self,self);
		}
	}
}

exec function Taunt (name Sequence)
{
	if ( GetAnimGroup(Sequence) == 'Gesture' )
	{
		ServerTaunt(Sequence);
		PlayAnim(Sequence,0.70,0.20);
	}
}

function ServerTaunt (name Sequence)
{
	PlayAnim(Sequence,0.70,0.20);
}

exec function FeignDeath ()
{
}

exec function CallForHelp ()
{
	local Pawn P;

	if (  !Level.Game.bTeamGame || (Enemy == None) || (Enemy.Health <= 0) )
	{
		return;
	}
	P=Level.PawnList;
JL0056:
	if ( P != None )
	{
		if ( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
		{
			P.HandleHelpMessageFrom(self);
		}
		P=P.nextPawn;
		goto JL0056;
	}
}

function damageAttitudeTo (Pawn Other)
{
	Enemy=Other;
}

exec function Grab ()
{
	if ( carriedDecoration == None )
	{
		GrabDecoration();
	}
	else
	{
		DropDecoration();
	}
}

exec function Speech (int Type, int Index, int Callsign)
{
	local VoicePack V;

	V=Spawn(PlayerReplicationInfo.VoiceType,self);
	if ( V != None )
	{
		V.PlayerSpeech(Type,Index,Callsign);
	}
}

function PlayChatting ();

function Typing (bool bTyping)
{
	bIsTyping=bTyping;
	if ( bTyping )
	{
		if ( Level.Game.WorldLog != None )
		{
			Level.Game.WorldLog.LogTypingEvent(True,self);
		}
		if ( Level.Game.LocalLog != None )
		{
			Level.Game.LocalLog.LogTypingEvent(True,self);
		}
		PlayChatting();
	}
	else
	{
		if ( Level.Game.WorldLog != None )
		{
			Level.Game.WorldLog.LogTypingEvent(False,self);
		}
		if ( Level.Game.LocalLog != None )
		{
			Level.Game.LocalLog.LogTypingEvent(False,self);
		}
	}
}

exec function Say (string Msg)
{
	local Pawn P;

	if ( Level.Game.AllowsBroadcast(self,Len(Msg)) )
	{
		P=Level.PawnList;
JL0037:
		if ( P != None )
		{
			if ( P.bIsPlayer )
			{
				P.TeamMessage(PlayerReplicationInfo,Msg,'Say');
			}
			P=P.nextPawn;
			goto JL0037;
		}
	}
	return;
}

exec function TeamSay (string Msg)
{
	local Pawn P;

	if (  !Level.Game.bTeamGame )
	{
		Say(Msg);
		return;
	}
	if ( Msg ~= "Help" )
	{
		CallForHelp();
		return;
	}
	if ( Level.Game.AllowsBroadcast(self,Len(Msg)) )
	{
		P=Level.PawnList;
JL0079:
		if ( P != None )
		{
			if ( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
			{
				if ( P.IsA('PlayerPawn') )
				{
					P.TeamMessage(PlayerReplicationInfo,Msg,'TeamSay');
				}
			}
			P=P.nextPawn;
			goto JL0079;
		}
	}
}

exec function RestartLevel ()
{
	if ( bAdmin || (Level.NetMode == 0) )
	{
		ClientTravel("?restart",2,False);
	}
}

exec function LocalTravel (string URL)
{
	if ( bAdmin || (Level.NetMode == 0) )
	{
		ClientTravel(URL,2,True);
	}
}

exec function ThrowWeapon ()
{
	if ( Level.NetMode == 3 )
	{
		return;
	}
	if ( (Weapon == None) || (Weapon.Class == Level.Game.DefaultWeapon) ||  !Weapon.bCanThrow )
	{
		return;
	}
	Weapon.Velocity=vector(ViewRotation) * 500 + vect(0.00,0.00,220.00);
	Weapon.bTossedOut=True;
	TossWeapon();
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
	}
}

function ToggleZoom ()
{
	if ( DefaultFOV != DesiredFOV )
	{
		EndZoom();
	}
	else
	{
		StartZoom();
	}
}

function StartZoom ()
{
	ZoomLevel=0.00;
	bZooming=True;
}

function StopZoom ()
{
	bZooming=False;
}

function EndZoom ()
{
	bZooming=False;
	DesiredFOV=DefaultFOV;
}

exec function FOV (float F)
{
	SetDesiredFOV(F);
}

exec function SetDesiredFOV (float F)
{
	if (  !Level.bNoCheating || bAdmin || (Level.NetMode == 0) )
	{
		DefaultFOV=FClamp(F,1.00,170.00);
		DesiredFOV=DefaultFOV;
	}
}

exec function PrevWeapon ()
{
	local int prevGroup;
	local Inventory Inv;
	local Weapon realWeapon;
	local Weapon W;
	local Weapon Prev;
	local bool bFoundWeapon;

	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	prevGroup=0;
	realWeapon=Weapon;
	if ( PendingWeapon != None )
	{
		Weapon=PendingWeapon;
	}
	PendingWeapon=None;
	Inv=Inventory;
JL006F:
	if ( Inv != None )
	{
		W=Weapon(Inv);
		if ( W != None )
		{
			if ( W.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( W == Weapon )
				{
					bFoundWeapon=True;
					if ( Prev != None )
					{
						PendingWeapon=Prev;
					}
					else
					{
						goto JL0136;
						if (  !bFoundWeapon && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
						{
							Prev=W;
						}
JL0136:
						goto JL01CC;
						if ( (W.InventoryGroup < Weapon.InventoryGroup) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) && (W.InventoryGroup >= prevGroup) )
						{
							prevGroup=W.InventoryGroup;
							PendingWeapon=W;
						}
JL01CC:
						Inv=Inv.Inventory;
						goto JL006F;
					}
				}
			}
		}
	}
	bFoundWeapon=False;
	prevGroup=Weapon.InventoryGroup;
	if ( PendingWeapon == None )
	{
		Inv=Inventory;
JL0216:
		if ( Inv != None )
		{
			W=Weapon(Inv);
			if ( W != None )
			{
				if ( W.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( W == Weapon )
					{
						bFoundWeapon=True;
					}
					else
					{
						if ( bFoundWeapon && (PendingWeapon == None) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
						{
							PendingWeapon=W;
						}
					}
				}
				else
				{
					if ( (W.InventoryGroup > prevGroup) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
					{
						prevGroup=W.InventoryGroup;
						PendingWeapon=W;
					}
				}
			}
			Inv=Inv.Inventory;
			goto JL0216;
		}
	}
	Weapon=realWeapon;
	if ( PendingWeapon == None )
	{
		return;
	}
	if ( Weapon != PendingWeapon )
	{
		Weapon.PutDown();
	}
}

exec function NextWeapon ()
{
	local int nextGroup;
	local Inventory Inv;
	local Weapon realWeapon;
	local Weapon W;
	local Weapon Prev;
	local bool bFoundWeapon;

	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	nextGroup=100;
	realWeapon=Weapon;
	if ( PendingWeapon != None )
	{
		Weapon=PendingWeapon;
	}
	PendingWeapon=None;
	Inv=Inventory;
JL0070:
	if ( Inv != None )
	{
		W=Weapon(Inv);
		if ( W != None )
		{
			if ( W.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( W == Weapon )
				{
					bFoundWeapon=True;
				}
				else
				{
					if ( bFoundWeapon && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
					{
						PendingWeapon=W;
					}
					else
					{
						goto JL01B5;
						if ( (W.InventoryGroup > Weapon.InventoryGroup) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) && (W.InventoryGroup < nextGroup) )
						{
							nextGroup=W.InventoryGroup;
							PendingWeapon=W;
						}
JL01B5:
						Inv=Inv.Inventory;
						goto JL0070;
					}
				}
			}
		}
	}
	bFoundWeapon=False;
	nextGroup=Weapon.InventoryGroup;
	if ( PendingWeapon == None )
	{
		Inv=Inventory;
JL01FF:
		if ( Inv != None )
		{
			W=Weapon(Inv);
			if ( W != None )
			{
				if ( W.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( W == Weapon )
					{
						bFoundWeapon=True;
						if ( Prev != None )
						{
							PendingWeapon=Prev;
						}
					}
					else
					{
						if (  !bFoundWeapon && (PendingWeapon == None) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
						{
							Prev=W;
						}
					}
				}
				else
				{
					if ( (W.InventoryGroup < nextGroup) && ((W.AmmoType == None) || (W.AmmoType.AmmoAmount > 0)) )
					{
						nextGroup=W.InventoryGroup;
						PendingWeapon=W;
					}
				}
			}
			Inv=Inv.Inventory;
			goto JL01FF;
		}
	}
	Weapon=realWeapon;
	if ( PendingWeapon == None )
	{
		return;
	}
	if ( Weapon != PendingWeapon )
	{
		Weapon.PutDown();
	}
}

exec function QuickSave ()
{
	if ( (Health > 0) && (Level.NetMode == 0) &&  !Level.Game.bDeathMatch )
	{
		ClientMessage(QuickSaveString);
		ConsoleCommand("SaveGame 9");
	}
}

exec function QuickLoad ()
{
	if ( (Level.NetMode == 0) &&  !Level.Game.bDeathMatch )
	{
		ClientTravel("?load=9",0,False);
	}
}

exec function Kick (string S)
{
	local Pawn aPawn;

	if (  !bAdmin )
	{
		return;
	}
	aPawn=Level.PawnList;
JL0021:
	if ( aPawn != None )
	{
		if ( aPawn.bIsPlayer && (aPawn.PlayerReplicationInfo.PlayerName ~= S) && ((PlayerPawn(aPawn) == None) || (NetConnection(PlayerPawn(aPawn).Player) != None)) )
		{
			aPawn.Destroy();
			return;
		}
		aPawn=aPawn.nextPawn;
		goto JL0021;
	}
}

function bool SetPause (bool bPause)
{
	return Level.Game.SetPause(bPause,self);
}

exec function SetMouseSmoothThreshold (float F)
{
	MouseSmoothThreshold=FClamp(F,0.00,1.00);
	SaveConfig();
}

exec function SetMaxMouseSmoothing (bool B)
{
	bMaxMouseSmoothing=B;
	SaveConfig();
}

exec function Pause ()
{
	if ( bShowMenu )
	{
		return;
	}
	if (  !SetPause(Level.Pauser == "") )
	{
		ClientMessage(NoPauseMessage);
	}
}

exec function ActivateInventoryItem (Class InvItem)
{
	local Inventory Inv;

	Inv=FindInventoryType(InvItem);
	if ( Inv != None )
	{
		Inv.Activate();
	}
}

exec function ActivateTranslator ()
{
	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( Inventory != None )
	{
		Inventory.ActivateTranslator(False);
	}
}

exec function ActivateHint ()
{
	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( Inventory != None )
	{
		Inventory.ActivateTranslator(True);
	}
}

exec function ChangeHud ()
{
	if ( myHUD != None )
	{
		myHUD.ChangeHud(1);
	}
	myHUD.SaveConfig();
}

exec function ChangeCrosshair ()
{
	if ( myHUD != None )
	{
		myHUD.ChangeCrosshair(1);
	}
	myHUD.SaveConfig();
}

event PreRender (Canvas Canvas)
{
	if ( myHUD != None )
	{
		myHUD.PreRender(Canvas);
	}
	else
	{
		if ( (Viewport(Player) != None) && (HUDType != None) )
		{
			myHUD=Spawn(HUDType,self);
		}
	}
}

event PostRender (Canvas Canvas)
{
	if ( myHUD != None )
	{
		myHUD.PostRender(Canvas);
	}
	else
	{
		if ( (Viewport(Player) != None) && (HUDType != None) )
		{
			myHUD=Spawn(HUDType,self);
		}
	}
}

exec function FunctionKey (byte Num)
{
}

exec function SwitchWeapon (byte F)
{
	local Weapon NewWeapon;

	if ( bShowMenu || (Level.Pauser != "") )
	{
		if ( myHUD != None )
		{
			myHUD.InputNumber(F);
		}
		return;
	}
	if ( Inventory == None )
	{
		return;
	}
	if ( (Weapon != None) && (Weapon.Inventory != None) )
	{
		NewWeapon=Weapon.Inventory.WeaponChange(F);
	}
	else
	{
		NewWeapon=None;
	}
	if ( NewWeapon == None )
	{
		NewWeapon=Inventory.WeaponChange(F);
	}
	if ( NewWeapon == None )
	{
		return;
	}
	if ( Weapon == None )
	{
		PendingWeapon=NewWeapon;
		ChangedWeapon();
	}
	else
	{
		if ( (Weapon != NewWeapon) && Weapon.PutDown() )
		{
			PendingWeapon=NewWeapon;
		}
	}
}

exec function GetWeapon (Class<Weapon> NewWeaponClass)
{
	local Inventory Inv;

	if ( (Inventory == None) || (NewWeaponClass == None) || (Weapon != None) && (Weapon.Class == NewWeaponClass) )
	{
		return;
	}
	Inv=Inventory;
JL004C:
	if ( Inv != None )
	{
		if ( Inv.Class == NewWeaponClass )
		{
			PendingWeapon=Weapon(Inv);
			Weapon.PutDown();
			return;
		}
		Inv=Inv.Inventory;
		goto JL004C;
	}
}

exec function PrevItem ()
{
	local Inventory Inv;
	local Inventory LastItem;

	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( SelectedItem == None )
	{
		SelectedItem=Inventory.SelectNext();
		return;
	}
	if ( SelectedItem.Inventory != None )
	{
		Inv=SelectedItem.Inventory;
JL006C:
		if ( Inv != None )
		{
			if ( Inv == None )
			{
				goto JL00B9;
			}
			if ( Inv.bActivatable )
			{
				LastItem=Inv;
			}
			Inv=Inv.Inventory;
			goto JL006C;
		}
	}
JL00B9:
	Inv=Inventory;
JL00C4:
	if ( Inv != SelectedItem )
	{
		if ( Inv == None )
		{
			goto JL0115;
		}
		if ( Inv.bActivatable )
		{
			LastItem=Inv;
		}
		Inv=Inv.Inventory;
		goto JL00C4;
	}
JL0115:
	if ( LastItem != None )
	{
		SelectedItem=LastItem;
		ClientMessage(SelectedItem.ItemName $ SelectedItem.M_Selected);
	}
}

exec function ActivateItem ()
{
	if ( bShowMenu || (Level.Pauser != "") )
	{
		return;
	}
	if ( SelectedItem != None )
	{
		SelectedItem.Activate();
	}
}

exec function Fire (optional float F)
{
	bJustFired=True;
	if ( bShowMenu || (Level.Pauser != "") || (Role < 4) )
	{
		return;
	}
	if ( Weapon != None )
	{
		Weapon.bPointing=True;
		PlayFiring();
		Weapon.Fire(F);
	}
}

exec function AltFire (optional float F)
{
	bJustAltFired=True;
	if ( bShowMenu || (Level.Pauser != "") || (Role < 4) )
	{
		return;
	}
	if ( Weapon != None )
	{
		Weapon.bPointing=True;
		PlayFiring();
		Weapon.AltFire(F);
	}
}

function DoJump (optional float F)
{
	if ( carriedDecoration != None )
	{
		return;
	}
	if (  !bIsCrouching && (Physics == 1) )
	{
		if ( Role == 4 )
		{
			PlaySound(JumpSound,5,1.50,True,1200.00,1.00);
		}
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
		{
			MakeNoise(0.10 * Level.Game.Difficulty);
		}
		PlayInAir();
		if ( bCountJumps && (Role == 4) )
		{
			Inventory.OwnerJumped();
		}
		Velocity.Z=JumpZ;
		if ( Base != Level )
		{
			Velocity.Z += Base.Velocity.Z;
		}
		SetPhysics(2);
	}
}

exec function Suicide ()
{
	KilledBy(None);
}

exec function AlwaysMouseLook (bool B)
{
	ChangeAlwaysMouseLook(B);
	SaveConfig();
}

function ChangeAlwaysMouseLook (bool B)
{
	bAlwaysMouseLook=B;
	if ( bAlwaysMouseLook )
	{
		bLookUpStairs=False;
	}
}

exec function SnapView (bool B)
{
	ChangeSnapView(B);
	SaveConfig();
}

function ChangeSnapView (bool B)
{
	bSnapToLevel=B;
}

exec function StairLook (bool B)
{
	ChangeStairLook(B);
	SaveConfig();
}

function ChangeStairLook (bool B)
{
	bLookUpStairs=B;
	if ( bLookUpStairs )
	{
		bAlwaysMouseLook=False;
	}
}

exec function SetDodgeClickTime (float F)
{
	ChangeDodgeClickTime(F);
	SaveConfig();
}

function ChangeDodgeClickTime (float F)
{
	DodgeClickTime=FMin(0.30,F);
}

exec function SetName (coerce string S)
{
	ChangeName(S);
	UpdateURL("Name",S,True);
	SaveConfig();
}

function ChangeName (coerce string S)
{
	if ( Level.Game.WorldLog != None )
	{
		ClientMessage(CantChangeNameMsg);
	}
	else
	{
		Level.Game.ChangeName(self,S,True);
	}
}

function ChangeTeam (int N)
{
	Level.Game.ChangeTeam(self,N);
	if ( Level.Game.bTeamGame )
	{
		Died(None,'None',Location);
	}
}

exec function SetAutoAim (float F)
{
	ChangeAutoAim(F);
	SaveConfig();
}

function ChangeAutoAim (float F)
{
	MyAutoAim=FMax(Level.Game.AutoAim,F);
}

exec function PlayersOnly ()
{
	if ( Level.NetMode != 0 )
	{
		return;
	}
	Level.bPlayersOnly= !Level.bPlayersOnly;
}

exec function SetHand (string S)
{
	ChangeSetHand(S);
	SaveConfig();
}

function ChangeSetHand (string S)
{
	if ( S ~= "Left" )
	{
		Handedness=1.00;
	}
	else
	{
		if ( S ~= "Right" )
		{
			Handedness=-1.00;
		}
		else
		{
			if ( S ~= "Center" )
			{
				Handedness=0.00;
			}
			else
			{
				if ( S ~= "Hidden" )
				{
					Handedness=2.00;
				}
			}
		}
	}
	ServerSetHandedness(Handedness);
}

exec function ViewPlayer (string S)
{
	local Pawn P;

	P=Level.PawnList;
JL0014:
	if ( P != None )
	{
		if ( P.bIsPlayer && (P.PlayerReplicationInfo.PlayerName ~= S) )
		{
			goto JL006E;
		}
		P=P.nextPawn;
		goto JL0014;
	}
JL006E:
	if ( (P != None) && Level.Game.CanSpectate(self,P) )
	{
		ClientMessage(ViewingFrom $ P.PlayerReplicationInfo.PlayerName,'Event',True);
		if ( P == self )
		{
			ViewTarget=None;
		}
		else
		{
			ViewTarget=P;
		}
	}
	else
	{
		ClientMessage(FailedView);
	}
	bBehindView=ViewTarget != None;
	if ( bBehindView )
	{
		ViewTarget.BecomeViewTarget();
	}
}

exec function CheatView (Class<Actor> aClass)
{
	local Actor Other;
	local Actor first;
	local bool bFound;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	first=None;
	foreach AllActors(aClass,Other)
	{
		if ( (first == None) && (Other != self) )
		{
			first=Other;
			bFound=True;
		}
		if ( Other == ViewTarget )
		{
			first=None;
		}
	}
	if ( first != None )
	{
		if ( first.IsA('Pawn') && Pawn(first).bIsPlayer && (Pawn(first).PlayerReplicationInfo.PlayerName != "") )
		{
			ClientMessage(ViewingFrom $ Pawn(first).PlayerReplicationInfo.PlayerName,'Event',True);
		}
		else
		{
			ClientMessage(ViewingFrom $ string(first),'Event',True);
		}
		ViewTarget=first;
	}
	else
	{
		if ( bFound )
		{
			ClientMessage(ViewingFrom $ OwnCamera,'Event',True);
		}
		else
		{
			ClientMessage(FailedView,'Event',True);
		}
		ViewTarget=None;
	}
	bBehindView=ViewTarget != None;
	if ( bBehindView )
	{
		ViewTarget.BecomeViewTarget();
	}
}

exec function ViewSelf ()
{
	bBehindView=False;
	ViewTarget=None;
	ClientMessage("Now viewing from own camera",'Event',True);
}

exec function ViewClass (Class<Actor> aClass, optional bool bQuiet)
{
	local Actor Other;
	local Actor first;
	local bool bFound;

	first=None;
	foreach AllActors(aClass,Other)
	{
		if ( (first == None) && (Other != self) && (bAdmin && (Level.Game == None) || Level.Game.CanSpectate(self,Other)) )
		{
			first=Other;
			bFound=True;
		}
		if ( Other == ViewTarget )
		{
			first=None;
		}
	}
	if ( first != None )
	{
		if (  !bQuiet )
		{
			if ( first.IsA('Pawn') && Pawn(first).bIsPlayer && (Pawn(first).PlayerReplicationInfo.PlayerName != "") )
			{
				ClientMessage(ViewingFrom $ Pawn(first).PlayerReplicationInfo.PlayerName,'Event',True);
			}
			else
			{
				ClientMessage(ViewingFrom $ string(first),'Event',True);
			}
		}
		ViewTarget=first;
	}
	else
	{
		if (  !bQuiet )
		{
			if ( bFound )
			{
				ClientMessage(ViewingFrom $ OwnCamera,'Event',True);
			}
			else
			{
				ClientMessage(FailedView,'Event',True);
			}
		}
		ViewTarget=None;
	}
	bBehindView=ViewTarget != None;
	if ( bBehindView )
	{
		ViewTarget.BecomeViewTarget();
	}
}

exec function NeverSwitchOnPickup (bool B)
{
	bNeverSwitchOnPickup=B;
	SaveConfig();
}

exec function InvertMouse (bool B)
{
	bInvertMouse=B;
	SaveConfig();
}

exec function SwitchLevel (string URL)
{
	if ( bAdmin || (Level.NetMode == 0) || (Level.NetMode == 2) )
	{
		Level.ServerTravel(URL,False);
	}
}

exec function SwitchCoopLevel (string URL)
{
	if ( bAdmin || (Level.NetMode == 0) || (Level.NetMode == 2) )
	{
		Level.ServerTravel(URL,True);
	}
}

exec function ShowScores ()
{
	bShowScores= !bShowScores;
}

exec function ShowMenu ()
{
	WalkBob=vect(0.00,0.00,0.00);
	bShowMenu=True;
	Player.Console.GotoState('Menuing');
	if ( Level.NetMode == 0 )
	{
		SetPause(True);
	}
}

exec function ShowLoadMenu ()
{
	ShowMenu();
}

exec function AddBots (int N)
{
	ServerAddBots(N);
}

function ServerAddBots (int N)
{
	local int i;

	if (  !bAdmin && (Level.NetMode != 0) && (Level.NetMode != 2) )
	{
		return;
	}
	if (  !Level.Game.bDeathMatch )
	{
		return;
	}
	i=0;
JL0065:
	if ( i < N )
	{
		Level.Game.AddBot();
		i++;
		goto JL0065;
	}
}

exec function ClearProgressMessages ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 5 )
	{
		ProgressMessage[i]="";
		ProgressColor[i].R=255;
		ProgressColor[i].G=255;
		ProgressColor[i].B=255;
		i++;
		goto JL0007;
	}
}

exec function SetProgressMessage (string S, int Index)
{
	if ( Index < 5 )
	{
		ProgressMessage[Index]=S;
	}
}

exec function SetProgressColor (Color C, int Index)
{
	if ( Index < 5 )
	{
		ProgressColor[Index]=C;
	}
}

exec function SetProgressTime (float t)
{
	ProgressTimeOut=t + Level.TimeSeconds;
}

exec event ShowUpgradeMenu ();

exec function Amphibious ()
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	UnderWaterTime=999999.00;
}

exec function Fly ()
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	UnderWaterTime=Default.UnderWaterTime;
	ClientMessage("You feel much lighter");
	SetCollision(True,True,True);
	bCollideWorld=True;
	GotoState('CheatFlying');
}

exec function Walk ()
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	StartWalk();
}

function StartWalk ()
{
	UnderWaterTime=Default.UnderWaterTime;
	SetCollision(True,True,True);
	SetPhysics(1);
	bCollideWorld=True;
	ClientReStart();
}

exec function Ghost ()
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	UnderWaterTime=-1.00;
	ClientMessage("You feel ethereal");
	SetCollision(False,False,False);
	bCollideWorld=False;
	GotoState('CheatFlying');
}

exec function ShowInventory ()
{
	local Inventory Inv;

	if ( Weapon != None )
	{
		Log("   Weapon: " $ string(Weapon.Class));
	}
	Inv=Inventory;
JL0036:
	if ( Inv != None )
	{
		Log("Inv: " $ string(Inv));
		Inv=Inv.Inventory;
		goto JL0036;
	}
	if ( SelectedItem != None )
	{
		Log("Selected Item" @ string(SelectedItem) @ "Charge" @ string(SelectedItem.Charge));
	}
}

exec function AllAmmo ()
{
	local Inventory Inv;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	Inv=Inventory;
JL0031:
	if ( Inv != None )
	{
		if ( Ammo(Inv) != None )
		{
			Ammo(Inv).AmmoAmount=999;
			Ammo(Inv).MaxAmmo=999;
		}
		Inv=Inv.Inventory;
		goto JL0031;
	}
}

exec function Invisible (bool B)
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( B )
	{
		bHidden=True;
		Visibility=0;
	}
	else
	{
		bHidden=False;
		Visibility=Default.Visibility;
	}
}

exec function God ()
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( ReducedDamageType == 'All' )
	{
		ReducedDamageType='None';
		ClientMessage("God mode off");
		return;
	}
	ReducedDamageType='All';
	ClientMessage("God Mode on");
}

exec function BehindView (bool B)
{
	bBehindView=B;
}

exec function SetBob (float F)
{
	UpdateBob(F);
	SaveConfig();
}

function UpdateBob (float F)
{
	Bob=FClamp(F,0.00,0.03);
}

exec function SetSensitivity (float F)
{
	UpdateSensitivity(F);
	SaveConfig();
}

function UpdateSensitivity (float F)
{
	MouseSensitivity=FMax(0.00,F);
}

exec function SloMo (float t)
{
	ServerSetSloMo(t);
}

function ServerSetSloMo (float t)
{
	if ( bAdmin || (Level.NetMode == 0) || (Level.NetMode == 2) )
	{
		Level.Game.SetGameSpeed(t);
		Level.Game.SaveConfig();
		Level.Game.GameReplicationInfo.SaveConfig();
	}
}

exec function SetJumpZ (float F)
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	JumpZ=F;
}

exec function SetSpeed (float F)
{
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	GroundSpeed=Default.GroundSpeed * F;
	WaterSpeed=Default.WaterSpeed * F;
}

exec function KillAll (Class<Actor> aClass)
{
	local Actor A;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	foreach AllActors(Class'Actor',A)
	{
		if ( ClassIsChildOf(A.Class,aClass) )
		{
			A.Destroy();
		}
	}
}

exec function KillPawns ()
{
	local Pawn P;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	foreach AllActors(Class'Pawn',P)
	{
		if ( PlayerPawn(P) == None )
		{
			P.Destroy();
		}
	}
}

exec function Summon (string ClassName)
{
	local Class<Actor> NewClass;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	Log("Fabricate " $ ClassName);
	NewClass=Class<Actor>(DynamicLoadObject(ClassName,Class'Class'));
	if ( NewClass != None )
	{
		Spawn(NewClass,,,Location + 72 * vector(Rotation) + vect(0.00,0.00,1.00) * 15);
	}
}

exec function TimeDemo (bool bActivate, optional bool bSaveToFile, optional int QuitAfterCycles)
{
	if ( Player.Console != None )
	{
		if ( bActivate )
		{
			if ( Player.Console.TimeDemo == None )
			{
				Player.Console.TimeDemo=Spawn(Class'TimeDemo');
			}
			Player.Console.TimeDemo.DoSetup(Player.Console,bSaveToFile,QuitAfterCycles);
		}
		else
		{
			if ( Player.Console.TimeDemo != None )
			{
				Player.Console.TimeDemo.DoShutdown();
			}
		}
	}
}

exec function ShowPath ()
{
	local Actor node;

	node=FindPathTo(Destination);
	if ( node != None )
	{
		Log("found path");
		Spawn(Class'WayBeacon',self,'None',node.Location);
	}
	else
	{
		Log("didn't find path");
	}
}

exec function RememberSpot ()
{
	Destination=Location;
}

event PlayerInput (float DeltaTime)
{
	local float SmoothTime;
	local float FOVScale;
	local float MouseScale;
	local float KbdScale;
	local float AbsSmooth;
	local float AbsInput;

	if ( bShowMenu && (myHUD != None) )
	{
		if ( myHUD.MainMenu != None )
		{
			myHUD.MainMenu.MenuTick(DeltaTime);
		}
		bEdgeForward=False;
		bEdgeBack=False;
		bEdgeLeft=False;
		bEdgeRight=False;
		bWasForward=False;
		bWasBack=False;
		bWasLeft=False;
		bWasRight=False;
		aStrafe=0.00;
		aTurn=0.00;
		aForward=0.00;
		aLookUp=0.00;
		return;
	}
	else
	{
		if ( bDelayedCommand )
		{
			bDelayedCommand=False;
			ConsoleCommand(DelayedCommand);
		}
	}
	bEdgeForward=bWasForward ^^ (aBaseY > 0);
	bEdgeBack=bWasBack ^^ (aBaseY < 0);
	bEdgeLeft=bWasLeft ^^ (aStrafe > 0);
	bEdgeRight=bWasRight ^^ (aStrafe < 0);
	bWasForward=aBaseY > 0;
	bWasBack=aBaseY < 0;
	bWasLeft=aStrafe > 0;
	bWasRight=aStrafe < 0;
	SmoothTime=FMin(0.20,3.00 * DeltaTime);
	FOVScale=DesiredFOV * 0.01;
	MouseScale=MouseSensitivity * FOVScale;
	aMouseX *= MouseScale;
	aMouseY *= MouseScale;
	if ( bMaxMouseSmoothing )
	{
		if (  !bMouseZeroed )
		{
			bMouseZeroed=(aMouseX == 0) && (aMouseY == 0);
			if ( aMouseX == 0 )
			{
				if ( SmoothMouseX > 0 )
				{
					aMouseX=1.00;
				}
				else
				{
					if ( SmoothMouseX < 0 )
					{
						aMouseX=-1.00;
					}
				}
			}
			if ( aMouseY == 0 )
			{
				if ( SmoothMouseY > 0 )
				{
					aMouseY=1.00;
				}
				else
				{
					if ( SmoothMouseY < 0 )
					{
						aMouseY=-1.00;
					}
				}
			}
		}
		else
		{
			bMouseZeroed=(aMouseX == 0) && (aMouseY == 0);
		}
	}
	if ( (SmoothMouseX == 0) || (aMouseX == 0) || (SmoothMouseX > 0 != aMouseX > 0) )
	{
		SmoothMouseX=aMouseX;
	}
	else
	{
		AbsSmooth=Abs(SmoothMouseX);
		AbsInput=Abs(aMouseX);
		if ( (AbsSmooth < 0.85 * AbsInput) || (AbsSmooth > 1.17 * AbsInput) )
		{
			SmoothMouseX=5.00 * SmoothTime * aMouseX + (1 - 5 * SmoothTime) * SmoothMouseX;
		}
		else
		{
			SmoothMouseX=SmoothTime * aMouseX + (1 - SmoothTime) * SmoothMouseX;
		}
	}
	if ( (SmoothMouseY == 0) || (aMouseY == 0) || (SmoothMouseY > 0 != aMouseY > 0) )
	{
		SmoothMouseY=aMouseY;
	}
	else
	{
		AbsSmooth=Abs(SmoothMouseY);
		AbsInput=Abs(aMouseY);
		if ( (AbsSmooth < 0.85 * AbsInput) || (AbsSmooth > 1.17 * AbsInput) )
		{
			SmoothMouseY=5.00 * SmoothTime * aMouseY + (1 - 5 * SmoothTime) * SmoothMouseY;
		}
		else
		{
			SmoothMouseY=SmoothTime * aMouseY + (1 - SmoothTime) * SmoothMouseY;
		}
	}
	if ( (aLookUp == 0) && (aBaseX == 0) && (aTurn == 0) )
	{
		KbdAccel=0.20;
	}
	else
	{
		if ( KbdAccel < 2.00 )
		{
			if ( KbdAccel < 0.50 )
			{
				KbdAccel += DeltaTime;
			}
			else
			{
				KbdAccel=FMin(2.00,KbdAccel + 4 * DeltaTime);
			}
		}
	}
	KbdScale=FOVScale * KbdAccel;
	aLookUp *= FOVScale;
	aTurn *= KbdScale;
	if ( bStrafe != 0 )
	{
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX=0.00;
	}
	else
	{
		aTurn += aBaseX * KbdScale + SmoothMouseX;
		aBaseX=0.00;
	}
	if ( (bStrafe == 0) && (bAlwaysMouseLook || (bLook != 0)) )
	{
		if ( bInvertMouse )
		{
			aLookUp -= SmoothMouseY;
		}
		else
		{
			aLookUp += SmoothMouseY;
		}
	}
	else
	{
		aForward += SmoothMouseY;
	}
	if ( bSnapLevel != 0 )
	{
		bCenterView=True;
		bKeyboardLook=False;
	}
	else
	{
		if ( aLookUp != 0 )
		{
			bCenterView=False;
			bKeyboardLook=True;
		}
		else
		{
			if ( bSnapToLevel &&  !bAlwaysMouseLook )
			{
				bCenterView=True;
				bKeyboardLook=False;
			}
		}
	}
	if ( bFreeLook != 0 )
	{
		bKeyboardLook=True;
		aLookUp += 0.50 * aBaseY * KbdScale;
	}
	else
	{
		aForward += aBaseY;
	}
	aBaseY=0.00;
	HandleWalking();
}

event UpdateEyeHeight (float DeltaTime)
{
	local float smooth;
	local float bound;

	smooth=FMin(1.00,10.00 * DeltaTime / Level.TimeDilation);
	if ( (IsInState('PlayerSwimming') || (Physics == 1)) &&  !bJustLanded )
	{
		EyeHeight=(EyeHeight - Location.Z + OldLocation.Z) * (1 - smooth) + (shakevert + BaseEyeHeight) * smooth;
		bound=-0.50 * CollisionHeight;
		if ( EyeHeight < bound )
		{
			EyeHeight=bound;
		}
		else
		{
			bound=CollisionHeight + FMin(FMax(0.00,OldLocation.Z - Location.Z),MaxStepHeight);
			if ( EyeHeight > bound )
			{
				EyeHeight=bound;
			}
		}
	}
	else
	{
		smooth=FMax(smooth,0.35);
		bJustLanded=False;
		EyeHeight=EyeHeight * (1 - smooth) + (BaseEyeHeight + shakevert) * smooth;
	}
	if ( FovAngle != DesiredFOV )
	{
		if ( FovAngle > DesiredFOV )
		{
			FovAngle=FovAngle - FMax(7.00,0.90 * DeltaTime * (FovAngle - DesiredFOV));
		}
		else
		{
			FovAngle=FovAngle - FMin(-7.00,0.90 * DeltaTime * (FovAngle - DesiredFOV));
		}
		if ( Abs(FovAngle - DesiredFOV) <= 10 )
		{
			FovAngle=DesiredFOV;
		}
	}
	if ( bZooming )
	{
		ZoomLevel += DeltaTime * 1.00;
		if ( ZoomLevel > 0.90 )
		{
			ZoomLevel=0.90;
		}
		DesiredFOV=FClamp(90.00 - ZoomLevel * 88.00,1.00,170.00);
	}
}

event PlayerTimeout ()
{
	if ( Health > 0 )
	{
		Died(None,'suicided',Location);
	}
}

function ChangedWeapon ()
{
	Super.ChangedWeapon();
	if ( Weapon != None )
	{
		Weapon.SetHand(Handedness);
	}
}

function JumpOffPawn ()
{
	Velocity += 60 * VRand();
	Velocity.Z=120.00;
	SetPhysics(2);
}

event TravelPostAccept ()
{
	if ( Health <= 0 )
	{
		Health=Default.Health;
	}
}

event Possess ()
{
	local byte i;

	if ( Level.NetMode == 3 )
	{
		ServerSetHandedness(Handedness);
		i=0;
JL002A:
		if ( i < 20 )
		{
			ServerSetWeaponPriority(i,WeaponPriority[i]);
			i++;
			goto JL002A;
		}
	}
	ServerUpdateWeapons();
	bIsPlayer=True;
	DodgeClickTime=FMin(0.30,DodgeClickTime);
	EyeHeight=BaseEyeHeight;
	NetPriority=8.00;
	StartWalk();
}

function ServerSetWeaponPriority (byte i, name WeaponName)
{
	WeaponPriority[i]=WeaponName;
}

event UnPossess ()
{
	Log(string(self) $ " being unpossessed");
	if ( myHUD != None )
	{
		myHUD.Destroy();
	}
	bIsPlayer=False;
	EyeHeight=0.80 * CollisionHeight;
}

function Carcass SpawnCarcass ()
{
	local Carcass carc;

	carc=Spawn(CarcassType);
	carc.Initfor(self);
	if ( Player != None )
	{
		carc.bPlayerCarcass=True;
	}
	MoveTarget=carc;
	return carc;
}

function bool Gibbed (name DamageType)
{
	if ( (DamageType == 'Decapitated') || (DamageType == 'shot') )
	{
		return False;
	}
	if ( (Health < -80) || (Health < -40) && (FRand() < 0.60) )
	{
		return True;
	}
	return False;
}

function SpawnGibbedCarcass ()
{
	local Carcass carc;

	carc=Spawn(CarcassType);
	carc.Initfor(self);
	carc.ChunkUp(-1 * Health);
	MoveTarget=carc;
}

event PlayerTick (float Time);

event PreBeginPlay ()
{
	bIsPlayer=True;
	Super.PreBeginPlay();
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Level.LevelEnterText != "" )
	{
		ClientMessage(Level.LevelEnterText);
	}
	if ( Level.NetMode != 3 )
	{
		HUDType=Level.Game.HUDType;
		ScoringType=Level.Game.ScoreBoardType;
		MyAutoAim=FMax(MyAutoAim,Level.Game.AutoAim);
	}
	bIsPlayer=True;
	DodgeClickTime=FMin(0.30,DodgeClickTime);
	EyeHeight=BaseEyeHeight;
	if ( Level.Game.IsA('SinglePlayer') && (Level.NetMode == 0) )
	{
		FlashScale=vect(0.00,0.00,0.00);
	}
}

function ServerUpdateWeapons ()
{
	local Inventory Inv;

	Inv=Inventory;
JL000B:
	if ( Inv != None )
	{
		if ( Inv.IsA('Weapon') )
		{
			Weapon(Inv).SetSwitchPriority(self);
		}
		Inv=Inv.Inventory;
		goto JL000B;
	}
}

function PlayDodge (EDodgeDir DodgeMove)
{
	PlayDuck();
}

function PlayTurning ();

function PlaySwimming ()
{
	PlayRunning();
}

function PlayFeignDeath ();

function PlayRising ();

function bool AdjustHitLocation (out Vector HitLocation, Vector TraceDir)
{
	local float adjZ;
	local float maxZ;

	TraceDir=Normal(TraceDir);
	HitLocation=HitLocation + 0.50 * CollisionRadius * TraceDir;
	if ( BaseEyeHeight == Default.BaseEyeHeight )
	{
		return True;
	}
	maxZ=Location.Z + EyeHeight + 0.25 * CollisionHeight;
	if ( HitLocation.Z > maxZ )
	{
		if ( TraceDir.Z >= 0 )
		{
			return False;
		}
		adjZ=(maxZ - HitLocation.Z) / TraceDir.Z;
		HitLocation.Z=maxZ;
		HitLocation.X=HitLocation.X + TraceDir.X * adjZ;
		HitLocation.Y=HitLocation.Y + TraceDir.Y * adjZ;
		if ( VSize(HitLocation - Location) > CollisionRadius )
		{
			return False;
		}
	}
	return True;
}

function Rotator AdjustAim (float projSpeed, Vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	local Vector FireDir;
	local Vector AimSpot;
	local Vector HitNormal;
	local Vector HitLocation;
	local Actor BestTarget;
	local float bestAim;
	local float bestDist;
	local Actor HitActor;

	FireDir=vector(ViewRotation);
	HitActor=Trace(HitLocation,HitNormal,projStart + 4000 * FireDir,projStart,True);
	if ( (HitActor != None) && HitActor.bProjTarget )
	{
		if ( bWarnTarget && HitActor.IsA('Pawn') )
		{
			Pawn(HitActor).WarnTarget(self,projSpeed,FireDir);
		}
		return ViewRotation;
	}
	bestAim=FMin(0.93,MyAutoAim);
	BestTarget=PickTarget(bestAim,bestDist,FireDir,projStart);
	if ( bWarnTarget && (Pawn(BestTarget) != None) )
	{
		Pawn(BestTarget).WarnTarget(self,projSpeed,FireDir);
	}
	if ( (Level.Game.Difficulty > 2) || bAlwaysMouseLook || (BestTarget != None) && (bestAim < MyAutoAim) || (MyAutoAim >= 1) )
	{
		return ViewRotation;
	}
	if ( BestTarget == None )
	{
		bestAim=MyAutoAim;
		BestTarget=PickAnyTarget(bestAim,bestDist,FireDir,projStart);
		if ( BestTarget == None )
		{
			return ViewRotation;
		}
	}
	AimSpot=projStart + FireDir * bestDist;
	AimSpot.Z=BestTarget.Location.Z + 0.30 * BestTarget.CollisionHeight;
	return rotator(AimSpot - projStart);
}

function Falling ()
{
	PlayInAir();
}

function Landed (Vector HitNormal)
{
	PlayLanded(Velocity.Z);
	if ( Velocity.Z < -1.40 * JumpZ )
	{
		MakeNoise(-0.50 * Velocity.Z / FMax(JumpZ,150.00));
		ShakeView(0.17 - 0.00 * Velocity.Z,-0.85 * Velocity.Z,0.00 * Velocity.Z);
		if ( Velocity.Z <= -1100 )
		{
			if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
			{
				TakeDamage(1000,None,Location,vect(0.00,0.00,0.00),'fell');
			}
			else
			{
				if ( Role == 4 )
				{
					TakeDamage(-0.15 * (Velocity.Z + 1050),None,Location,vect(0.00,0.00,0.00),'fell');
				}
			}
		}
	}
	else
	{
		if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.50 * JumpZ) )
		{
			MakeNoise(0.10 * Level.Game.Difficulty);
		}
	}
	bJustLanded=True;
}

function Died (Pawn Killer, name DamageType, Vector HitLocation)
{
	if ( Role != 4 )
	{
		Log("Non-authority tried to die");
		return;
	}
	StopZoom();
	Super.Died(Killer,DamageType,HitLocation);
}

function EAttitude AttitudeTo (Pawn Other)
{
	if ( Other.bIsPlayer )
	{
		return AttitudeToPlayer;
	}
	else
	{
		return Other.AttitudeToPlayer;
	}
}

function string KillMessage (name DamageType, Pawn Other)
{
	return Level.Game.PlayerKillMessage(DamageType,Other) $ PlayerReplicationInfo.PlayerName;
}

function KilledBy (Pawn EventInstigator)
{
	Health=0;
	Died(EventInstigator,'suicided',Location);
}

function CalcBehindView (out Vector CameraLocation, out Rotator CameraRotation, float dist)
{
	local Vector View;
	local Vector HitLocation;
	local Vector HitNormal;
	local float ViewDist;

	CameraRotation=ViewRotation;
	View=vect(1.00,0.00,0.00) >> CameraRotation;
	if ( Trace(HitLocation,HitNormal,CameraLocation - (dist + 30) * vector(CameraRotation),CameraLocation) != None )
	{
		ViewDist=FMin((CameraLocation - HitLocation) Dot View,dist);
	}
	else
	{
		ViewDist=dist;
	}
	CameraLocation -= (ViewDist - 30) * View;
}

event PlayerCalcView (out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
	local Pawn PTarget;

	if ( ViewTarget != None )
	{
		ViewActor=ViewTarget;
		CameraLocation=ViewTarget.Location;
		CameraRotation=ViewTarget.Rotation;
		PTarget=Pawn(ViewTarget);
		if ( PTarget != None )
		{
			if ( Level.NetMode == 3 )
			{
				if ( PTarget.bIsPlayer )
				{
					PTarget.ViewRotation=TargetViewRotation;
				}
				PTarget.EyeHeight=TargetEyeHeight;
				if ( PTarget.Weapon != None )
				{
					PTarget.Weapon.PlayerViewOffset=TargetWeaponViewOffset;
				}
			}
			if ( PTarget.bIsPlayer )
			{
				CameraRotation=PTarget.ViewRotation;
			}
			if (  !bBehindView )
			{
				CameraLocation.Z += PTarget.EyeHeight;
			}
		}
		if ( bBehindView )
		{
			CalcBehindView(CameraLocation,CameraRotation,180.00);
		}
		return;
	}
	ViewActor=self;
	CameraLocation=Location;
	if ( bBehindView )
	{
		CalcBehindView(CameraLocation,CameraRotation,150.00);
	}
	else
	{
		CameraRotation=ViewRotation;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}

exec function SetViewFlash (bool B)
{
	bNoFlash= !B;
}

function ViewFlash (float DeltaTime)
{
	local Vector goalFog;
	local float goalscale;
	local float Delta;

	if ( bNoFlash )
	{
		InstantFlash=0.00;
		InstantFog=vect(0.00,0.00,0.00);
	}
	Delta=FMin(0.10,DeltaTime);
	goalscale=1.00 + DesiredFlashScale + ConstantGlowScale + HeadRegion.Zone.ViewFlash.X;
	goalFog=DesiredFlashFog + ConstantGlowFog + HeadRegion.Zone.ViewFog;
	DesiredFlashScale -= DesiredFlashScale * 2 * Delta;
	DesiredFlashFog -= DesiredFlashFog * 2 * Delta;
	FlashScale.X += (goalscale - FlashScale.X + InstantFlash) * 10 * Delta;
	FlashFog += (goalFog - FlashFog + InstantFog) * 10 * Delta;
	InstantFlash=0.00;
	InstantFog=vect(0.00,0.00,0.00);
	if ( FlashScale.X > 0.98 )
	{
		FlashScale.X=1.00;
	}
	FlashScale=FlashScale.X * vect(1.00,1.00,1.00);
	if ( FlashFog.X < 0.02 )
	{
		FlashFog.X=0.00;
	}
	if ( FlashFog.Y < 0.02 )
	{
		FlashFog.Y=0.00;
	}
	if ( FlashFog.Z < 0.02 )
	{
		FlashFog.Z=0.00;
	}
}

function ViewShake (float DeltaTime)
{
	if ( shaketimer > 0.00 )
	{
		shaketimer -= DeltaTime;
		if ( verttimer == 0 )
		{
			verttimer=0.10;
			shakevert=-1.10 * maxshake;
		}
		else
		{
			verttimer -= DeltaTime;
			if ( verttimer < 0 )
			{
				verttimer=0.20 * FRand();
				shakevert=(2.00 * FRand() - 1) * maxshake;
			}
		}
		ViewRotation.Roll=ViewRotation.Roll & 65535;
		if ( bShakeDir )
		{
			ViewRotation.Roll += 10 * shakemag * FMin(0.10,DeltaTime);
			bShakeDir=(ViewRotation.Roll > 32768) || (ViewRotation.Roll < (0.50 + FRand()) * shakemag);
			if ( (ViewRotation.Roll < 32768) && (ViewRotation.Roll > 1.30 * shakemag) )
			{
				ViewRotation.Roll=1.30 * shakemag;
				bShakeDir=False;
			}
			else
			{
				if ( FRand() < 3 * DeltaTime )
				{
					bShakeDir= !bShakeDir;
				}
			}
		}
		else
		{
			ViewRotation.Roll -= 10 * shakemag * FMin(0.10,DeltaTime);
			bShakeDir=(ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - (0.50 + FRand()) * shakemag);
			if ( (ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - 1.30 * shakemag) )
			{
				ViewRotation.Roll=65535 - 1.30 * shakemag;
				bShakeDir=True;
			}
			else
			{
				if ( FRand() < 3 * DeltaTime )
				{
					bShakeDir= !bShakeDir;
				}
			}
		}
	}
	else
	{
		shakevert=0.00;
		ViewRotation.Roll=ViewRotation.Roll & 65535;
		if ( ViewRotation.Roll < 32768 )
		{
			if ( ViewRotation.Roll > 0 )
			{
				ViewRotation.Roll=Max(0,ViewRotation.Roll - Max(ViewRotation.Roll,500) * 10 * FMin(0.10,DeltaTime));
			}
		}
		else
		{
			ViewRotation.Roll += (65536 - Max(500,ViewRotation.Roll)) * 10 * FMin(0.10,DeltaTime);
			if ( ViewRotation.Roll > 65534 )
			{
				ViewRotation.Roll=0;
			}
		}
	}
}

function UpdateRotation (float DeltaTime, float maxPitch)
{
	local Rotator NewRotation;

	DesiredRotation=ViewRotation;
	ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
	ViewRotation.Pitch=ViewRotation.Pitch & 65535;
	if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
	{
		if ( aLookUp > 0 )
		{
			ViewRotation.Pitch=18000;
		}
		else
		{
			ViewRotation.Pitch=49152;
		}
	}
	ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
	ViewShake(DeltaTime);
	ViewFlash(DeltaTime);
	NewRotation=Rotation;
	NewRotation.Yaw=ViewRotation.Yaw;
	NewRotation.Pitch=ViewRotation.Pitch;
	if ( (NewRotation.Pitch > maxPitch * RotationRate.Pitch) && (NewRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		if ( ViewRotation.Pitch < 32768 )
		{
			NewRotation.Pitch=maxPitch * RotationRate.Pitch;
		}
		else
		{
			NewRotation.Pitch=65536 - maxPitch * RotationRate.Pitch;
		}
	}
	SetRotation(NewRotation);
}

function SwimAnimUpdate (bool bNotForward)
{
	if (  !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
	{
		if ( bNotForward )
		{
			if ( GetAnimGroup(AnimSequence) != 'Waiting' )
			{
				TweenToWaiting(0.10);
			}
		}
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			{
				TweenToSwimming(0.10);
			}
		}
	}
}

state PlayerWalking
{
	exec function FeignDeath ()
	{
		if ( Physics == 1 )
		{
			ServerFeignDeath();
			Acceleration=vect(0.00,0.00,0.00);
			GotoState('FeigningDeath');
		}
	}
	
	function ZoneChange (ZoneInfo NewZone)
	{
		if ( NewZone.bWaterZone )
		{
			SetPhysics(3);
			GotoState('PlayerSwimming');
		}
	}
	
	function AnimEnd ()
	{
		local name MyAnimGroup;
	
		bAnimTransition=False;
		if ( Physics == 1 )
		{
			if ( bIsCrouching )
			{
				if (  !bIsTurning && (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) )
				{
					PlayDuck();
				}
				else
				{
					PlayCrawling();
				}
			}
			else
			{
				MyAnimGroup=GetAnimGroup(AnimSequence);
				if ( Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000 )
				{
					if ( MyAnimGroup == 'Waiting' )
					{
						PlayWaiting();
					}
					else
					{
						bAnimTransition=True;
						TweenToWaiting(0.20);
					}
				}
				else
				{
					if ( bIsWalking )
					{
						if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit') )
						{
							TweenToWalking(0.10);
							bAnimTransition=True;
						}
						else
						{
							PlayWalking();
						}
					}
					else
					{
						if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit') )
						{
							bAnimTransition=True;
							TweenToRunning(0.10);
						}
						else
						{
							PlayRunning();
						}
					}
				}
			}
		}
	}
	
	function Landed (Vector HitNormal)
	{
		Global.Landed(HitNormal);
		if ( DodgeDir == 5 )
		{
			DodgeDir=6;
			DodgeClickTimer=0.00;
			Velocity *= 0.10;
		}
		else
		{
			DodgeDir=0;
		}
	}
	
	function Dodge (EDodgeDir DodgeMove)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		if ( bIsCrouching || (Physics != 1) )
		{
			return;
		}
		GetAxes(Rotation,X,Y,Z);
		if ( DodgeMove == 3 )
		{
			Velocity=1.50 * GroundSpeed * X + Velocity Dot Y * Y;
		}
		else
		{
			if ( DodgeMove == 4 )
			{
				Velocity=-1.50 * GroundSpeed * X + Velocity Dot Y * Y;
			}
			else
			{
				if ( DodgeMove == 1 )
				{
					Velocity=1.50 * GroundSpeed * Y + Velocity Dot X * X;
				}
				else
				{
					if ( DodgeMove == 2 )
					{
						Velocity=-1.50 * GroundSpeed * Y + Velocity Dot X * X;
					}
				}
			}
		}
		Velocity.Z=160.00;
		if ( Role == 4 )
		{
			PlaySound(JumpSound,5,1.00,True,800.00,1.00);
		}
		PlayDodge(DodgeMove);
		DodgeDir=5;
		SetPhysics(2);
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		local Vector OldAccel;
	
		OldAccel=Acceleration;
		Acceleration=newAccel;
		bIsTurning=Abs(DeltaRot.Yaw / DeltaTime) > 5000;
		if ( (DodgeMove == 5) && (Physics == 2) )
		{
			DodgeDir=5;
		}
		else
		{
			if ( (DodgeMove != 0) && (DodgeMove < 5) )
			{
				Dodge(DodgeMove);
			}
		}
		if ( bPressedJump )
		{
			DoJump();
		}
		if ( (Physics == 1) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (  !bIsCrouching )
			{
				if ( bDuck != 0 )
				{
					bIsCrouching=True;
					PlayDuck();
				}
			}
			else
			{
				if ( bDuck == 0 )
				{
					OldAccel=vect(0.00,0.00,0.00);
					bIsCrouching=False;
				}
			}
			if (  !bIsCrouching )
			{
				if ( ( !bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0.00,0.00,0.00) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition=True;
							TweenToRunning(0.10);
						}
					}
					else
					{
						if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) && (GetAnimGroup(AnimSequence) != 'Gesture') )
						{
							if ( GetAnimGroup(AnimSequence) == 'Waiting' )
							{
								if ( bIsTurning && (AnimFrame >= 0) )
								{
									bAnimTransition=True;
									PlayTurning();
								}
							}
							else
							{
								if (  !bIsTurning )
								{
									bAnimTransition=True;
									TweenToWaiting(0.20);
								}
							}
						}
					}
				}
			}
			else
			{
				if ( (OldAccel == vect(0.00,0.00,0.00)) && (Acceleration != vect(0.00,0.00,0.00)) )
				{
					PlayCrawling();
				}
				else
				{
					if (  !bIsTurning && (Acceleration == vect(0.00,0.00,0.00)) && (AnimFrame > 0.10) )
					{
						PlayDuck();
					}
				}
			}
		}
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector newAccel;
		local EDodgeDir OldDodge;
		local EDodgeDir DodgeMove;
		local Rotator OldRotation;
		local float Speed2D;
		local bool bSaveJump;
		local name AnimGroupName;
	
		GetAxes(Rotation,X,Y,Z);
		aForward *= 0.40;
		aStrafe *= 0.40;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		newAccel=aForward * X + aStrafe * Y;
		newAccel.Z=0.00;
		if ( DodgeDir == 5 )
		{
			DodgeMove=5;
		}
		else
		{
			DodgeMove=0;
		}
		if ( DodgeClickTime > 0.00 )
		{
			if ( DodgeDir < 5 )
			{
				OldDodge=DodgeDir;
				DodgeDir=0;
				if ( bEdgeForward && bWasForward )
				{
					DodgeDir=3;
				}
				if ( bEdgeBack && bWasBack )
				{
					DodgeDir=4;
				}
				if ( bEdgeLeft && bWasLeft )
				{
					DodgeDir=1;
				}
				if ( bEdgeRight && bWasRight )
				{
					DodgeDir=2;
				}
				if ( DodgeDir == 0 )
				{
					DodgeDir=OldDodge;
				}
				else
				{
					if ( DodgeDir != OldDodge )
					{
						DodgeClickTimer=DodgeClickTime + 0.50 * DeltaTime;
					}
					else
					{
						DodgeMove=DodgeDir;
					}
				}
			}
			if ( DodgeDir == 6 )
			{
				DodgeClickTimer -= DeltaTime;
				if ( DodgeClickTimer < -0.35 )
				{
					DodgeDir=0;
					DodgeClickTimer=DodgeClickTime;
				}
			}
			else
			{
				if ( (DodgeDir != 0) && (DodgeDir != 5) )
				{
					DodgeClickTimer -= DeltaTime;
					if ( DodgeClickTimer < 0 )
					{
						DodgeDir=0;
						DodgeClickTimer=DodgeClickTime;
					}
				}
			}
		}
		AnimGroupName=GetAnimGroup(AnimSequence);
		if ( (Physics == 1) && (AnimGroupName != 'Dodge') )
		{
			if (  !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
				{
					ViewRotation.Pitch=FindStairRotation(DeltaTime);
				}
				else
				{
					if ( bCenterView )
					{
						ViewRotation.Pitch=ViewRotation.Pitch & 65535;
						if ( ViewRotation.Pitch > 32768 )
						{
							ViewRotation.Pitch -= 65536;
						}
						ViewRotation.Pitch=ViewRotation.Pitch * (1 - 12 * FMin(0.08,DeltaTime));
						if ( Abs(ViewRotation.Pitch) < 1000 )
						{
							ViewRotation.Pitch=0;
						}
					}
				}
			}
			Speed2D=Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			if (  !bShowMenu )
			{
				if ( Speed2D < 10 )
				{
					bobtime += 0.20 * DeltaTime;
				}
				else
				{
					bobtime += DeltaTime * (0.30 + 0.70 * Speed2D / GroundSpeed);
				}
				WalkBob=Y * 0.65 * Bob * Speed2D * Sin(6.00 * bobtime);
				if ( Speed2D < 10 )
				{
					WalkBob.Z=Bob * 30 * Sin(12.00 * bobtime);
				}
				else
				{
					WalkBob.Z=Bob * Speed2D * Sin(12.00 * bobtime);
				}
			}
		}
		else
		{
			if (  !bShowMenu )
			{
				bobtime=0.00;
				WalkBob=WalkBob * (1 - FMin(1.00,8.00 * DeltaTime));
			}
		}
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
		if ( bPressedJump && (AnimGroupName == 'Dodge') )
		{
			bSaveJump=True;
			bPressedJump=False;
		}
		else
		{
			bSaveJump=False;
		}
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,newAccel,DodgeMove,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,newAccel,DodgeMove,OldRotation - Rotation);
		}
		bPressedJump=bSaveJump;
	}
	
	function BeginState ()
	{
		WalkBob=vect(0.00,0.00,0.00);
		DodgeDir=0;
		bIsCrouching=False;
		bIsTurning=False;
		bPressedJump=False;
		if ( Physics != 2 )
		{
			SetPhysics(1);
		}
		if (  !IsAnimating() )
		{
			PlayWaiting();
		}
	}
	
	function EndState ()
	{
		WalkBob=vect(0.00,0.00,0.00);
		bIsCrouching=False;
	}
	
}

state FeigningDeath
{
	ignores  AltFire, Fire;
	
	function ZoneChange (ZoneInfo NewZone)
	{
		if ( NewZone.bWaterZone )
		{
			SetPhysics(3);
			GotoState('PlayerSwimming');
		}
	}
	
	function PlayChatting ()
	{
	}
	
	exec function Taunt (name Sequence)
	{
	}
	
	function AnimEnd ()
	{
		if ( (Role == 4) && (Health > 0) )
		{
			GotoState('PlayerWalking');
			ChangedWeapon();
		}
	}
	
	function Landed (Vector HitNormal)
	{
		if ( Role == 4 )
		{
			PlaySound(Land,3,0.30,False,800.00,1.00);
		}
		if ( Velocity.Z < -1.40 * JumpZ )
		{
			MakeNoise(-0.50 * Velocity.Z / FMax(JumpZ,150.00));
			if ( Velocity.Z <= -1100 )
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					TakeDamage(1000,None,Location,vect(0.00,0.00,0.00),'fell');
				}
				else
				{
					if ( Role == 4 )
					{
						TakeDamage(-0.15 * (Velocity.Z + 1050),self,Location,vect(0.00,0.00,0.00),'fell');
					}
				}
			}
		}
		else
		{
			if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.50 * JumpZ) )
			{
				MakeNoise(0.10 * Level.Game.Difficulty);
			}
		}
		bJustLanded=True;
	}
	
	function Rise ()
	{
		if (  !bRising )
		{
			Enable('AnimEnd');
			BaseEyeHeight=Default.BaseEyeHeight;
			bRising=True;
			PlayRising();
		}
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		if ( bPressedJump || (newAccel.Z > 0) )
		{
			Rise();
		}
		Acceleration=vect(0.00,0.00,0.00);
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function ServerMove (float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbPressedJump, bool bFired, bool bAltFired, EDodgeDir DodgeMove, byte ClientRoll, int View)
	{
		Global.ServerMove(TimeStamp,Accel,ClientLoc,NewbRun,NewbDuck,NewbPressedJump,bFired,bAltFired,DodgeMove,ClientRoll,(32767 & Rotation.Pitch / 2) * 32768 + (32767 & Rotation.Yaw / 2));
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator currentRot;
		local Vector newAccel;
	
		aLookUp *= 0.24;
		aTurn *= 0.24;
		if (  !IsAnimating() && (aForward != 0) || (aStrafe != 0) )
		{
			newAccel=vect(0.00,0.00,1.00);
		}
		else
		{
			newAccel=vect(0.00,0.00,0.00);
		}
		currentRot=Rotation;
		UpdateRotation(DeltaTime,1.00);
		SetRotation(currentRot);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,newAccel,0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,newAccel,0,rot(0,0,0));
		}
		bPressedJump=False;
	}
	
	function PlayTakeHit (float TweenTime, Vector HitLoc, int Damage)
	{
		if ( IsAnimating() )
		{
			Enable('AnimEnd');
			Global.PlayTakeHit(TweenTime,HitLoc,Damage);
		}
	}
	
	function PlayDying (name DamageType, Vector HitLocation)
	{
		BaseEyeHeight=Default.BaseEyeHeight;
	}
	
	function ChangedWeapon ()
	{
		Inventory.ChangedWeapon();
		Weapon=None;
	}
	
	function EndState ()
	{
		PlayerReplicationInfo.bFeigningDeath=False;
	}
	
	function BeginState ()
	{
		local Rotator NewRot;
	
		if ( carriedDecoration != None )
		{
			DropDecoration();
		}
		NewRot=Rotation;
		NewRot.Pitch=0;
		SetRotation(NewRot);
		BaseEyeHeight=-0.50 * CollisionHeight;
		bIsCrouching=False;
		bPressedJump=False;
		bRising=False;
		Disable('AnimEnd');
		PlayFeignDeath();
		PlayerReplicationInfo.bFeigningDeath=True;
	}
	
}

state PlayerSwimming
{
	function Landed (Vector HitNormal)
	{
		PlayLanded(Velocity.Z);
		if ( Velocity.Z < -1.20 * JumpZ )
		{
			MakeNoise(-0.50 * Velocity.Z / FMax(JumpZ,150.00));
			if ( Velocity.Z <= -1100 )
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					TakeDamage(1000,None,Location,vect(0.00,0.00,0.00),'fell');
				}
				else
				{
					if ( Role == 4 )
					{
						TakeDamage(-0.10 * (Velocity.Z + 1050),self,Location,vect(0.00,0.00,0.00),'fell');
					}
				}
			}
		}
		else
		{
			if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.50 * JumpZ) )
			{
				MakeNoise(0.10 * Level.Game.Difficulty);
			}
		}
		bJustLanded=True;
		if ( Region.Zone.bWaterZone )
		{
			SetPhysics(3);
		}
		else
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	}
	
	function AnimEnd ()
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(Rotation,X,Y,Z);
		if ( Acceleration Dot X <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition=True;
				TweenToWaiting(0.20);
			}
			else
			{
				PlayWaiting();
			}
		}
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition=True;
				TweenToSwimming(0.20);
			}
			else
			{
				PlaySwimming();
			}
		}
	}
	
	function ZoneChange (ZoneInfo NewZone)
	{
		local Actor HitActor;
		local Vector HitLocation;
		local Vector HitNormal;
		local Vector checkpoint;
	
		if (  !NewZone.bWaterZone )
		{
			SetPhysics(2);
			if ( bUpAndOut && CheckWaterJump(HitNormal) )
			{
				Velocity.Z=330.00 + 2 * CollisionRadius;
				PlayDuck();
				GotoState('PlayerWalking');
			}
			else
			{
				if (  !FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					checkpoint=Location;
					checkpoint.Z -= CollisionHeight + 6.00;
					HitActor=Trace(HitLocation,HitNormal,checkpoint,Location,False);
					if ( HitActor != None )
					{
						GotoState('PlayerWalking');
						AnimEnd();
					}
					else
					{
						Enable('Timer');
						SetTimer(0.70,False);
					}
				}
			}
		}
		else
		{
			Disable('Timer');
			SetPhysics(3);
		}
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector Temp;
	
		GetAxes(ViewRotation,X,Y,Z);
		Acceleration=newAccel;
		SwimAnimUpdate(X Dot Acceleration <= 0);
		bUpAndOut=(X Dot Acceleration > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		if ( bUpAndOut &&  !Region.Zone.bWaterZone && CheckWaterJump(Temp) )
		{
			Velocity.Z=330.00 + 2 * CollisionRadius;
			PlayDuck();
			GotoState('PlayerWalking');
		}
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator OldRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector newAccel;
		local float Speed2D;
	
		GetAxes(ViewRotation,X,Y,Z);
		aForward *= 0.20;
		aStrafe *= 0.10;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		aUp *= 0.10;
		newAccel=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		if (  !bShowMenu )
		{
			Speed2D=Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob=Y * Bob * 0.50 * Speed2D * Sin(4.00 * Level.TimeSeconds);
			WalkBob.Z=Bob * 1.50 * Speed2D * Sin(8.00 * Level.TimeSeconds);
		}
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,2.00);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,newAccel,0,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,newAccel,0,OldRotation - Rotation);
		}
		bPressedJump=False;
	}
	
	function Timer ()
	{
		if (  !Region.Zone.bWaterZone && (Role == 4) )
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
		Disable('Timer');
	}
	
	function BeginState ()
	{
		Disable('Timer');
		if (  !IsAnimating() )
		{
			TweenToWaiting(0.30);
		}
	}
	
}

state PlayerFlying
{
	function AnimEnd ()
	{
		PlaySwimming();
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(Rotation,X,Y,Z);
		aForward *= 0.20;
		aStrafe *= 0.20;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		Acceleration=aForward * X + aStrafe * Y;
		UpdateRotation(DeltaTime,2.00);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
	}
	
	function BeginState ()
	{
		SetPhysics(4);
		if (  !IsAnimating() )
		{
			PlayWalking();
		}
	}
	
}

state CheatFlying
{
	ignores  TakeDamage;
	
	function AnimEnd ()
	{
		PlaySwimming();
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		Acceleration=Normal(newAccel) * 550;
		MoveSmooth(Acceleration * DeltaTime);
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(ViewRotation,X,Y,Z);
		aForward *= 0.10;
		aStrafe *= 0.10;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		aUp *= 0.10;
		Acceleration=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		UpdateRotation(DeltaTime,1.00);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
	}
	
	function BeginState ()
	{
		EyeHeight=BaseEyeHeight;
		SetPhysics(0);
		if (  !IsAnimating() )
		{
			PlaySwimming();
		}
	}
	
}

state PlayerWaiting
{
	ignores  Died, TakeDamage;
	
	exec function Jump (optional float F)
	{
	}
	
	exec function Suicide ()
	{
	}
	
	function ChangeTeam (int N)
	{
		Level.Game.ChangeTeam(self,N);
	}
	
	exec function Fire (optional float F)
	{
		bReadyToPlay= !bReadyToPlay;
	}
	
	exec function AltFire (optional float F)
	{
		bReadyToPlay= !bReadyToPlay;
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		Acceleration=newAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(ViewRotation,X,Y,Z);
		aForward *= 0.10;
		aStrafe *= 0.10;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		aUp *= 0.10;
		Acceleration=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		UpdateRotation(DeltaTime,1.00);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
	}
	
	function EndState ()
	{
		Mesh=Default.Mesh;
		PlayerReplicationInfo.bIsSpectator=False;
		SetCollision(True,True,True);
	}
	
	function BeginState ()
	{
		Mesh=None;
		PlayerReplicationInfo.bIsSpectator=True;
		SetCollision(False,False,False);
		EyeHeight=BaseEyeHeight;
		SetPhysics(0);
	}
	
}

state PlayerSpectating
{
	ignores  Died, TakeDamage;
	
	exec function Suicide ()
	{
	}
	
	function SendVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID, name broadcasttype)
	{
	}
	
	exec function AltFire (optional float F)
	{
		bBehindView=False;
		ViewTarget=None;
		ClientMessage("Now viewing from own camera",'Event',True);
	}
	
	function ChangeTeam (int N)
	{
		Level.Game.ChangeTeam(self,N);
	}
	
	exec function Fire (optional float F)
	{
		if ( Role == 4 )
		{
			ViewPlayerNum(-1);
			bBehindView=True;
		}
	}
	
	function ProcessMove (float DeltaTime, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		Acceleration=newAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(ViewRotation,X,Y,Z);
		aForward *= 0.10;
		aStrafe *= 0.10;
		aLookUp *= 0.24;
		aTurn *= 0.24;
		aUp *= 0.10;
		Acceleration=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		UpdateRotation(DeltaTime,1.00);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Acceleration,0,rot(0,0,0));
		}
	}
	
	function EndState ()
	{
		Mesh=Default.Mesh;
		SetCollision(True,True,True);
	}
	
	function BeginState ()
	{
		Mesh=None;
		SetCollision(False,False,False);
		EyeHeight=BaseEyeHeight;
		SetPhysics(0);
	}
	
}

state PlayerWaking
{
	ignores  SwitchWeapon, KilledBy;
	
	function Timer ()
	{
		BaseEyeHeight=Default.BaseEyeHeight;
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		ViewFlash(DeltaTime * 0.50);
		if ( TimerRate == 0 )
		{
			ViewRotation.Pitch -= DeltaTime * 12000;
			if ( ViewRotation.Pitch < 0 )
			{
				ViewRotation.Pitch=0;
				GotoState('PlayerWalking');
			}
		}
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),0,rot(0,0,0));
		}
	}
	
	function BeginState ()
	{
		if ( bWokeUp )
		{
			ViewRotation.Pitch=0;
			SetTimer(0.00,False);
			return;
		}
		BaseEyeHeight=0.00;
		EyeHeight=0.00;
		SetTimer(3.00,False);
		bWokeUp=True;
	}
	
}

state Dying expands Dying
{
	ignores  SwitchWeapon, KilledBy;
	
	exec function Fire (optional float F)
	{
		if ( Role < 4 )
		{
			return;
		}
		if ( (Level.NetMode == 0) &&  !Level.Game.bDeathMatch )
		{
			if ( bFrozen )
			{
				return;
			}
			ShowLoadMenu();
		}
		else
		{
			ServerReStartPlayer();
		}
	}
	
	exec function AltFire (optional float F)
	{
		Fire(F);
	}
	
	function ServerMove (float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbPressedJump, bool bFired, bool bAltFired, EDodgeDir DodgeMove, byte ClientRoll, int View)
	{
		if ( NewbPressedJump )
		{
			Fire(0.00);
		}
		Global.ServerMove(TimeStamp,Accel,ClientLoc,NewbRun,NewbDuck,NewbPressedJump,bFired,bAltFired,DodgeMove,ClientRoll,View);
	}
	
	function PlayerCalcView (out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
	{
		local Vector View;
		local Vector HitLocation;
		local Vector HitNormal;
		local Vector FirstHit;
		local Vector spot;
		local float DesiredDist;
		local float ViewDist;
		local float WallOutDist;
		local Actor HitActor;
		local Pawn PTarget;
	
		if ( ViewTarget != None )
		{
			ViewActor=ViewTarget;
			CameraLocation=ViewTarget.Location;
			CameraRotation=ViewTarget.Rotation;
			PTarget=Pawn(ViewTarget);
			if ( PTarget != None )
			{
				if ( Level.NetMode == 3 )
				{
					if ( PTarget.bIsPlayer )
					{
						PTarget.ViewRotation=TargetViewRotation;
					}
					PTarget.EyeHeight=TargetEyeHeight;
					if ( PTarget.Weapon != None )
					{
						PTarget.Weapon.PlayerViewOffset=TargetWeaponViewOffset;
					}
				}
				if ( PTarget.bIsPlayer )
				{
					CameraRotation=PTarget.ViewRotation;
				}
				CameraLocation.Z += PTarget.EyeHeight;
			}
			if ( Carcass(ViewTarget) != None )
			{
				if ( ViewTarget.Physics == 0 )
				{
					CameraRotation=ViewRotation;
				}
				else
				{
					ViewRotation=CameraRotation;
				}
			}
			else
			{
				if ( bBehindView )
				{
					CalcBehindView(CameraLocation,CameraRotation,180.00);
				}
			}
			return;
		}
		CameraRotation=ViewRotation;
		DesiredFOV=DefaultFOV;
		ViewActor=self;
		if ( bBehindView )
		{
			ViewDist=190.00;
			if ( MoveTarget != None )
			{
				spot=MoveTarget.Location;
			}
			else
			{
				spot=Location;
			}
			View=vect(1.00,0.00,0.00) >> CameraRotation;
			HitActor=Trace(HitLocation,HitNormal,spot - ViewDist * vector(CameraRotation),spot,False,vect(12.00,12.00,2.00));
			if ( HitActor != None )
			{
				CameraLocation=HitLocation;
			}
			else
			{
				CameraLocation=spot - ViewDist * View;
			}
		}
		else
		{
			CameraLocation=Location;
			CameraLocation.Z += Default.BaseEyeHeight;
		}
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		if (  !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0.00);
			}
			GetAxes(ViewRotation,X,Y,Z);
			aLookUp *= 0.24;
			aTurn *= 0.24;
			ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
			ViewRotation.Pitch=ViewRotation.Pitch & 65535;
			if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
			{
				if ( aLookUp > 0 )
				{
					ViewRotation.Pitch=18000;
				}
				else
				{
					ViewRotation.Pitch=49152;
				}
			}
			if ( Role < 4 )
			{
				ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),0,rot(0,0,0));
			}
			bPressedJump=False;
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
	}
	
	function FindGoodView ()
	{
		local Vector cameraLoc;
		local Rotator cameraRot;
		local int tries;
		local int besttry;
		local float bestDist;
		local float newdist;
		local int startYaw;
		local Actor ViewActor;
	
		ViewRotation.Pitch=56000;
		tries=0;
		besttry=0;
		bestDist=0.00;
		startYaw=ViewRotation.Yaw;
		tries=0;
	JL0040:
		if ( tries < 16 )
		{
			cameraLoc=Location;
			PlayerCalcView(ViewActor,cameraLoc,cameraRot);
			newdist=VSize(cameraLoc - Location);
			if ( newdist > bestDist )
			{
				bestDist=newdist;
				besttry=tries;
			}
			ViewRotation.Yaw += 4096;
			tries++;
			goto JL0040;
		}
		ViewRotation.Yaw=startYaw + besttry * 4096;
	}
	
	function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
	{
		if (  !bHidden )
		{
			Super.TakeDamage(Damage,instigatedBy,HitLocation,Momentum,DamageType);
		}
	}
	
	function Timer ()
	{
		bFrozen=False;
		bShowScores=True;
		bPressedJump=False;
	}
	
	function BeginState ()
	{
		bBehindView=True;
		bFrozen=True;
		bPressedJump=False;
		FindGoodView();
		if ( (Role == 4) &&  !bHidden )
		{
			Timer();
		}
		SetTimer(1.00,False);
	}
	
	function EndState ()
	{
		bBehindView=False;
		bShowScores=False;
		if ( Carcass(ViewTarget) != None )
		{
			ViewTarget=None;
		}
	}
	
}

state GameEnded expands GameEnded
{
	ignores  Suicide, Died, TakeDamage, KilledBy;
	
	exec function ViewClass (Class<Actor> aClass, optional bool bQuiet)
	{
	}
	
	exec function ViewPlayer (string S)
	{
	}
	
	exec function Fire (optional float F)
	{
		if ( Role < 4 )
		{
			return;
		}
		if (  !bFrozen )
		{
			ServerReStartGame();
		}
	}
	
	exec function AltFire (optional float F)
	{
		Fire(F);
	}
	
	event PlayerTick (float DeltaTime)
	{
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(DeltaTime);
	}
	
	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		GetAxes(ViewRotation,X,Y,Z);
		if (  !bFrozen && (bPressedJump || (bFire == 1) || (bAltFire == 1)) )
		{
			ServerReStartGame();
		}
		if (  !bFixedCamera )
		{
			aLookUp *= 0.24;
			aTurn *= 0.24;
			ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
			ViewRotation.Pitch=ViewRotation.Pitch & 65535;
			if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
			{
				if ( aLookUp > 0 )
				{
					ViewRotation.Pitch=18000;
				}
				else
				{
					ViewRotation.Pitch=49152;
				}
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		if ( Role < 4 )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),0,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),0,rot(0,0,0));
		}
		bPressedJump=False;
	}
	
	function FindGoodView ()
	{
		local Vector cameraLoc;
		local Rotator cameraRot;
		local int tries;
		local int besttry;
		local float bestDist;
		local float newdist;
		local int startYaw;
		local Actor ViewActor;
	
		ViewRotation.Pitch=56000;
		tries=0;
		besttry=0;
		bestDist=0.00;
		startYaw=ViewRotation.Yaw;
		tries=0;
	JL0040:
		if ( tries < 16 )
		{
			if ( ViewTarget != None )
			{
				cameraLoc=ViewTarget.Location;
			}
			else
			{
				cameraLoc=Location;
			}
			PlayerCalcView(ViewActor,cameraLoc,cameraRot);
			newdist=VSize(cameraLoc - Location);
			if ( newdist > bestDist )
			{
				bestDist=newdist;
				besttry=tries;
			}
			ViewRotation.Yaw += 4096;
			tries++;
			goto JL0040;
		}
		ViewRotation.Yaw=startYaw + besttry * 4096;
	}
	
	function Timer ()
	{
		bFrozen=False;
	}
	
	function BeginState ()
	{
		EndZoom();
		AnimRate=0.00;
		bFire=0;
		bAltFire=0;
		SetCollision(False,False,False);
		bShowScores=True;
		bFrozen=True;
		if (  !bFixedCamera )
		{
			FindGoodView();
			bBehindView=True;
		}
		SetTimer(1.50,False);
		SetPhysics(0);
	}
	
}

defaultproperties
{
    DodgeClickTime=0.25
    Bob=0.02
    FlashScale=(X=1.00,Y=1.00,Z=1.00)
    DesiredFOV=90.00
    DefaultFOV=90.00
    CdTrack=255
    MyAutoAim=1.00
    Handedness=-1.00
    bAlwaysMouseLook=True
    bMessageBeep=True
    MouseSensitivity=3.00
    NetSpeed=2600
    LanSpeed=20000
    MouseSmoothThreshold=0.16
    MaxTimeMargin=1.00
    QuickSaveString="Quick Saving"
    NoPauseMessage="Game is not pauseable"
    ViewingFrom="Now viewing from "
    OwnCamera="own camera"
    FailedView="Failed to change view."
    CantChangeNameMsg="You can't change your name during a global logged game."
    bIsPlayer=True
    bCanJump=True
    DesiredSpeed=0.30
    SightRadius=4100.00
    bTravel=True
    bStasis=False
    NetPriority=8.00
}