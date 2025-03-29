//================================================================================
// Pawn.
//================================================================================
class Pawn expands Actor
	native
	abstract;

enum EIntelligence {
	BRAINS_NONE,
	BRAINS_REPTILE,
	BRAINS_MAMMAL,
	BRAINS_HUMAN
};

enum EAttitude {
	ATTITUDE_Fear,
	ATTITUDE_Hate,
	ATTITUDE_Frenzy,
	ATTITUDE_Threaten,
	ATTITUDE_Ignore,
	ATTITUDE_Friendly,
	ATTITUDE_Follow
};

var bool bBehindView;
var bool bIsPlayer;
var bool bJustLanded;
var bool bUpAndOut;
var bool bIsWalking;
var const bool bHitSlopedWall;
var travel bool bNeverSwitchOnPickup;
var bool bWarping;
var bool bUpdatingDisplay;
var(Combat) bool bCanStrafe;
var(Orders) bool bFixedStart;
var const bool bReducedSpeed;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanOpenDoors;
var bool bCanDoSpecial;
var bool bDrowning;
var const bool bLOSflag;
var bool bFromWall;
var bool bHunting;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bJumpOffPawn;
var bool bShootSpecial;
var bool bAutoActivate;
var bool bIsHuman;
var bool bIsFemale;
var bool bIsMultiSkinned;
var bool bCountJumps;
var float SightCounter;
var float PainTime;
var float SpeechTime;
var const float AvgPhysicsTime;
var PointRegion FootRegion;
var PointRegion HeadRegion;
var float MoveTimer;
var Actor MoveTarget;
var Actor FaceTarget;
var Vector Destination;
var Vector Focus;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var(Combat) float MeleeRange;
var(Movement) float GroundSpeed;
var(Movement) float WaterSpeed;
var(Movement) float AirSpeed;
var(Movement) float AccelRate;
var(Movement) float JumpZ;
var(Movement) float MaxStepHeight;
var(Movement) float AirControl;
var float MinHitWall;
var() byte Visibility;
var float Alertness;
var float Stimulus;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var(AI) float HearingThreshold;
var Vector LastSeenPos;
var Vector LastSeeingPos;
var float LastSeenTime;
var Pawn Enemy;
var travel Weapon Weapon;
var Weapon PendingWeapon;
var travel Inventory SelectedItem;
var Rotator ViewRotation;
var Vector WalkBob;
var() float BaseEyeHeight;
var float EyeHeight;
var const Vector Floor;
var float SplashTime;
var float OrthoZoom;
var() float FovAngle;
var int DieCount;
var int ItemCount;
var int KillCount;
var int SecretCount;
var int Spree;
var() travel int Health;
var() name ReducedDamageType;
var() float ReducedDamagePct;
var() Class<Inventory> DropWhenKilled;
var(Movement) float UnderWaterTime;
var(AI) EAttitude AttitudeToPlayer;
var(AI) EIntelligence Intelligence;
var(AI) float Skill;
var Actor SpecialGoal;
var float SpecialPause;
var const Vector noise1spot;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const Vector noise2spot;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var float LastPainSound;
var const Pawn nextPawn;
var(Sounds) Sound HitSound1;
var(Sounds) Sound HitSound2;
var(Sounds) Sound Land;
var(Sounds) Sound Die;
var(Sounds) Sound WaterStep;
var input byte bZoom;
var input byte bRun;
var input byte bLook;
var input byte bDuck;
var input byte bSnapLevel;
var input byte bStrafe;
var input byte bFire;
var input byte bAltFire;
var input byte bFreeLook;
var input byte bExtra0;
var input byte bExtra1;
var input byte bExtra2;
var input byte bExtra3;
var(Combat) float CombatStyle;
var NavigationPoint home;
var name NextState;
var name NextLabel;
var float SoundDampening;
var float DamageScaling;
var(Orders) name AlarmTag;
var(Orders) name SharedAlarmTag;
var Decoration carriedDecoration;
var name PlayerReStartState;
var() localized string MenuName;
var() localized string NameArticle;
var() byte VoicePitch;
var() Class<VoicePack> VoiceType;
var float OldMessageTime;
var NavigationPoint RouteCache[16];
var() Class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var PlayerReplicationInfo PlayerReplicationInfo;

replication
{
	unreliable if ( Role < 4 )
		SwitchToBestWeapon,NextItem,SendVoiceMessage,TeamBroadcast,bExtra0,bExtra1,bExtra2,bExtra3;
	unreliable if ( (Role == 4) &&  !bDemoRecording )
		ClientHearSound;
	reliable if ( (Role == 4) && (RemoteRole == 3) )
		ClientGameEnded,ClientReStart,ClientDying,ClientSetRotation,ClientSetLocation;
	reliable if ( (Role == 4) &&  !bDemoRecording )
		ClientVoiceMessage,TeamMessage,ClientMessage;
	un?reliable if ( (Role == 4) && bNetOwner )
		bBehindView,bIsPlayer,GroundSpeed,WaterSpeed,AirSpeed,AccelRate,JumpZ,MaxStepHeight,AirControl,SelectedItem,carriedDecoration;
	un?reliable if ( Role == 4 )
		bCanFly;
	un?reliable if ( (Role == 4) && bNetOwner )
		MoveTarget;
	un?reliable if ( Role == 4 )
		Weapon,Health,PlayerReplicationInfo;
	un?reliable if ( (Role == 4) && bNetOwner && bIsPlayer && bNetInitial || bDemoRecording )
		ViewRotation;
	un?reliable if ( bDemoRecording )
		EyeHeight;
	un?reliable if ( Role < 3 )
		bZoom,bRun,bLook,bDuck,bSnapLevel,bStrafe;
}

