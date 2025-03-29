//================================================================================
// SPPlayer.
//================================================================================
class SPPlayer expands PlayerPawn
	native
	config(User);

var(SPCharacter) localized string CharacterName;
var(SPCharacter) localized string Age;
var(SPCharacter) localized string Nationality;
var(SPCharacter) localized string Specialties;
var(SPCharacter) localized string Quirks;
var() localized string LevelNames[60];
var() localized string EntryMapName;
var() localized string BaseMapName;
var() localized string LevelDisplayText;
var() localized string NotAllowedMessage;
var globalconfig string PlayedLevels[60];
var globalconfig string FinishedLevels[60];
var() globalconfig string AutoSaveFlags[10];
var globalconfig int AutoSavedLevels[10];
var globalconfig string PlayerName;
var globalconfig int CurPlayerIndex;
var int Score;
var SPTutorial tutorial;
var SPTurretInterface TurretInterface;
var SPCameraInterface CameraInterface;
var bool bUsingTurret;
var bool bUsingCamera;
var bool bPortableCam;
var float curFOV;
var float origFOV;
var bool bZoom;
var int ZoomDir;
var() float Charge;
var() bool IsSourceCharge;
var() bool IgnoreGravityInChargeZone;
var() bool ApplyDrag;
var() float DragCoefficient;
var Actor LockedTarget;
var input byte bReelIn;
var input byte bReelOut;
var bool engageTractorBeam;

replication
{
	reliable if ( Role < 4 )
		Taunt0,Taunt9,Taunt8,Taunt7,Taunt6,Taunt5,Taunt4,Taunt3,Taunt2,Taunt1;
	reliable if ( Role == 4 )
		AdventureLinkGameOver,AdventureLinkStartGame;
	un?reliable if ( Role == 4 )
		Charge;
}

function ClientReStart ()
{
	Super.ClientReStart();
	PlayReSpawnSpeech();
}

simulated function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	local SPHud HUD;

	if ( DamageType == 'drowned' )
	{
		return;
	}
	else
	{
		if ( DamageType == 'stomped' )
		{
			return;
		}
		else
		{
			if ( (DamageType == 'pushedInHead') || (DamageType == 'pushed') )
			{
				PlaySound(Sound'playwosh',3,1.00);
				PlayHitByPlayerSpeech();
				if ( SelectedItem != None )
				{
					SelectedItem.Activate();
				}
			}
		}
	}
	Super.TakeDamage(Damage,instigatedBy,HitLocation,5 * Momentum,DamageType);
	HUD=SPHud(myHUD);
	if ( (HUD != None) && (DamageType == 'caught') )
	{
		PlayerHitByGuardSpeech();
		HUD.ShowStunGraphic();
	}
}

event Touch (Actor Other)
{
	local SPHud HUD;

	if ( Other.IsA('SPPushProjectile') && (Other.Owner != self) )
	{
		HUD=SPHud(myHUD);
		if ( HUD != None )
		{
			HUD.ShowStunGraphic();
		}
	}
	Super.Touch(Other);
}

event PlayerInput (float DeltaTime)
{
	local Vector newTargetLocation;
	local float targetDistance;
	local bool bReleaseTarget;
	local SPDelayedCommand dc;

	if ( engageTractorBeam && (LockedTarget == None) )
	{
		LockOnTarget();
	}
	else
	{
		if (  !engageTractorBeam && (LockedTarget != None) )
		{
			bReleaseTarget=True;
		}
	}
	if ( LockedTarget != None )
	{
		targetDistance=VSize(LockedTarget.Location - OldLocation);
		if ( bReelIn != 0 )
		{
			targetDistance -= 100;
		}
		if ( bReelOut != 0 )
		{
			targetDistance += 100;
		}
		newTargetLocation=Location + targetDistance * vector(ViewRotation);
		if ( bReleaseTarget == False )
		{
			LockedTarget.Move(newTargetLocation - LockedTarget.Location);
		}
		else
		{
			LockedTarget.Velocity=(newTargetLocation - LockedTarget.Location) / DeltaTime;
			ReleaseTarget();
			bReleaseTarget=False;
		}
	}
	if ( tutorial != None )
	{
		tutorial.PlayerInput(self);
	}
	if ( bDelayedCommand )
	{
		bDelayedCommand=False;
		dc=Spawn(Class'SPDelayedCommand');
		dc.Initialize(self,DelayedCommand,0.05);
		DelayedCommand="";
	}
	Super.PlayerInput(DeltaTime);
}

