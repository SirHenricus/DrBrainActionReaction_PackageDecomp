//================================================================================
// Weapon.
//================================================================================
class Weapon expands Inventory
	native
	abstract;

var() float MaxTargetRange;
var() Class<Ammo> AmmoName;
var() byte ReloadCount;
var() int PickupAmmoCount;
var travel Ammo AmmoType;
var bool bPointing;
var() bool bInstantHit;
var() bool bAltInstantHit;
var(WeaponAI) bool bWarnTarget;
var(WeaponAI) bool bAltWarnTarget;
var bool bWeaponUp;
var bool bChangeWeapon;
var bool bLockedOn;
var(WeaponAI) bool bSplashDamage;
var() bool bCanThrow;
var(WeaponAI) bool bRecommendSplashDamage;
var() bool bWeaponStay;
var() bool bOwnsCrosshair;
var bool bHideWeapon;
var(WeaponAI) bool bMeleeWeapon;
var() bool bRapidFire;
var bool bTossedOut;
var() float FiringSpeed;
var() Vector FireOffset;
var() Class<Projectile> ProjectileClass;
var() Class<Projectile> AltProjectileClass;
var() name MyDamageType;
var() name AltDamageType;
var float ProjectileSpeed;
var float AltProjectileSpeed;
var float aimerror;
var() float shakemag;
var() float shaketime;
var() float shakevert;
var(WeaponAI) float AIRating;
var(WeaponAI) float RefireRate;
var(WeaponAI) float AltRefireRate;
var() Sound FireSound;
var() Sound AltFireSound;
var() Sound CockingSound;
var() Sound SelectSound;
var() Sound Misc1Sound;
var() Sound Misc2Sound;
var() Sound Misc3Sound;
var() localized string MessageNoAmmo;
var() localized string DeathMessage;
var Rotator AdjustedAim;
var bool bSetFlashTime;
var(MuzzleFlash) bool bDrawMuzzleFlash;
var byte bMuzzleFlash;
var float FlashTime;
var(MuzzleFlash) float MuzzleScale;
var(MuzzleFlash) float FlashY;
var(MuzzleFlash) float FlashO;
var(MuzzleFlash) float FlashC;
var(MuzzleFlash) float FlashLength;
var(MuzzleFlash) int FlashS;
var(MuzzleFlash) Texture MFTexture;
var(MuzzleFlash) Texture MuzzleFlare;
var(MuzzleFlash) float FlareOffset;

replication
{
	un?reliable if ( (Role == 4) && bNetOwner )
		AmmoType,bLockedOn,bHideWeapon;
	un?reliable if ( (Role == 4) && bNetOwner )
		bMuzzleFlash;
}

function Destroyed ()
{
	Super.Destroyed();
	if ( (Pawn(Owner) != None) && (Pawn(Owner).Weapon == self) )
	{
		Pawn(Owner).Weapon=None;
	}
}

event TravelPostAccept ()
{
	Super.TravelPostAccept();
	if ( Pawn(Owner) == None )
	{
		return;
	}
	if ( AmmoName != None )
	{
		AmmoType=Ammo(Pawn(Owner).FindInventoryType(AmmoName));
		if ( AmmoType == None )
		{
			AmmoType=Spawn(AmmoName);
			Pawn(Owner).AddInventory(AmmoType);
			AmmoType.BecomeItem();
			AmmoType.AmmoAmount=PickupAmmoCount;
			AmmoType.GotoState('Idle2');
		}
	}
	if ( self == Pawn(Owner).Weapon )
	{
		if ( Owner.IsA('PlayerPawn') )
		{
			SetHand(PlayerPawn(Owner).Handedness);
		}
		BringUp();
	}
	else
	{
		GotoState('Idle2');
	}
}