native(500) final latent function MoveTo (Vector NewDestination, optional float speed);

native(502) final latent function MoveToward (Actor NewTarget, optional float speed);

native(504) final latent function StrafeTo (Vector NewDestination, Vector NewFocus);

native(506) final latent function StrafeFacing (Vector NewDestination, Actor NewTarget);

native(508) final latent function TurnTo (Vector NewFocus);

native(510) final latent function TurnToward (Actor NewTarget);

native(514) final function bool LineOfSightTo (Actor Other);

native(533) final function bool CanSee (Actor Other);

native(518) final function Actor FindPathTo (Vector aPoint, optional bool bSinglePath, optional bool bClearPaths);

native(517) final function Actor FindPathToward (Actor anActor, optional bool bSinglePath, optional bool bClearPaths);

native(525) final function NavigationPoint FindRandomDest (optional bool bClearPaths);

native(522) final function ClearPaths ();

native(523) final function Vector EAdjustJump ();

native(521) final function bool pointReachable (Vector aPoint);

native(520) final function bool actorReachable (Actor anActor);

native(526) final function bool PickWallAdjust ();

native(524) final function int FindStairRotation (float DeltaTime);

native(527) final latent function WaitForLanding ();

native(540) final function Actor FindBestInventoryPath (out float MinWeight, bool bPredictRespawns);

native(529) final function AddPawn ();

native(530) final function RemovePawn ();

native(531) final function Pawn PickTarget (out float bestAim, out float bestDist, Vector FireDir, Vector projStart);

native(534) final function Actor PickAnyTarget (out float bestAim, out float bestDist, Vector FireDir, Vector projStart);

native function StopWaiting ();

event MayFall ();

simulated event RenderOverlays (Canvas Canvas)
{
	if ( Weapon != None )
	{
		Weapon.RenderOverlays(Canvas);
	}
}

function string GetHumanName ()
{
	if ( PlayerReplicationInfo != None )
	{
		return PlayerReplicationInfo.PlayerName;
	}
	return NameArticle $ MenuName;
}

function SetDisplayProperties (ERenderStyle NewStyle, Texture NewTexture, bool bLighting, bool bEnviroMap)
{
	Style=NewStyle;
	Texture=NewTexture;
	bUnlit=bLighting;
	bMeshEnviroMap=bEnviroMap;
	if (  !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay=True;
		Inventory.SetOwnerDisplay();
	}
	if ( Weapon != None )
	{
		Weapon.SetDisplayProperties(Style,Texture,bUnlit,bMeshEnviroMap);
	}
	bUpdatingDisplay=False;
}

function SetDefaultDisplayProperties ()
{
	Style=Default.Style;
	Texture=Default.Texture;
	bUnlit=Default.bUnlit;
	bMeshEnviroMap=Default.bMeshEnviroMap;
	if (  !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay=True;
		Inventory.SetOwnerDisplay();
	}
	if ( Weapon != None )
	{
		Weapon.SetDisplayProperties(Style,Texture,bUnlit,bMeshEnviroMap);
	}
	bUpdatingDisplay=False;
}

event ClientMessage (coerce string S, optional name Type, optional bool bBeep);

event TeamMessage (PlayerReplicationInfo PRI, coerce string S, name Type);

event FellOutOfWorld ()
{
	Health=-1;
	SetPhysics(0);
	Died(None,'fell',Location);
}

function PlayRecoil (float Rate);

function SpecialFire ();

function bool CheckFutureSight (float DeltaTime)
{
	return True;
}

function RestartPlayer ();

function TeamBroadcast (coerce string Msg)
{
	local Pawn P;
	local bool bGlobal;

	if ( Left(Msg,1) ~= "@" )
	{
		Msg=Right(Msg,Len(Msg) - 1);
		bGlobal=True;
	}
	if ( Left(Msg,1) ~= "." )
	{
		Msg="." $ string(VoicePitch) $ Msg;
	}
	if ( bGlobal ||  !Level.Game.bTeamGame )
	{
		if ( Level.Game.AllowsBroadcast(self,Len(Msg)) )
		{
			P=Level.PawnList;
JL00B6:
			if ( P != None )
			{
				if ( P.bIsPlayer )
				{
					P.TeamMessage(PlayerReplicationInfo,Msg,'Say');
				}
				P=P.nextPawn;
				goto JL00B6;
			}
		}
		return;
	}
	if ( Level.Game.AllowsBroadcast(self,Len(Msg)) )
	{
		P=Level.PawnList;
JL0141:
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
			goto JL0141;
		}
	}
}

function SendVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID, name broadcasttype)
{
	local Pawn P;
	local bool bNoSpeak;

	if ( Level.TimeSeconds - OldMessageTime < 2.50 )
	{
		bNoSpeak=True;
	}
	else
	{
		OldMessageTime=Level.TimeSeconds;
	}
	P=Level.PawnList;
JL0052:
	if ( P != None )
	{
		if ( P.IsA('PlayerPawn') )
		{
			if (  !bNoSpeak )
			{
				if ( (broadcasttype == 'Global') ||  !Level.Game.bTeamGame )
				{
					P.ClientVoiceMessage(Sender,Recipient,messagetype,messageID);
				}
				else
				{
					if ( Sender.Team == P.PlayerReplicationInfo.Team )
					{
						P.ClientVoiceMessage(Sender,Recipient,messagetype,messageID);
					}
				}
			}
		}
		else
		{
			if ( (P.PlayerReplicationInfo == Recipient) || (messagetype == 'ORDER') && (Recipient == None) )
			{
				P.BotVoiceMessage(messagetype,messageID,self);
			}
		}
		P=P.nextPawn;
		goto JL0052;
	}
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID);