exec function LockOnTarget ()
{
	local Vector HitLocation;
	local Vector HitNormal;
	local Actor Actor;

	Actor=Trace(HitLocation,HitNormal,Location + 10000 * vector(ViewRotation));
	if ( SPActor(Actor) != None )
	{
		LockedTarget=SPActor(Actor);
	}
	else
	{
		if ( SPPawn(Actor) != None )
		{
			LockedTarget=SPPawn(Actor);
		}
		else
		{
			if ( SPPlayer(Actor) != None )
			{
				LockedTarget=SPPlayer(Actor);
			}
		}
	}
	LockedTarget.SetPhysics(0);
}

exec function ReleaseTarget ()
{
	LockedTarget.SetPhysics(2);
	LockedTarget.bBounce=True;
	LockedTarget=None;
}

exec function Summon (string ClassName)
{
	local Class<Actor> NewClass;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( InStr(ClassName,".") == -1 )
	{
		ClassName="Spore." $ ClassName;
	}
	Super.Summon(ClassName);
}

exec function QuickSave ()
{
	local int gameNum;
	local string saveName;
	local SPMenu M;

	if ( (Health > 0) && (Level.NetMode == 0) &&  !Level.Game.bDeathMatch && (CurPlayerIndex != -1) )
	{
		gameNum=CurPlayerIndex * 10 + 8;
		if ( Level.Minute < 10 )
		{
			saveName=Level.Title $ " " $ string(Level.Hour) $ ":0" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
		}
		else
		{
			saveName=Level.Title $ " " $ string(Level.Hour) $ ":" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
		}
		M=Spawn(Class'SPMenu');
		M.GameNames[gameNum]=saveName;
		M.SaveConfig();
		M.Destroy();
		if ( SPConsole(Player.Console) != None )
		{
			SPConsole(Player.Console).NextLevel=saveName;
		}
		ClientMessage(" ");
		bDelayedCommand=True;
		DelayedCommand="SaveGame " $ string(gameNum);
	}
}

exec function QuickLoad ()
{
	local int gameNum;
	local SPMenu M;

	if ( (Level.NetMode == 0) &&  !Level.Game.bDeathMatch )
	{
		M=Spawn(Class'SPMenu');
		gameNum=CurPlayerIndex * 10 + 8;
		if ( M.GameNames[gameNum] ~= M.UnusedSaveGameString )
		{
			Log("Can't load that game - it doesn't exist");
			M.Destroy();
			return;
		}
		if ( SPConsole(Player.Console) != None )
		{
			SPConsole(Player.Console).NextLevel=M.GameNames[gameNum];
		}
		M.Destroy();
		ClientTravel("?load=" $ string(gameNum),0,False);
	}
}

exec function ShallowAutoSave ()
{
	local int levelNum;
	local int i;
	local bool bSavable;

	if ( (CurPlayerIndex < 0) || (CurPlayerIndex > 9) )
	{
		if ( CurPlayerIndex != -1 )
		{
			Log(string(self) $ "::ShallowAutoSave <ERROR> CurPlayerIndex out of range!!!");
		}
		return;
	}
	if ( Level.NetMode != 0 )
	{
		return;
	}
	i=0;
JL008A:
	if ( i < 60 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			bSavable=True;
			levelNum=i + 1;
		}
		else
		{
			i++;
			goto JL008A;
		}
	}
	if ( bSavable )
	{
		AutoSavedLevels[CurPlayerIndex]=levelNum;
		AutoSaveFlags[CurPlayerIndex]="Shallow";
		SaveConfig();
	}
}