simulated event RenderOverlays (Canvas Canvas)
{
	local Rotator NewRot;
	local bool bPlayerOwner;
	local int hand;
	local PlayerPawn PlayerOwner;

	if ( bHideWeapon || (Owner == None) )
	{
		return;
	}
	PlayerOwner=PlayerPawn(Owner);
	if ( PlayerOwner != None )
	{
		bPlayerOwner=True;
		hand=PlayerOwner.Handedness;
	}
	if ( (Level.NetMode == 3) && bPlayerOwner && (hand == 2) )
	{
		bHideWeapon=True;
		return;
	}
	if (  !bPlayerOwner || (PlayerOwner.Player == None) )
	{
		Pawn(Owner).WalkBob=vect(0.00,0.00,0.00);
	}
	if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture != None) )
	{
		MuzzleScale=Default.MuzzleScale * Canvas.ClipX / 640.00;
		if (  !bSetFlashTime )
		{
			bSetFlashTime=True;
			FlashTime=Level.TimeSeconds + FlashLength;
		}
		else
		{
			if ( FlashTime < Level.TimeSeconds )
			{
				bMuzzleFlash=0;
			}
		}
		if ( bMuzzleFlash > 0 )
		{
			if ( hand == 0 )
			{
				Canvas.SetPos(Canvas.ClipX / 2 - MuzzleScale * FlashS + Canvas.ClipX * -0.20 * Default.FireOffset.Y * FlashO,Canvas.ClipY / 2 - MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
			}
			else
			{
				Canvas.SetPos(Canvas.ClipX / 2 - MuzzleScale * FlashS + Canvas.ClipX * hand * Default.FireOffset.Y * FlashO,Canvas.ClipY / 2 - MuzzleScale * FlashS + Canvas.ClipY * FlashY);
			}
			Canvas.Style=3;
			Canvas.DrawIcon(MFTexture,MuzzleScale);
			Canvas.Style=1;
		}
	}
	else
	{
		bSetFlashTime=False;
	}
	SetLocation(Owner.Location + CalcDrawOffset());
	NewRot=Pawn(Owner).ViewRotation;
	if ( hand == 0 )
	{
		NewRot.Roll=-2 * Default.Rotation.Roll;
	}
	else
	{
		NewRot.Roll=Default.Rotation.Roll * hand;
	}
	SetRotation(NewRot);
	Canvas.DrawActor(self,False);
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	SetWeaponStay();
	MaxDesireability=1.20 * AIRating;
	if ( ProjectileClass != None )
	{
		ProjectileSpeed=ProjectileClass.Default.speed;
		MyDamageType=ProjectileClass.Default.MyDamageType;
	}
	if ( AltProjectileClass != None )
	{
		AltProjectileSpeed=AltProjectileClass.Default.speed;
		AltDamageType=AltProjectileClass.Default.MyDamageType;
	}
}

function SetWeaponStay ()
{
	bWeaponStay=bWeaponStay || Level.Game.bCoopWeaponMode;
}

event float BotDesireability (Pawn Bot)
{
	local Weapon AlreadyHas;
	local float desire;

	desire=MaxDesireability + Bot.AdjustDesireFor(self);
	AlreadyHas=Weapon(Bot.FindInventoryType(Class));
	if ( AlreadyHas != None )
	{
		if ( (RespawnTime < 10) && (bHidden || (AlreadyHas.AmmoType == None) || (AlreadyHas.AmmoType.AmmoAmount < AlreadyHas.AmmoType.MaxAmmo)) )
		{
			return 0.00;
		}
		if ( ( !bHeldItem || bTossedOut) && bWeaponStay )
		{
			return 0.00;
		}
		if ( AlreadyHas.AmmoType == None )
		{
			return 0.25 * desire;
		}
		if ( AlreadyHas.AmmoType.AmmoAmount > 0 )
		{
			return FMax(0.25 * desire,AlreadyHas.AmmoType.MaxDesireability * FMin(1.00,0.15 * AlreadyHas.AmmoType.MaxAmmo / AlreadyHas.AmmoType.AmmoAmount));
		}
		else
		{
			return 0.05;
		}
	}
	if ( (Bot.Weapon == None) || (Bot.Weapon.AIRating <= 0.40) )
	{
		return 2.00 * desire;
	}
	return desire;
}