function BotVoiceMessage (name messagetype, byte messageID, Pawn Sender);

function HandleHelpMessageFrom (Pawn Other);

function FearThisSpot (Actor ASpot);

function float GetRating ()
{
	return 1000.00;
}

function AddVelocity (Vector NewVelocity)
{
	if ( Physics == 1 )
	{
		SetPhysics(2);
	}
	if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
	{
		NewVelocity.Z *= 0.50;
	}
	Velocity += NewVelocity;
}

function ClientSetLocation (Vector NewLocation, Rotator NewRotation)
{
	local Pawn P;

	ViewRotation=NewRotation;
	NewRotation.Pitch=0;
	NewRotation.Roll=0;
	SetRotation(NewRotation);
	SetLocation(NewLocation);
}

function ClientSetRotation (Rotator NewRotation)
{
	local Pawn P;

	ViewRotation=NewRotation;
	NewRotation.Pitch=0;
	NewRotation.Roll=0;
	SetRotation(NewRotation);
}

function ClientDying (name DamageType, Vector HitLocation)
{
	PlayDying(DamageType,HitLocation);
	GotoState('Dying');
}

function ClientReStart ()
{
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	BaseEyeHeight=Default.BaseEyeHeight;
	EyeHeight=BaseEyeHeight;
	PlayWaiting();
	if ( Region.Zone.bWaterZone )
	{
		if ( HeadRegion.Zone.bWaterZone )
		{
			PainTime=UnderWaterTime;
		}
		SetPhysics(3);
		GotoState('PlayerSwimming');
	}
	else
	{
		GotoState(PlayerReStartState);
	}
}

function ClientGameEnded ()
{
	GotoState('GameEnded');
}

function float AdjustDesireFor (Inventory Inv)
{
	return 0.00;
}

function TossWeapon ()
{
	local Vector X;
	local Vector Y;
	local Vector Z;

	if ( Weapon == None )
	{
		return;
	}
	GetAxes(Rotation,X,Y,Z);
	Weapon.DropFrom(Location + 0.80 * CollisionRadius * X +  -0.50 * CollisionRadius * Y);
}

exec function NextItem ()
{
	local Inventory Inv;

	if ( SelectedItem == None )
	{
		SelectedItem=Inventory.SelectNext();
		return;
	}
	if ( SelectedItem.Inventory != None )
	{
		SelectedItem=SelectedItem.Inventory.SelectNext();
	}
	else
	{
		SelectedItem=Inventory.SelectNext();
	}
	if ( SelectedItem == None )
	{
		SelectedItem=Inventory.SelectNext();
	}
}

function Inventory FindInventoryType (Class DesiredClass)
{
	local Inventory Inv;

	Inv=Inventory;
JL000B:
	if ( Inv != None )
	{
		if ( Inv.Class == DesiredClass )
		{
			return Inv;
		}
		Inv=Inv.Inventory;
		goto JL000B;
	}
	return None;
}

function bool AddInventory (Inventory NewItem)
{
	local Inventory Inv;

	assert (NewItem != None);
	Inv=Inventory;
JL0016:
	if ( Inv != None )
	{
		if ( Inv == NewItem )
		{
			return False;
		}
		Inv=Inv.Inventory;
		goto JL0016;
	}
	NewItem.SetOwner(self);
	NewItem.Inventory=Inventory;
	Inventory=NewItem;
	return True;
}

function bool DeleteInventory (Inventory Item)
{
	local Actor Link;

	if ( Item == Weapon )
	{
		Weapon=None;
	}
	if ( Item == SelectedItem )
	{
		SelectedItem=None;
	}
	Link=self;
JL0033:
	if ( Link != None )
	{
		if ( Link.Inventory == Item )
		{
			Link.Inventory=Item.Inventory;
		}
		else
		{
			Link=Link.Inventory;
			goto JL0033;
		}
	}
	Item.SetOwner(None);
}

function ChangedWeapon ()
{
	local Weapon OldWeapon;

	OldWeapon=Weapon;
	if ( Weapon == PendingWeapon )
	{
		if ( Weapon == None )
		{
			SwitchToBestWeapon();
		}
		else
		{
			if ( Weapon.GetStateName() == 'DownWeapon' )
			{
				Weapon.BringUp();
			}
		}
		PendingWeapon=None;
		return;
	}
	if ( PendingWeapon == None )
	{
		PendingWeapon=Weapon;
	}
	PlayWeaponSwitch(PendingWeapon);
	if ( (PendingWeapon != None) && (PendingWeapon.Mass > 20) && (carriedDecoration != None) )
	{
		DropDecoration();
	}
	if ( Weapon != None )
	{
		Weapon.SetDefaultDisplayProperties();
	}
	Weapon=PendingWeapon;
	Inventory.ChangedWeapon();
	if ( Weapon != None )
	{
		Weapon.RaiseUp(OldWeapon);
		if ( (Level.Game != None) && (Level.Game.Difficulty > 1) )
		{
			MakeNoise(0.10 * Level.Game.Difficulty);
		}
	}
	PendingWeapon=None;
}

event bool EncroachingOn (Actor Other)
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
	{
		return True;
	}
	if ( ( !bIsPlayer || bWarping) && (Pawn(Other) != None) )
	{
		return True;
	}
	return False;
}

event EncroachedBy (Actor Other)
{
	if ( Pawn(Other) != None )
	{
		gibbedBy(Other);
	}
}