exec function AutoSave ()
{
	local int gameNum;
	local int i;
	local bool bSavable;
	local string saveName;
	local string MapName;
	local SPMenu M;

	if ( (CurPlayerIndex < 0) || (CurPlayerIndex > 9) )
	{
		if ( CurPlayerIndex != -1 )
		{
			Log(string(self) $ "::AutoSave <ERROR> CurPlayerIndex out of range!!!");
		}
		return;
	}
	gameNum=CurPlayerIndex * 10 + 9;
	MapName=Level.Title;
	if ( Level.Minute < 10 )
	{
		saveName=MapName $ " " $ string(Level.Hour) $ ":0" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
	}
	else
	{
		saveName=MapName $ " " $ string(Level.Hour) $ ":" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
	}
	if ( SPConsole(Player.Console) != None )
	{
		SPConsole(Player.Console).NextLevel=saveName;
	}
	if ( Level.NetMode != 0 )
	{
		return;
	}
	i=0;
JL01C4:
	if ( i < 60 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			bSavable=True;
		}
		else
		{
			i++;
			goto JL01C4;
		}
	}
	if ( bSavable )
	{
		gameNum=CurPlayerIndex * 10 + 9;
		ConsoleCommand("SaveGame " $ string(gameNum));
		AutoSaveFlags[CurPlayerIndex]="Full";
		SaveConfig();
	}
	M=Spawn(Class'SPMenu');
	M.GameNames[gameNum]=saveName;
	M.SaveConfig();
	M.Destroy();
}

exec function AutoSaveAndQuit ()
{
	AutoSave();
	PlayerName="";
	CurPlayerIndex=-1;
	SaveConfig();
	ConsoleCommand("exit");
}

exec function AutoSaveAndJoin (string URL)
{
	local SPConsole C;

	AutoSave();
	C=SPConsole(Player.Console);
	if ( C != None )
	{
		C.NextLevel="";
	}
	ClientTravel(URL,0,False);
}

exec function LaunchBall (string ClassName)
{
	local Class<SPBall> NewBall;
	local Actor Actor;

	if ( InStr(ClassName,".") == -1 )
	{
		ClassName="Spore." $ ClassName;
	}
	NewBall=Class<SPBall>(DynamicLoadObject(ClassName,Class'Class'));
	if ( NewBall != None )
	{
		Actor=Spawn(NewBall,,,Location + 2 * 72 * vector(Rotation) + vect(0.00,0.00,1.00) * 15);
		Actor.Velocity=1000 * vector(ViewRotation);
	}
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	curFOV=DefaultFOV;
	origFOV=DefaultFOV;
	MarkLevelPlayed();
	LoopAnim('chill');
	if ( PlayerName != "" )
	{
		PlayerReplicationInfo.PlayerName=PlayerName;
	}
	foreach AllActors(Class'SPTutorial',tutorial)
	{
		goto JL005E;
	}
	ShallowAutoSave();
}

function string FindNextLevelName ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 59 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			return LevelNames[i + 1];
		}
		i++;
		goto JL0007;
	}
	return "Unknown Map";
}

function string GetLevelName (int Index)
{
	if ( (Index >= 0) && (Index < 60) )
	{
		return LevelNames[Index];
	}
	else
	{
		return "";
	}
}

function string GetPlayedLevelString (int Index)
{
	if ( (Index >= 0) && (Index < 60) )
	{
		return PlayedLevels[Index];
	}
	else
	{
		return "";
	}
}

function int GetLevelIndex ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 60 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			return i;
		}
		i++;
		goto JL0007;
	}
	return -1;
}

function string GetFinishedLevelString (int Index)
{
	if ( (Index >= 0) && (Index < 60) )
	{
		return FinishedLevels[Index];
	}
	else
	{
		return "";
	}
}

function MarkLevelPlayed ()
{
	local int i;
	local int levelIndex;
	local int P;
	local bool bFoundLevel;
	local string Temp;
	local string lString;
	local string rString;

	if ( (CurPlayerIndex < 0) || (CurPlayerIndex > 9) )
	{
		return;
	}
	i=0;
JL0022:
	if ( i < 60 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			bFoundLevel=True;
			levelIndex=i;
		}
		else
		{
			i++;
			goto JL0022;
		}
	}
	if ( bFoundLevel )
	{
		if ( PlayedLevels[levelIndex] == "" )
		{
			PlayedLevels[levelIndex]="OOOOOOOOOO";
		}
		P=CurPlayerIndex;
		lString=Left(PlayedLevels[levelIndex],P);
		rString=Right(PlayedLevels[levelIndex],10 - P + 1);
		Temp=lString $ "X" $ rString;
		PlayedLevels[levelIndex]=Temp;
		SaveConfig();
	}
}