function float RateSelf (out int bUseAltMode)
{
	if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
	{
		return -2.00;
	}
	bUseAltMode=FRand() < 0.40;
	return AIRating + FRand() * 0.05;
}

function float SuggestAttackStyle ()
{
	return 0.00;
}

function float SuggestDefenseStyle ()
{
	return 0.00;
}

simulated function PreRender (Canvas Canvas);

simulated function PostRender (Canvas Canvas);

function bool HandlePickupQuery (Inventory Item)
{
	local int OldAmmo;
	local Pawn P;

	if ( Item.Class == Class )
	{
		if ( Weapon(Item).bWeaponStay && ( !Weapon(Item).bHeldItem || Weapon(Item).bTossedOut) )
		{
			return True;
		}
		P=Pawn(Owner);
		if ( AmmoType != None )
		{
			OldAmmo=AmmoType.AmmoAmount;
			if ( AmmoType.AddAmmo(PickupAmmoCount) && (OldAmmo == 0) && (P.Weapon.Class != Item.Class) &&  !P.bNeverSwitchOnPickup )
			{
				WeaponSet(P);
			}
		}
		P.ClientMessage(PickupMessage,'Pickup');
		Item.PlaySound(Item.PickupSound);
		Item.SetRespawn();
		return True;
	}
	if ( Inventory == None )
	{
		return False;
	}
	return Inventory.HandlePickupQuery(Item);
}

function SetHand (float hand)
{
	if ( hand == 2 )
	{
		PlayerViewOffset.Y=0.00;
		FireOffset.Y=0.00;
		bHideWeapon=True;
		return;
	}
	else
	{
		bHideWeapon=False;
	}
	if ( hand == 0 )
	{
		PlayerViewOffset.X=Default.PlayerViewOffset.X * 0.88;
		PlayerViewOffset.Y=-0.20 * Default.PlayerViewOffset.Y;
		PlayerViewOffset.Z=Default.PlayerViewOffset.Z * 1.12;
	}
	else
	{
		PlayerViewOffset.X=Default.PlayerViewOffset.X;
		PlayerViewOffset.Y=Default.PlayerViewOffset.Y * hand;
		PlayerViewOffset.Z=Default.PlayerViewOffset.Z;
	}
	PlayerViewOffset *= 100;
	FireOffset.Y=Default.FireOffset.Y * hand;
}

function Weapon WeaponChange (byte F)
{
	local Weapon NewWeapon;

	if ( InventoryGroup == F )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
		{
			if ( Inventory == None )
			{
				NewWeapon=None;
			}
			else
			{
				NewWeapon=Inventory.WeaponChange(F);
			}
			if ( NewWeapon == None )
			{
				Pawn(Owner).ClientMessage(ItemName $ MessageNoAmmo);
			}
			return NewWeapon;
		}
		else
		{
			return self;
		}
	}
	else
	{
		if ( Inventory == None )
		{
			return None;
		}
		else
		{
			return Inventory.WeaponChange(F);
		}
	}
}

function Inventory SpawnCopy (Pawn Other)
{
	local Inventory Copy;
	local Weapon NewWeapon;

	if ( Level.Game.ShouldRespawn(self) )
	{
		Copy=Spawn(Class,Other);
		Copy.Tag=Tag;
		Copy.Event=Event;
		if (  !bWeaponStay )
		{
			GotoState('Sleeping');
		}
	}
	else
	{
		Copy=self;
	}
	Copy.RespawnTime=0.00;
	Copy.bHeldItem=True;
	Copy.GiveTo(Other);
	NewWeapon=Weapon(Copy);
	NewWeapon.Instigator=Other;
	NewWeapon.GiveAmmo(Other);
	NewWeapon.SetSwitchPriority(Other);
	if (  !Other.bNeverSwitchOnPickup )
	{
		NewWeapon.WeaponSet(Other);
	}
	NewWeapon.AmbientGlow=0;
	return NewWeapon;
}