function gibbedBy (Actor Other)
{
	local Pawn instigatedBy;

	instigatedBy=Pawn(Other);
	if ( instigatedBy == None )
	{
		instigatedBy=Other.Instigator;
	}
	Health=-1000;
	Died(instigatedBy,'Gibbed',Location);
}

event PlayerTimeout ()
{
	if ( Health > 0 )
	{
		Died(None,'suicided',Location);
	}
}

function JumpOffPawn ()
{
	Velocity += 60 * VRand();
	Velocity.Z=180.00;
	SetPhysics(2);
}

function UnderLift (Mover M);

singular event BaseChange ()
{
	local float decorMass;

	if ( (Base == None) && (Physics == 0) )
	{
		SetPhysics(2);
	}
	else
	{
		if ( Pawn(Base) != None )
		{
			Base.TakeDamage((1 - Velocity.Z / 400) * Mass / Base.Mass,self,Location,0.50 * Velocity,'stomped');
			JumpOffPawn();
		}
		else
		{
			if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
			{
				decorMass=FMax(Decoration(Base).Mass,1.00);
				Base.TakeDamage(-2 * Mass / decorMass * Velocity.Z / 400,self,Location,0.50 * Velocity,'stomped');
			}
		}
	}
}

event LongFall ();

event Destroyed ()
{
	local Inventory Inv;

	RemovePawn();
	Inv=Inventory;
JL000E:
	if ( Inv != None )
	{
		Inv.Destroy();
		Inv=Inv.Inventory;
		goto JL000E;
	}
	if ( bIsPlayer && (Level.Game != None) )
	{
		Level.Game.Logout(self);
	}
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.Destroy();
	}
	Super.Destroyed();
}

native simulated event ClientHearSound (Actor Actor, int Id, Sound S, Vector SoundLocation, Vector Parameters);

event PreBeginPlay ()
{
	AddPawn();
	Super.PreBeginPlay();
	if ( bDeleteMe )
	{
		return;
	}
	Instigator=self;
	DesiredRotation=Rotation;
	SightCounter=0.20 * FRand();
	if ( Level.Game != None )
	{
		Skill += Level.Game.Difficulty;
	}
	Skill=FClamp(Skill,0.00,3.00);
	PreSetMovement();
	if ( DrawScale != Default.DrawScale )
	{
		SetCollisionSize(CollisionRadius * DrawScale / Default.DrawScale,CollisionHeight * DrawScale / Default.DrawScale);
		Health=Health * DrawScale / Default.DrawScale;
	}
	if ( bIsPlayer )
	{
		if ( PlayerReplicationInfoClass != None )
		{
			PlayerReplicationInfo=Spawn(PlayerReplicationInfoClass,self);
		}
		else
		{
			PlayerReplicationInfo=Spawn(Class'PlayerReplicationInfo',self);
		}
		InitPlayerReplicationInfo();
	}
	if (  !bIsPlayer )
	{
		if ( BaseEyeHeight == 0 )
		{
			BaseEyeHeight=0.80 * CollisionHeight;
		}
		EyeHeight=BaseEyeHeight;
		if ( Fatness == 0 )
		{
			Fatness=120 + Rand(8) + Rand(8);
		}
	}
	if ( MenuName == "" )
	{
		MenuName=GetItemName(string(Class));
	}
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	SplashTime=0.00;
}

function PreSetMovement ()
{
	if ( JumpZ > 0 )
	{
		bCanJump=True;
	}
	bCanWalk=True;
	bCanSwim=False;
	bCanFly=False;
	MinHitWall=-0.60;
	if ( Intelligence > 1 )
	{
		bCanOpenDoors=True;
	}
	if ( Intelligence == 3 )
	{
		bCanDoSpecial=True;
	}
}