function MarkLevelFinished ()
{
	local int i;
	local int levelIndex;
	local int P;
	local bool bFoundLevel;
	local string Temp;
	local string lString;
	local string rString;

	if ( (CurPlayerIndex < 0) || (CurPlayerIndex > 9) )
	{
		return;
	}
	i=0;
JL0022:
	if ( i < 60 )
	{
		if ( LevelNames[i] ~= Level.Title )
		{
			bFoundLevel=True;
			levelIndex=i;
		}
		else
		{
			i++;
			goto JL0022;
		}
	}
	if ( bFoundLevel )
	{
		if ( FinishedLevels[levelIndex] == "" )
		{
			FinishedLevels[levelIndex]="OOOOOOOOOO";
		}
		P=CurPlayerIndex;
		lString=Left(FinishedLevels[levelIndex],P);
		rString=Right(FinishedLevels[levelIndex],10 - P + 1);
		Temp=lString $ "X" $ rString;
		FinishedLevels[levelIndex]=Temp;
		SaveConfig();
	}
}

function MarkLevelUnfinished (int Level, int Player)
{
	local string Temp;
	local string lString;
	local string rString;

	if ( FinishedLevels[Level] == "" )
	{
		FinishedLevels[Level]="OOOOOOOOOO";
	}
	lString=Left(FinishedLevels[Level],Player);
	rString=Right(FinishedLevels[Level],10 - Player + 1);
	Temp=lString $ "O" $ rString;
	FinishedLevels[Level]=Temp;
}

function MarkLevelUnplayed (int Level, int Player)
{
	local string Temp;
	local string lString;
	local string rString;

	if ( PlayedLevels[Level] == "" )
	{
		PlayedLevels[Level]="OOOOOOOOOO";
	}
	lString=Left(PlayedLevels[Level],Player);
	rString=Right(PlayedLevels[Level],10 - Player + 1);
	Temp=lString $ "O" $ rString;
	PlayedLevels[Level]=Temp;
}

exec function NextMesh ()
{
	if ( Mesh == LodMesh'brain' )
	{
		Mesh=LodMesh'Alyia';
	}
	else
	{
		if ( Mesh == LodMesh'Alyia' )
		{
			Mesh=LodMesh'brain';
		}
	}
}

exec function UseTurret (bool bUse)
{
	local SPTurret turret;

	if ( bUse )
	{
		if ( TurretInterface != None )
		{
			TurretInterface.BeginOperating(self);
			bUsingTurret=True;
			if ( Weapon != None )
			{
				Weapon.DrawType=0;
			}
		}
	}
	else
	{
		if ( TurretInterface != None )
		{
			TurretInterface.StopOperating(self);
			bUsingTurret=False;
			if ( Weapon != None )
			{
				Weapon.DrawType=2;
			}
		}
	}
}

exec function UseCamera (bool bUse)
{
	local SPCamera cam;

	if ( bUse )
	{
		if ( CameraInterface != None )
		{
			CameraInterface.BeginOperating(self);
			cam=CameraInterface.GetCamera();
			if ( cam != None )
			{
				ViewTarget=cam;
				myHUD=None;
				HUDType=Class'SPMonitorHUD';
				bUsingCamera=True;
			}
		}
	}
	else
	{
		if ( CameraInterface != None )
		{
			CameraInterface.StopOperating(self);
			ViewTarget=None;
		}
		myHUD=None;
		HUDType=Class'SPHud';
		curFOV=origFOV;
		SetFOVAngle(curFOV);
		SetDesiredFOV(curFOV);
	}
}

exec function Fire (optional float F)
{
	if ( bUsingTurret && (TurretInterface != None) )
	{
		TurretInterface.Fire(F);
	}
	else
	{
		if ( bUsingCamera && (CameraInterface != None) )
		{
			bZoom=True;
			ZoomDir=1;
			SetTimer(0.05,True);
		}
		else
		{
			Super.Fire(F);
		}
	}
}

exec function AltFire (optional float F)
{
	if ( bUsingCamera && (CameraInterface != None) )
	{
		bZoom=True;
		ZoomDir=-1;
		SetTimer(0.05,True);
	}
	else
	{
		Super.AltFire(F);
	}
}