function SetSwitchPriority (Pawn Other)
{
	local int i;
	local name Temp;
	local name Carried;

	if ( PlayerPawn(Other) != None )
	{
		i=0;
JL0017:
		if ( i < 20 )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == Class.Name )
			{
				AutoSwitchPriority=i;
				return;
			}
			i++;
			goto JL0017;
		}
		Carried=Class.Name;
		i=AutoSwitchPriority;
JL0087:
		if ( i < 20 )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == 'None' )
			{
				PlayerPawn(Other).WeaponPriority[i]=Carried;
				return;
			}
			else
			{
				if ( i < 19 )
				{
					Temp=PlayerPawn(Other).WeaponPriority[i];
					PlayerPawn(Other).WeaponPriority[i]=Carried;
					Carried=Temp;
				}
			}
			i++;
			goto JL0087;
		}
	}
}

function GiveAmmo (Pawn Other)
{
	if ( AmmoName == None )
	{
		return;
	}
	AmmoType=Ammo(Other.FindInventoryType(AmmoName));
	if ( AmmoType != None )
	{
		AmmoType.AddAmmo(PickupAmmoCount);
	}
	else
	{
		AmmoType=Spawn(AmmoName);
		Other.AddInventory(AmmoType);
		AmmoType.BecomeItem();
		AmmoType.AmmoAmount=PickupAmmoCount;
		AmmoType.GotoState('Idle2');
	}
}

function float SwitchPriority ()
{
	local float Temp;
	local int bTemp;

	if (  !Owner.IsA('PlayerPawn') )
	{
		return RateSelf(bTemp);
	}
	else
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
		{
			if ( Pawn(Owner).Weapon == self )
			{
				return -0.50;
			}
			else
			{
				return -1.00;
			}
		}
		else
		{
			return AutoSwitchPriority;
		}
	}
}

function bool WeaponSet (Pawn Other)
{
	local bool bSwitch;
	local bool bHaveAmmo;
	local Inventory Inv;

	if ( Other.Weapon == self )
	{
		return False;
	}
	if ( Other.Weapon == None )
	{
		Other.PendingWeapon=self;
		Other.ChangedWeapon();
		return True;
	}
	else
	{
		if ( (Other.Weapon.SwitchPriority() < SwitchPriority()) && Other.Weapon.PutDown() )
		{
			Other.PendingWeapon=self;
			GotoState('None');
			return True;
		}
		else
		{
			GotoState('None');
			return False;
		}
	}
}