static function SetMultiSkin (Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{
	local Texture NewSkin;

	if ( SkinName != "" )
	{
		NewSkin=Texture(DynamicLoadObject(SkinName,Class'Texture'));
		if ( NewSkin != None )
		{
			SkinActor.Skin=NewSkin;
		}
	}
}

static function GetMultiSkin (Actor SkinActor, out string SkinName, out string FaceName)
{
	SkinName=string(SkinActor.Skin);
	FaceName="";
}

static function bool SetSkinElement (Actor SkinActor, int SkinNo, string SkinName, string DefaultSkinName)
{
	local Texture NewSkin;

	NewSkin=Texture(DynamicLoadObject(SkinName,Class'Texture'));
	if ( NewSkin != None )
	{
		SkinActor.MultiSkins[SkinNo]=NewSkin;
		return True;
	}
	else
	{
		if ( DefaultSkinName != "" )
		{
			NewSkin=Texture(DynamicLoadObject(DefaultSkinName,Class'Texture'));
			SkinActor.MultiSkins[SkinNo]=NewSkin;
		}
		return False;
	}
}

function InitPlayerReplicationInfo ()
{
	if ( PlayerReplicationInfo.PlayerName == "" )
	{
		PlayerReplicationInfo.PlayerName="Player";
	}
}

function PlayRunning ()
{
}

function PlayWalking ()
{
	PlayRunning();
}

function PlayWaiting ()
{
}

function PlayMovingAttack ()
{
	PlayRunning();
}

function PlayWaitingAmbush ()
{
	PlayWaiting();
}

function TweenToFighter (float TweenTime)
{
}

function TweenToRunning (float TweenTime)
{
	TweenToFighter(0.10);
}

function TweenToWalking (float TweenTime)
{
	TweenToRunning(TweenTime);
}

function TweenToPatrolStop (float TweenTime)
{
	TweenToFighter(TweenTime);
}

function TweenToWaiting (float TweenTime)
{
	TweenToFighter(TweenTime);
}

function PlayThreatening ()
{
	TweenToFighter(0.10);
}

function PlayPatrolStop ()
{
	PlayWaiting();
}

function PlayTurning ()
{
	TweenToFighter(0.10);
}

function PlayBigDeath (name DamageType);

function PlayHeadDeath (name DamageType);

function PlayLeftDeath (name DamageType);

function PlayRightDeath (name DamageType);

function PlayGutDeath (name DamageType);

function PlayDying (name DamageType, Vector HitLoc)
{
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector HitVec;
	local Vector HitVec2D;
	local float dotp;

	if ( Velocity.Z > 250 )
	{
		PlayBigDeath(DamageType);
		return;
	}
	if ( DamageType == 'Decapitated' )
	{
		PlayHeadDeath(DamageType);
		return;
	}
	GetAxes(Rotation,X,Y,Z);
	X.Z=0.00;
	HitVec=Normal(HitLoc - Location);
	HitVec2D=HitVec;
	HitVec2D.Z=0.00;
	dotp=HitVec2D Dot X;
	if ( HitLoc.Z - Location.Z > 0.50 * CollisionHeight )
	{
		if ( dotp > 0 )
		{
			PlayHeadDeath(DamageType);
		}
		else
		{
			PlayGutDeath(DamageType);
		}
		return;
	}
	if ( dotp > 0.71 )
	{
		PlayGutDeath(DamageType);
	}
	else
	{
		dotp=HitVec Dot Y;
		if ( dotp > 0.00 )
		{
			PlayLeftDeath(DamageType);
		}
		else
		{
			PlayRightDeath(DamageType);
		}
	}
}

function PlayGutHit (float TweenTime)
{
	Log("Error - play gut hit must be implemented in subclass of" @ string(Class));
}

function PlayHeadHit (float TweenTime)
{
	PlayGutHit(TweenTime);
}

function PlayLeftHit (float TweenTime)
{
	PlayGutHit(TweenTime);
}

function PlayRightHit (float TweenTime)
{
	PlayGutHit(TweenTime);
}

function FireWeapon ();

function Actor TraceShot (out Vector HitLocation, out Vector HitNormal, Vector EndTrace, Vector StartTrace)
{
	local Vector realHit;
	local Actor Other;

	Other=Trace(HitLocation,HitNormal,EndTrace,StartTrace,True);
	if ( Pawn(Other) != None )
	{
		realHit=HitLocation;
		if (  !Pawn(Other).AdjustHitLocation(HitLocation,EndTrace - StartTrace) )
		{
			Other=Pawn(Other).TraceShot(HitLocation,HitNormal,EndTrace,realHit);
		}
	}
	return Other;
}

function bool AdjustHitLocation (out Vector HitLocation, Vector TraceDir)
{
	local float adjZ;
	local float maxZ;

	TraceDir=Normal(TraceDir);
	HitLocation=HitLocation + 0.40 * CollisionRadius * TraceDir;
	if ( (GetAnimGroup(AnimSequence) == 'Ducking') && (AnimFrame > -0.03) )
	{
		maxZ=Location.Z + 0.25 * CollisionHeight;
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
	}
	return True;
}

function PlayTakeHit (float TweenTime, Vector HitLoc, int Damage)
{
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector HitVec;
	local Vector HitVec2D;
	local float dotp;

	GetAxes(Rotation,X,Y,Z);
	X.Z=0.00;
	HitVec=Normal(HitLoc - Location);
	HitVec2D=HitVec;
	HitVec2D.Z=0.00;
	dotp=HitVec2D Dot X;
	if ( HitLoc.Z - Location.Z > 0.50 * CollisionHeight )
	{
		if ( dotp > 0 )
		{
			PlayHeadHit(TweenTime);
		}
		else
		{
			PlayGutHit(TweenTime);
		}
		return;
	}
	if ( dotp > 0.71 )
	{
		PlayGutHit(TweenTime);
	}
	else
	{
		if ( dotp < -0.71 )
		{
			PlayHeadHit(TweenTime);
		}
		else
		{
			dotp=HitVec Dot Y;
			if ( dotp > 0.00 )
			{
				PlayLeftHit(TweenTime);
			}
			else
			{
				PlayRightHit(TweenTime);
			}
		}
	}
}

function PlayVictoryDance ()
{
	TweenToFighter(0.10);
}

function PlayOutOfWater ()
{
	TweenToFalling();
}

function PlayDive ();

function TweenToFalling ();

function PlayInAir ();

function PlayDuck ();

function PlayCrawling ();

function PlayLanded (float impactVel)
{
	local float landVol;

	landVol=impactVel / JumpZ;
	landVol=0.00 * Mass * landVol * landVol;
	PlaySound(Land,3,FMin(20.00,landVol));
}

function PlayFiring ();

function PlayWeaponSwitch (Weapon NewWeapon);

function TweenToSwimming (float TweenTime);

function PlayTakeHitSound (int Damage, name DamageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.25 )
	{
		return;
	}
	if ( HitSound1 == None )
	{
		return;
	}
	LastPainSound=Level.TimeSeconds;
	if ( FRand() < 0.50 )
	{
		PlaySound(HitSound1,2,FMax(Mult * TransientSoundVolume,Mult * 2.00));
	}
	else
	{
		PlaySound(HitSound2,2,FMax(Mult * TransientSoundVolume,Mult * 2.00));
	}
}

function Gasp ();