event Timer ()
{
	if ( bZoom )
	{
		if ( (bFire != 0) || (bAltFire != 0) )
		{
			curFOV += 3 * ZoomDir;
			curFOV=FClamp(curFOV,1.00,170.00);
			SetDesiredFOV(curFOV);
		}
		else
		{
			SetTimer(0.00,False);
			bZoom=False;
		}
	}
	else
	{
		SetTimer(0.00,False);
	}
}

event BaseChange ()
{
	if ( (Base == None) ||  !Base.IsA('SPTurretInterface') )
	{
		if ( TurretInterface != None )
		{
			TurretInterface.Disconnect(self);
			TurretInterface=None;
		}
	}
	if ( (Base == None) ||  !Base.IsA('SPCameraInterface') )
	{
		if ( (CameraInterface != None) &&  !bPortableCam )
		{
			CameraInterface.Disconnect(self);
			CameraInterface=None;
		}
	}
	if ( Base != None )
	{
		if ( Base.IsA('SPTurretInterface') )
		{
			if ( TurretInterface == None )
			{
				TurretInterface=SPTurretInterface(Base);
				TurretInterface.Connect(self);
			}
		}
		else
		{
			if ( Base.IsA('SPCameraInterface') )
			{
				if ( CameraInterface == None )
				{
					CameraInterface=SPCameraInterface(Base);
					CameraInterface.Connect(self);
					bPortableCam=False;
				}
			}
			else
			{
				if ( Base.IsA('SPFlyer') )
				{
					SPFlyer(Base).Player=self;
				}
			}
		}
	}
}

function Landed (Vector HitNormal)
{
	PlayLanded(Velocity.Z);
	bJustLanded=True;
}

function int IncrementScore ()
{
	PlayerReplicationInfo.Score += 1;
	return PlayerReplicationInfo.Score;
}

function AdventureLinkStartGame ()
{
	bShowScores=False;
	Scoring=None;
	ScoringType=Level.Game.ScoreBoardType;
	bShowScores=True;
}

function AdventureLinkGameOver ()
{
	Scoring=None;
	ScoringType=Class'SPGameOverScoreBoard';
	bShowScores=True;
}

exec function SetPlayerCharge (float q)
{
	Charge=q;
}

state PlayerWalking expands PlayerWalking
{
	exec function FeignDeath ()
	{
	}
	
}

exec function GiveUp ()
{
	local Teleporter t;
	local SPConsole C;

	C=SPConsole(Player.Console);
	if ( C != None )
	{
		C.NextLevel=FindNextLevelName();
	}
	foreach AllActors(Class'Teleporter',t)
	{
		t.Touch(self);
	}
}

exec function ShowMessage (int Num)
{
	local SPHud HUD;

	HUD=SPHud(myHUD);
	if ( HUD == None )
	{
		return;
	}
	HUD.StartMessage(Num);
}

exec function ToggleMessage ()
{
	local SPHud HUD;

	HUD=SPHud(myHUD);
	if ( HUD == None )
	{
		return;
	}
	HUD.ToggleMessage();
}

exec function NextMessage ()
{
	local SPHud HUD;

	HUD=SPHud(myHUD);
	if ( HUD == None )
	{
		return;
	}
	HUD.NextMessage();
}

exec function PrevMessage ()
{
	local SPHud HUD;

	HUD=SPHud(myHUD);
	if ( HUD == None )
	{
		return;
	}
	HUD.PrevMessage();
}

exec function DisplayLevelName ()
{
	ClientMessage(LevelDisplayText $ " " $ Level.Title);
}

exec function Say (string Msg)
{
}

exec function TeamSay (string Msg)
{
}

exec function SysCom (string Msg)
{
	Say(Msg);
}

exec function Speak (coerce string Name)
{
	local SPBrain B;

	foreach AllActors(Class'SPBrain',B)
	{
		goto JL0014;
	}
	if ( B == None )
	{
		return;
	}
	B.Speak(Name);
}

function Died (Pawn Killer, name DamageType, Vector HitLocation)
{
	Super.Died(Killer,DamageType,HitLocation);
	RestartLevel();
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local InterpolationPoint i;

	foreach AllActors(Class'InterpolationPoint',i,'Path')
	{
		if ( i.Position == 0 )
		{
			SetCollision(False,False,False);
			Target=i;
			SetPhysics(8);
			PhysRate=1.00;
			PhysAlpha=0.00;
			bInterpolating=True;
		}
	}
}