function Weapon RecommendWeapon (out float rating, out int bUseAltMode)
{
	local Weapon Recommended;
	local float oldRating;
	local float oldFiring;
	local int oldMode;

	if ( Owner.IsA('PlayerPawn') )
	{
		rating=SwitchPriority();
	}
	else
	{
		rating=RateSelf(bUseAltMode);
		if ( (self == Pawn(Owner).Weapon) && (Pawn(Owner).Enemy != None) && ((AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
		{
			rating += 0.21;
		}
	}
	if ( Inventory != None )
	{
		Recommended=Inventory.RecommendWeapon(oldRating,oldMode);
		if ( (Recommended != None) && (oldRating > rating) )
		{
			rating=oldRating;
			bUseAltMode=oldMode;
			return Recommended;
		}
	}
	return self;
}

function DropFrom (Vector StartLocation)
{
	if (  !SetLocation(StartLocation) )
	{
		return;
	}
	AIRating=Default.AIRating;
	bMuzzleFlash=0;
	if ( AmmoType != None )
	{
		PickupAmmoCount=AmmoType.AmmoAmount;
		AmmoType.AmmoAmount=0;
	}
	Super.DropFrom(StartLocation);
}

function BecomePickup ()
{
	Super.BecomePickup();
	SetDisplayProperties(Default.Style,Default.Texture,Default.bUnlit,Default.bMeshEnviroMap);
}

function CheckVisibility ()
{
	local Pawn PawnOwner;

	PawnOwner=Pawn(Owner);
	if ( Owner.bHidden && (PawnOwner.Health > 0) && (PawnOwner.Visibility < PawnOwner.Default.Visibility) )
	{
		Owner.bHidden=False;
		PawnOwner.Visibility=PawnOwner.Default.Visibility;
	}
}

function Fire (float Value)
{
	if ( AmmoType.UseAmmo(1) )
	{
		GotoState('NormalFire');
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ShakeView(shaketime,shakemag,shakevert);
		}
		bPointing=True;
		PlayFiring();
		if (  !bRapidFire && (FiringSpeed > 0) )
		{
			Pawn(Owner).PlayRecoil(FiringSpeed);
		}
		if ( bInstantHit )
		{
			TraceFire(0.00);
		}
		else
		{
			ProjectileFire(ProjectileClass,ProjectileSpeed,bWarnTarget);
		}
		if ( Owner.bHidden )
		{
			CheckVisibility();
		}
	}
}

function AltFire (float Value)
{
	if ( AmmoType.UseAmmo(1) )
	{
		GotoState('AltFiring');
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ShakeView(shaketime,shakemag,shakevert);
		}
		bPointing=True;
		PlayAltFiring();
		if (  !bRapidFire && (FiringSpeed > 0) )
		{
			Pawn(Owner).PlayRecoil(FiringSpeed);
		}
		if ( bAltInstantHit )
		{
			TraceFire(0.00);
		}
		else
		{
			ProjectileFire(AltProjectileClass,AltProjectileSpeed,bAltWarnTarget);
		}
		if ( Owner.bHidden )
		{
			CheckVisibility();
		}
	}
}

function PlayFiring ()
{
}

function PlayAltFiring ()
{
}

function Projectile ProjectileFire (Class<Projectile> ProjClass, float projSpeed, bool bWarn)
{
	local Vector Start;
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Pawn PawnOwner;

	PawnOwner=Pawn(Owner);
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start=Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim=PawnOwner.AdjustAim(projSpeed,Start,aimerror,True,bWarn);
	return Spawn(ProjClass,,,Start,AdjustedAim);
}

function TraceFire (float Accuracy)
{
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector StartTrace;
	local Vector EndTrace;
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Actor Other;
	local Pawn PawnOwner;

	PawnOwner=Pawn(Owner);
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace=Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim=PawnOwner.AdjustAim(1000000.00,StartTrace,2.75 * aimerror,False,False);
	EndTrace=StartTrace + Accuracy * (FRand() - 0.50) * Y * 1000 + Accuracy * (FRand() - 0.50) * Z * 1000;
	X=vector(AdjustedAim);
	EndTrace += 10000 * X;
	Other=PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
	ProcessTraceHit(Other,HitLocation,HitNormal,X,Y,Z);
}

function ProcessTraceHit (Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
}

function Finish ()
{
	local Pawn PawnOwner;

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}
	PawnOwner=Pawn(Owner);
	if ( PlayerPawn(Owner) == None )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
		{
			PawnOwner.StopFiring();
			PawnOwner.SwitchToBestWeapon();
			if ( bChangeWeapon )
			{
				GotoState('DownWeapon');
			}
		}
		else
		{
			if ( (PawnOwner.bFire != 0) && (FRand() < RefireRate) )
			{
				Global.Fire(0.00);
			}
			else
			{
				if ( (PawnOwner.bAltFire != 0) && (FRand() < AltRefireRate) )
				{
					Global.AltFire(0.00);
				}
				else
				{
					PawnOwner.StopFiring();
					GotoState('Idle');
				}
			}
		}
		return;
	}
	if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) || (PawnOwner.Weapon != self) )
	{
		GotoState('Idle');
	}
	else
	{
		if ( PawnOwner.bFire != 0 )
		{
			Global.Fire(0.00);
		}
		else
		{
			if ( PawnOwner.bAltFire != 0 )
			{
				Global.AltFire(0.00);
			}
			else
			{
				GotoState('Idle');
			}
		}
	}
}