function DropDecoration ()
{
	if ( carriedDecoration != None )
	{
		carriedDecoration.bWasCarried=True;
		carriedDecoration.SetBase(None);
		carriedDecoration.SetPhysics(2);
		carriedDecoration.Velocity=Velocity + 10 * VRand();
		carriedDecoration.Instigator=self;
		carriedDecoration=None;
	}
}

function GrabDecoration ()
{
	local Vector lookDir;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector T1;
	local Vector T2;
	local Vector Extent;
	local Actor HitActor;

	if ( carriedDecoration == None )
	{
		lookDir=vector(Rotation);
		lookDir.Z=0.00;
		T1=Location + BaseEyeHeight * vect(0.00,0.00,1.00) + lookDir * 0.80 * CollisionRadius;
		T2=T1 + lookDir * 1.20 * CollisionRadius;
		HitActor=Trace(HitLocation,HitNormal,T2,T1,True);
		if ( HitActor == None )
		{
			T1=T2 - (BaseEyeHeight + CollisionHeight - 2) * vect(0.00,0.00,1.00);
			HitActor=Trace(HitLocation,HitNormal,T1,T2,True);
		}
		else
		{
			if ( HitActor == Level )
			{
				T2=HitLocation - lookDir;
				T1=T2 - (BaseEyeHeight + CollisionHeight - 2) * vect(0.00,0.00,1.00);
				HitActor=Trace(HitLocation,HitNormal,T1,T2,True);
			}
		}
		if ( (HitActor == None) || (HitActor == Level) )
		{
			Extent.X=CollisionRadius;
			Extent.Y=CollisionRadius;
			Extent.Z=CollisionHeight;
			HitActor=Trace(HitLocation,HitNormal,Location + lookDir * 1.20 * CollisionRadius,Location,True,Extent);
		}
		if ( Mover(HitActor) != None )
		{
			if ( Mover(HitActor).bUseTriggered )
			{
				HitActor.Trigger(self,self);
			}
		}
		else
		{
			if ( (Decoration(HitActor) != None) && ((Weapon == None) || (Weapon.Mass < 20)) )
			{
				carriedDecoration=Decoration(HitActor);
				if (  !carriedDecoration.bPushable || (carriedDecoration.Mass > 40) || (carriedDecoration.StandingCount > 0) )
				{
					carriedDecoration=None;
					return;
				}
				lookDir.Z=0.00;
				if ( carriedDecoration.SetLocation(Location + (0.50 * CollisionRadius + carriedDecoration.CollisionRadius) * lookDir) )
				{
					carriedDecoration.SetPhysics(0);
					carriedDecoration.SetBase(self);
				}
				else
				{
					carriedDecoration=None;
				}
			}
		}
	}
}

function StopFiring ();

function Rotator AdjustAim (float projSpeed, Vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	return ViewRotation;
}

function Rotator AdjustToss (float projSpeed, Vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	return ViewRotation;
}

function WarnTarget (Pawn shooter, float projSpeed, Vector FireDir)
{
}

function SetMovementPhysics ()
{
}

function PlayHit (float Damage, Vector HitLocation, name DamageType, float MomentumZ)
{
}

function PlayDeathHit (float Damage, Vector HitLocation, name DamageType)
{
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	local int actualDamage;
	local bool bAlreadyDead;

	bAlreadyDead=Health <= 0;
	if ( Physics == 0 )
	{
		SetMovementPhysics();
	}
	if ( Physics == 1 )
	{
		Momentum.Z=FMax(Momentum.Z,0.40 * VSize(Momentum));
	}
	if ( instigatedBy == self )
	{
		Momentum *= 0.60;
	}
	Momentum=Momentum / Mass;
	AddVelocity(Momentum);
	if ( Level.Game != None )
	{
		actualDamage=Level.Game.ReduceDamage(Damage,DamageType,self,instigatedBy);
	}
	else
	{
		actualDamage=Damage;
	}
	if ( bIsPlayer )
	{
		if ( ReducedDamageType == 'All' )
		{
			actualDamage=0;
		}
		else
		{
			if ( Inventory != None )
			{
				actualDamage=Inventory.ReduceDamage(actualDamage,DamageType,HitLocation);
			}
			else
			{
				actualDamage=Damage;
			}
		}
	}
	else
	{
		if ( (instigatedBy != None) && (instigatedBy.IsA(Class.Name) || self.IsA(instigatedBy.Class.Name)) )
		{
			actualDamage=actualDamage * FMin(1.00 - ReducedDamagePct,0.35);
		}
		else
		{
			if ( (ReducedDamageType == 'All') || (ReducedDamageType != 'None') && (ReducedDamageType == DamageType) )
			{
				actualDamage=actualDamage * (1 - ReducedDamagePct);
			}
		}
	}
	Health -= actualDamage;
	if ( carriedDecoration != None )
	{
		DropDecoration();
	}
	if ( HitLocation == vect(0.00,0.00,0.00) )
	{
		HitLocation=Location;
	}
	if ( Health > 0 )
	{
		if ( instigatedBy != None )
		{
			damageAttitudeTo(instigatedBy);
		}
		PlayHit(actualDamage,HitLocation,DamageType,Momentum.Z);
	}
	else
	{
		if (  !bAlreadyDead )
		{
			NextState='None';
			PlayDeathHit(actualDamage,HitLocation,DamageType);
			if ( actualDamage > Mass )
			{
				Health=-1 * actualDamage;
			}
			Enemy=instigatedBy;
			Died(instigatedBy,DamageType,HitLocation);
		}
		else
		{
			SpawnGibbedCarcass();
			if ( bIsPlayer )
			{
				HidePlayer();
				GotoState('Dying');
			}
			else
			{
				Destroy();
			}
		}
	}
	MakeNoise(1.00);
}