function PlayTurning ()
{
}

function TweenToWalking (float TweenTime)
{
	TweenAnim('run',TweenTime);
}

function TweenToRunning (float TweenTime)
{
	TweenAnim('run',TweenTime);
}

function PlayWalking ()
{
	LoopAnim('run');
}

function PlayRunning ()
{
	PlayAnim('run');
}

function PlayRising ()
{
	TweenAnim('chill',0.20);
}

function PlayFeignDeath ()
{
}

function PlayDying (name DamageType, Vector HitLoc)
{
	PlayAnim('ko',0.20);
}

function PlayGutHit (float TweenTime)
{
	PlayAnim('ko',0.20);
}

function PlayHeadHit (float TweenTime)
{
	PlayAnim('ko',0.20);
}

function PlayLeftHit (float TweenTime)
{
	PlayAnim('ko',0.20);
}

function PlayRightHit (float TweenTime)
{
	PlayAnim('ko',0.20);
}

function PlayLanded (float impactVel)
{
	Super.PlayLanded(impactVel);
	PlayAnim('Land');
}

function PlayInAir ()
{
	PlayAnim('Jump',0.50);
}

function PlayDuck ()
{
}

function PlayCrawling ()
{
}

function TweenToWaiting (float TweenTime)
{
	TweenAnim('chill',TweenTime);
}

function PlayWaiting ()
{
	ViewRotation.Pitch=ViewRotation.Pitch & 65535;
	if ( (ViewRotation.Pitch > RotationRate.Pitch) && (ViewRotation.Pitch < 65536 - RotationRate.Pitch) )
	{
		if ( ViewRotation.Pitch < 32768 )
		{
			TweenAnim('lookup',0.30);
		}
		else
		{
			TweenAnim('lookdown',0.30);
		}
	}
	else
	{
		if ( (AnimSequence == 'lookup') || (AnimSequence == 'lookdown') )
		{
			TweenToWaiting(0.30);
		}
		else
		{
			LoopAnim('chill',0.20);
		}
	}
}

function PlayFiring ()
{
	PlayAnim('chillfire');
}

function PlayWeaponSwitch (Weapon NewWeapon)
{
	PlayAnim('ko',0.20);
}

function PlaySwimming ()
{
	PlayAnim('ko',0.20);
}

function TweenToSwimming (float TweenTime)
{
	TweenAnim('ko',0.20);
}

function Carcass SpawnCarcass ()
{
}

simulated function PlayFootStep ()
{
}

simulated function PlayLeftFootStep ()
{
}

simulated function PlayRightFootStep ()
{
}

function PlayDyingSound ()
{
}

function PlayTakeHitSound (int Damage, name DamageType, int Mult)
{
}

function ClientPlayTakeHit (float TweenTime, Vector HitLoc, int Damage, bool bServerGuessWeapon)
{
}

function Gasp ()
{
}

function PlayHit (float Damage, Vector HitLocation, name DamageType, float MomentumZ)
{
}

function PlayDeathHit (float Damage, Vector HitLocation, name DamageType)
{
}

exec function FilterSay (string Msg)
{
	local SPTextFilter Filter;

	Filter=Spawn(Class'SPTextFilter');
	if ( Filter.TextAllowed(Msg) )
	{
		Say(Msg);
	}
	else
	{
		ClientMessage(NotAllowedMessage);
	}
	Filter.Destroy();
}

exec function TimeDemo (bool bActivate, optional bool bSaveToFile, optional int QuitAfterCycles)
{
	Player.Console.bTimeDemo=bActivate;
	Super.TimeDemo(bActivate,bSaveToFile,QuitAfterCycles);
}

function PlaySporeSpeech (string SpeechName)
{
	local Sound snd;

	snd=Sound(DynamicLoadObject("SporeSpeech." $ SpeechName,Class'Sound'));
	PlaySound(snd,5);
}

exec function Taunt1 ()
{
}

exec function Taunt2 ()
{
}

exec function Taunt3 ()
{
}

exec function Taunt4 ()
{
}

exec function Taunt5 ()
{
}

exec function Taunt6 ()
{
}

exec function Taunt7 ()
{
}