state NormalFire
{
	function Fire (float F)
	{
	}
	
	function AltFire (float F)
	{
	}
	
Begin:
	FinishAnim();
	Finish();
}

state AltFiring
{
	function Fire (float F)
	{
	}
	
	function AltFire (float F)
	{
	}
	
Begin:
	FinishAnim();
	Finish();
}

state Idle
{
	function AnimEnd ()
	{
		PlayIdleAnim();
	}
	
	function bool PutDown ()
	{
		GotoState('DownWeapon');
		return True;
	}
	
Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
	{
		Pawn(Owner).SwitchToBestWeapon();
	}
	if ( Pawn(Owner).bFire != 0 )
	{
		Fire(0.00);
	}
	if ( Pawn(Owner).bAltFire != 0 )
	{
		AltFire(0.00);
	}
	Disable('AnimEnd');
	PlayIdleAnim();
}

state Active
{
	function Fire (float F)
	{
	}
	
	function AltFire (float F)
	{
	}
	
	function bool PutDown ()
	{
		if ( bWeaponUp || (AnimFrame < 0.75) )
		{
			GotoState('DownWeapon');
		}
		else
		{
			bChangeWeapon=True;
		}
		return True;
	}
	
	function BeginState ()
	{
		bChangeWeapon=False;
	}
	
Begin:
	FinishAnim();
	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
	}
	bWeaponUp=True;
	PlayPostSelect();
	FinishAnim();
	Finish();
}

state DownWeapon
{
	ignores  AltFire, Fire;
	
	function bool PutDown ()
	{
		return True;
	}
	
	function BeginState ()
	{
		bChangeWeapon=False;
		bMuzzleFlash=0;
	}
	
Begin:
	TweenDown();
	FinishAnim();
	Pawn(Owner).ChangedWeapon();
}

function BringUp ()
{
	if ( Owner.IsA('PlayerPawn') )
	{
		PlayerPawn(Owner).EndZoom();
	}
	bWeaponUp=False;
	PlaySelect();
	GotoState('Active');
}

function RaiseUp (Weapon OldWeapon)
{
	BringUp();
}

function bool PutDown ()
{
	bChangeWeapon=True;
	return True;
}

function TweenDown ()
{
	if ( (AnimSequence != 'None') && (GetAnimGroup(AnimSequence) == 'Select') )
	{
		TweenAnim(AnimSequence,AnimFrame * 0.40);
	}
	else
	{
		PlayAnim('Down',1.00,0.05);
	}
}

function TweenSelect ()
{
	TweenAnim('Select',0.00);
}

function PlaySelect ()
{
	PlayAnim('Select',1.00,0.00);
	Owner.PlaySound(SelectSound,1,Pawn(Owner).SoundDampening);
}

function PlayPostSelect ()
{
}

function PlayIdleAnim ()
{
}

defaultproperties
{
    MaxTargetRange=4096.00
    bCanThrow=True
    ProjectileSpeed=1000.00
    AltProjectileSpeed=1000.00
    aimerror=550.00
    shakemag=300.00
    shaketime=0.10
    shakevert=5.00
    AIRating=0.10
    RefireRate=0.50
    AltRefireRate=0.50
    MessageNoAmmo=" has no ammo."
    DeathMessage="%o was killed by %k's %w."
    MuzzleScale=4.00
    FlashLength=0.10
    AutoSwitchPriority=1
    InventoryGroup=1
    PickupMessage="You got a weapon"
    ItemName="Weapon"
    RespawnTime=30.00
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-5.00)
    MaxDesireability=0.50
    Icon=Texture'S_Weapon'
    Texture=Texture'S_Weapon'
    bNoSmooth=True
}