function Died (Pawn Killer, name DamageType, Vector HitLocation)
{
	local Pawn OtherPawn;
	local Actor A;

	if ( bDeleteMe )
	{
		return;
	}
	Health=Min(0,Health);
	OtherPawn=Level.PawnList;
JL002D:
	if ( OtherPawn != None )
	{
		OtherPawn.Killed(Killer,self,DamageType);
		OtherPawn=OtherPawn.nextPawn;
		goto JL002D;
	}
	if ( carriedDecoration != None )
	{
		DropDecoration();
	}
	Level.Game.Killed(Killer,self,DamageType);
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,Killer);
		}
	}
	Level.Game.DiscardInventory(self);
	Velocity.Z *= 1.30;
	if ( Gibbed(DamageType) )
	{
		SpawnGibbedCarcass();
		if ( bIsPlayer )
		{
			HidePlayer();
		}
		else
		{
			Destroy();
		}
	}
	PlayDying(DamageType,HitLocation);
	if ( Level.Game.bGameEnded )
	{
		return;
	}
	if ( RemoteRole == 3 )
	{
		ClientDying(DamageType,HitLocation);
	}
	GotoState('Dying');
}

function bool Gibbed (name DamageType)
{
	return False;
}

function Carcass SpawnCarcass ()
{
	Log(string(self) $ " should never call base spawncarcass");
	return None;
}

function SpawnGibbedCarcass ()
{
}

function HidePlayer ()
{
	SetCollision(False,False,False);
	TweenToFighter(0.01);
	bHidden=True;
}

event HearNoise (float Loudness, Actor NoiseMaker);

event SeePlayer (Actor Seen);

event UpdateEyeHeight (float DeltaTime);

event EnemyNotVisible ();

function Killed (Pawn Killer, Pawn Other, name DamageType)
{
}

function string KillMessage (name DamageType, Pawn Other)
{
	local string Message;

	Message=Level.Game.CreatureKillMessage(DamageType,Other);
	return Message $ NameArticle $ MenuName;
}

function damageAttitudeTo (Pawn Other);

function Falling ()
{
	PlayInAir();
}

event WalkTexture (Texture Texture, Vector StepLocation, Vector StepNormal);

event Landed (Vector HitNormal)
{
	SetMovementPhysics();
	if (  !IsAnimating() )
	{
		PlayLanded(Velocity.Z);
	}
	if ( Velocity.Z < -1.40 * JumpZ )
	{
		MakeNoise(-0.50 * Velocity.Z / FMax(JumpZ,150.00));
	}
	bJustLanded=True;
}

event FootZoneChange (ZoneInfo newFootZone)
{
	local Actor HitActor;
	local Vector HitNormal;
	local Vector HitLocation;
	local float splashSize;
	local Actor splash;

	if ( Level.NetMode == 3 )
	{
		return;
	}
	if ( Level.TimeSeconds - SplashTime > 0.25 )
	{
		SplashTime=Level.TimeSeconds;
		if ( Physics == 2 )
		{
			MakeNoise(1.00);
		}
		else
		{
			MakeNoise(0.30);
		}
		if ( FootRegion.Zone.bWaterZone )
		{
			if (  !newFootZone.bWaterZone && (Role == 4) )
			{
				if ( FootRegion.Zone.ExitSound != None )
				{
					PlaySound(FootRegion.Zone.ExitSound,3,1.00);
				}
				if ( FootRegion.Zone.ExitActor != None )
				{
					Spawn(FootRegion.Zone.ExitActor,,,Location - CollisionHeight * vect(0.00,0.00,1.00));
				}
			}
		}
		else
		{
			if ( newFootZone.bWaterZone && (Role == 4) )
			{
				splashSize=FClamp(0.00 * Mass * (300 - 0.50 * FMax(-500.00,Velocity.Z)),1.00,4.00);
				if ( newFootZone.EntrySound != None )
				{
					HitActor=Trace(HitLocation,HitNormal,Location - (CollisionHeight + 40) * vect(0.00,0.00,0.80),Location - CollisionHeight * vect(0.00,0.00,0.80),False);
					if ( HitActor == None )
					{
						PlaySound(newFootZone.EntrySound,1,2.00 * splashSize);
					}
					else
					{
						PlaySound(WaterStep,1,1.50 + 0.50 * splashSize);
					}
				}
				if ( newFootZone.EntryActor != None )
				{
					splash=Spawn(newFootZone.EntryActor,,,Location - CollisionHeight * vect(0.00,0.00,1.00));
					if ( splash != None )
					{
						splash.DrawScale=splashSize;
					}
				}
			}
		}
	}
	if ( FootRegion.Zone.bPainZone )
	{
		if (  !newFootZone.bPainZone &&  !HeadRegion.Zone.bWaterZone )
		{
			PainTime=-1.00;
		}
	}
	else
	{
		if ( newFootZone.bPainZone )
		{
			PainTime=0.01;
		}
	}
}

event HeadZoneChange (ZoneInfo newHeadZone)
{
	if ( Level.NetMode == 3 )
	{
		return;
	}
	if ( HeadRegion.Zone.bWaterZone )
	{
		if (  !newHeadZone.bWaterZone )
		{
			if ( bIsPlayer && (PainTime > 0) && (PainTime < 8) )
			{
				Gasp();
			}
			if ( Inventory != None )
			{
				Inventory.ReduceDamage(0,'Breathe',Location);
			}
			bDrowning=False;
			if (  !FootRegion.Zone.bPainZone )
			{
				PainTime=-1.00;
			}
		}
	}
	else
	{
		if ( newHeadZone.bWaterZone )
		{
			if (  !FootRegion.Zone.bPainZone )
			{
				PainTime=UnderWaterTime;
			}
			if ( Inventory != None )
			{
				Inventory.ReduceDamage(0,'drowned',Location);
			}
		}
	}
}