exec function Taunt8 ()
{
}

exec function Taunt9 ()
{
}

exec function Taunt0 ()
{
}

simulated function PlayCaptureFlagSpeech ()
{
}

simulated function PlayCaptureCravenSpeech ()
{
}

simulated function PlayCaptureCFOSpeech ()
{
}

simulated function PlayCaptureCSOSpeech ()
{
}

simulated function PlayHitByPlayerSpeech ()
{
}

simulated function PlayReSpawnSpeech ()
{
}

simulated function PlayerHitByGuardSpeech ()
{
}

state Dying expands Dying
{
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
		bBehindView=False;
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
	
}

defaultproperties
{
    LevelNames(0)="01: Simple Lessons"
    LevelNames(1)="02: Security Break"
    LevelNames(2)="03: Tracking Termination"
    LevelNames(3)="04: Flying Lessons"
    LevelNames(4)="05: Open Says-Me"
    LevelNames(5)="06: One Wrong Step"
    LevelNames(6)="07: Unlocking Safety"
    LevelNames(7)="08: The Bad Seed"
    LevelNames(8)="09: Communication Down"
    LevelNames(9)="10: Running on Empty"
    LevelNames(10)="11: Turnabout"
    LevelNames(11)="12: Infiltration"
    LevelNames(12)="13: Sundowner"
    LevelNames(13)="14: Distraction"
    LevelNames(14)="15: Distraction 2"
    LevelNames(15)="16: SPORE Revealed"
    LevelNames(16)="17: Dirty Water"
    LevelNames(17)="18: Run-through"
    LevelNames(18)="19: Simple Favor"
    LevelNames(19)="20: Cleaning Crew"
    LevelNames(20)="21: Spinning Wheels"
    LevelNames(21)="22: Heave-Ho"
    LevelNames(22)="23: Anti-Air"
    LevelNames(23)="24: Move It"
    LevelNames(24)="25: Sure Shot"
    LevelNames(25)="26: Leap-Cog"
    LevelNames(26)="27: Dead Eye"
    LevelNames(27)="28: Highs and Lows"
    LevelNames(28)="29: Bug in the System"
    LevelNames(29)="30: Distraction 3"
    LevelNames(30)="31: Navigation Sabotage"
    LevelNames(31)="32: Thruster Down"
    LevelNames(32)="33: Crossing the Moat"
    LevelNames(33)="34: Mixed Drinks"
    LevelNames(34)="35: Path Clearing"
    LevelNames(35)="36: Make or Break"
    LevelNames(36)="37: Force-Feed"
    LevelNames(37)="38: Break-Through"
    LevelNames(38)="39: One Man Army"
    LevelNames(39)="40: Pistons"
    LevelNames(40)="41: Run Like the wind"
    LevelNames(41)="42: Threading the Needle"
    LevelNames(42)="43: Skullduggery"
    LevelNames(43)="44: Outer Sanctum"
    LevelNames(44)="45: Capture"
    LevelNames(45)="The End"
    EntryMapName="Entry"
    BaseMapName="Base"
    LevelDisplayText="You are on level"
    NotAllowedMessage="You can't say that"
    AutoSaveFlags(0)="None"
    AutoSaveFlags(1)="None"
    AutoSaveFlags(2)="None"
    AutoSaveFlags(3)="None"
    AutoSaveFlags(4)="None"
    AutoSaveFlags(5)="None"
    AutoSaveFlags(6)="None"
    AutoSaveFlags(7)="None"
    AutoSaveFlags(8)="None"
    AutoSaveFlags(9)="None"
    IgnoreGravityInChargeZone=True
    ApplyDrag=True
    DragCoefficient=0.00
    bCanStrafe=True
    MeleeRange=50.00
    GroundSpeed=400.00
    AirSpeed=400.00
    AccelRate=2048.00
    BaseEyeHeight=20.00
    UnderWaterTime=20.00
    Intelligence=BRAINS_REPTILE
    Land=Sound'SPPlayer.land01'
    AnimSequence=chill
    DrawType=DT_Sprite
    Mesh=LodMesh'Alyia'
    CollisionRadius=17.00
    CollisionHeight=50.00
    LightBrightness=70
    LightHue=40
    LightSaturation=128
    LightRadius=6
    RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
}