event SpeechTimer ();

event PainTimer ()
{
	local float depth;

	if ( (Health < 0) || (Level.NetMode == 3) )
	{
		return;
	}
	if ( FootRegion.Zone.bPainZone )
	{
		depth=0.40;
		if ( Region.Zone.bPainZone )
		{
			depth += 0.40;
		}
		if ( HeadRegion.Zone.bPainZone )
		{
			depth += 0.20;
		}
		if ( FootRegion.Zone.DamagePerSec > 0 )
		{
			if ( IsA('PlayerPawn') )
			{
				Level.Game.SpecialDamageString=FootRegion.Zone.DamageString;
			}
			TakeDamage(FootRegion.Zone.DamagePerSec * depth,None,Location,vect(0.00,0.00,0.00),FootRegion.Zone.DamageType);
		}
		else
		{
			if ( Health < Default.Health )
			{
				Health=Min(Default.Health,Health - depth * FootRegion.Zone.DamagePerSec);
			}
		}
		if ( Health > 0 )
		{
			PainTime=1.00;
		}
	}
	else
	{
		if ( HeadRegion.Zone.bWaterZone )
		{
			TakeDamage(5,None,Location,vect(0.00,0.00,0.00),'drowned');
			if ( Health > 0 )
			{
				PainTime=2.00;
			}
		}
	}
}

function bool CheckWaterJump (out Vector WallNormal)
{
	local Actor HitActor;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector checkpoint;
	local Vector Start;
	local Vector checkNorm;
	local Vector Extent;

	if ( carriedDecoration != None )
	{
		return False;
	}
	checkpoint=vector(Rotation);
	checkpoint.Z=0.00;
	checkNorm=Normal(checkpoint);
	checkpoint=Location + CollisionRadius * checkNorm;
	Extent=CollisionRadius * vect(1.00,1.00,0.00);
	Extent.Z=CollisionHeight;
	HitActor=Trace(HitLocation,HitNormal,checkpoint,Location,True,Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal=-1 * HitNormal;
		Start=Location;
		Start.Z += 1.10 * MaxStepHeight;
		checkpoint=Start + 2 * CollisionRadius * checkNorm;
		HitActor=Trace(HitLocation,HitNormal,checkpoint,Start,True);
		if ( HitActor == None )
		{
			return True;
		}
	}
	return False;
}

function bool SwitchToBestWeapon ()
{
	local float rating;
	local int usealt;

	if ( Inventory == None )
	{
		return False;
	}
	PendingWeapon=Inventory.RecommendWeapon(rating,usealt);
	if ( PendingWeapon == None )
	{
		return False;
	}
	if ( Weapon == None )
	{
		ChangedWeapon();
	}
	else
	{
		if ( Weapon != PendingWeapon )
		{
			Weapon.PutDown();
		}
	}
	return usealt > 0;
}

state Dying
{
	ignores  LongFall, Died, WarnTarget, KilledBy;
	
	function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
	{
		if ( bDeleteMe )
		{
			return;
		}
		Health=Health - Damage;
		Momentum=Momentum / Mass;
		AddVelocity(Momentum);
		if (  !bHidden && Gibbed(DamageType) )
		{
			bHidden=True;
			SpawnGibbedCarcass();
			if ( bIsPlayer )
			{
				HidePlayer();
			}
			else
			{
				Destroy();
			}
		}
	}
	
	function Timer ()
	{
		if (  !bHidden )
		{
			bHidden=True;
			SpawnCarcass();
			if ( bIsPlayer )
			{
				HidePlayer();
			}
			else
			{
				Destroy();
			}
		}
	}
	
	event Landed (Vector HitNormal)
	{
		SetPhysics(0);
	}
	
	function BeginState ()
	{
		SetTimer(0.30,False);
	}
	
}

state GameEnded
{
	ignores  WarnTarget, TakeDamage, KilledBy;
	
	function BeginState ()
	{
		SetPhysics(0);
		HidePlayer();
	}
	
}

defaultproperties
{
    AvgPhysicsTime=0.10
    MaxDesiredSpeed=1.00
    GroundSpeed=320.00
    WaterSpeed=200.00
    AccelRate=500.00
    JumpZ=325.00
    MaxStepHeight=25.00
    AirControl=0.05
    Visibility=128
    SightRadius=2500.00
    HearingThreshold=1.00
    OrthoZoom=40000.00
    FovAngle=90.00
    Health=100
    AttitudeToPlayer=ATTITUDE_Hate
    Intelligence=BRAINS_MAMMAL
    noise1time=-10.00
    noise2time=-10.00
    SoundDampening=1.00
    DamageScaling=1.00
    PlayerReStartState=PlayerWalking
    NameArticle=" a "
    PlayerReplicationInfoClass=Class'PlayerReplicationInfo'
    bCanTeleport=True
    bIsKillGoal=True
    bStasis=True
    bIsPawn=True
    RemoteRole=ROLE_DumbProxy
    AnimSequence=Fighter
    bDirectional=True
    Texture=Texture'S_Pawn'
    SoundRadius=9
    SoundVolume=240
    TransientSoundVolume=2.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    bProjTarget=True
    bRotateToDesired=True
    RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
    NetPriority=4.00
}