//================================================================================
// Inventory.
//================================================================================
class Inventory expands Actor
	native
	abstract;

var() travel byte AutoSwitchPriority;
var() byte InventoryGroup;
var() bool bActivatable;
var() bool bDisplayableInv;
var travel bool bActive;
var bool bSleepTouch;
var bool bHeldItem;
var(Display) bool bAmbientGlow;
var() bool bInstantRespawn;
var() bool bRotatingPickup;
var() localized string PickupMessage;
var() localized string ItemName;
var() localized string ItemArticle;
var() float RespawnTime;
var name PlayerLastTouched;
var() Vector PlayerViewOffset;
var() Mesh PlayerViewMesh;
var() float PlayerViewScale;
var() float BobDamping;
var() Mesh PickupViewMesh;
var() float PickupViewScale;
var() Mesh ThirdPersonMesh;
var() float ThirdPersonScale;
var() Texture StatusIcon;
var() name ProtectionType1;
var() name ProtectionType2;
var() travel int Charge;
var() int ArmorAbsorption;
var() bool bIsAnArmor;
var() int AbsorptionPriority;
var() Inventory NextArmor;
var() float MaxDesireability;
var InventorySpot myMarker;
var bool bSteadyFlash3rd;
var(MuzzleFlash) bool bMuzzleFlashParticles;
var byte FlashCount;
var byte OldFlashCount;
var(MuzzleFlash) ERenderStyle MuzzleFlashStyle;
var(MuzzleFlash) Mesh MuzzleFlashMesh;
var(MuzzleFlash) float MuzzleFlashScale;
var(MuzzleFlash) Texture MuzzleFlashTexture;
var() Sound PickupSound;
var() Sound ActivateSound;
var() Sound DeActivateSound;
var() Sound RespawnSound;
var() Texture Icon;
var() localized string M_Activated;
var() localized string M_Selected;
var() localized string M_Deactivated;

replication
{
	un?reliable if ( (Role == 4) && bNetOwner )
		bActivatable,bActive,PlayerViewOffset,PlayerViewMesh,PlayerViewScale,Charge,bIsAnArmor;
	un?reliable if ( Role == 4 )
		ThirdPersonMesh,ThirdPersonScale,bSteadyFlash3rd,FlashCount;
}

function PostBeginPlay ()
{
	if ( ItemName == "" )
	{
		ItemName=GetItemName(string(Class));
	}
	Super.PostBeginPlay();
}

simulated event RenderOverlays (Canvas Canvas)
{
	if ( Owner == None )
	{
		return;
	}
	if ( (Level.NetMode == 3) && ( !Owner.IsA('PlayerPawn') || (PlayerPawn(Owner).Player == None)) )
	{
		return;
	}
	SetLocation(Owner.Location + CalcDrawOffset());
	SetRotation(Pawn(Owner).ViewRotation);
	Canvas.DrawActor(self,False);
}

function string GetHumanName ()
{
	return ItemArticle @ ItemName;
}

simulated function DrawStatusIconAt (Canvas Canvas, int X, int Y, optional float Scale)
{
	if ( Scale == 0.00 )
	{
		Scale=1.00;
	}
	Canvas.SetPos(X,Y);
	Canvas.DrawIcon(StatusIcon,Scale);
}

event float BotDesireability (Pawn Bot)
{
	local Inventory AlreadyHas;
	local float desire;
	local bool bChecked;

	desire=MaxDesireability;
	if ( RespawnTime < 10 )
	{
		bChecked=True;
		AlreadyHas=Bot.FindInventoryType(Class);
		if ( (AlreadyHas != None) && (AlreadyHas.Charge >= Charge) )
		{
			return -1.00;
		}
	}
	if ( bIsAnArmor )
	{
		if (  !bChecked )
		{
			AlreadyHas=Bot.FindInventoryType(Class);
		}
		if ( AlreadyHas != None )
		{
			desire *= 0.40;
		}
		desire *= Charge * 0.00;
		desire *= ArmorAbsorption * 0.01;
		return desire;
	}
	else
	{
		return desire;
	}
}

function Weapon RecommendWeapon (out float rating, out int bUseAltMode)
{
	if ( Inventory != None )
	{
		return Inventory.RecommendWeapon(rating,bUseAltMode);
	}
	else
	{
		rating=-1.00;
		return None;
	}
}

event TravelPreAccept ()
{
	Super.TravelPreAccept();
	GiveTo(Pawn(Owner));
	if ( bActive )
	{
		Activate();
	}
}

function Destroyed ()
{
	if ( myMarker != None )
	{
		myMarker.markedItem=None;
	}
	if ( Pawn(Owner) != None )
	{
		Pawn(Owner).DeleteInventory(self);
	}
}

final simulated function Vector CalcDrawOffset ()
{
	local Vector DrawOffset;
	local Vector WeaponBob;
	local Pawn PawnOwner;

	PawnOwner=Pawn(Owner);
	DrawOffset=0.01 * PlayerViewOffset >> PawnOwner.ViewRotation;
	if ( (Level.NetMode == 1) || (Level.NetMode == 2) && (Owner.RemoteRole == 3) )
	{
		DrawOffset += PawnOwner.BaseEyeHeight * vect(0.00,0.00,1.00);
	}
	else
	{
		DrawOffset += PawnOwner.EyeHeight * vect(0.00,0.00,1.00);
		WeaponBob=BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z=(0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}
	return DrawOffset;
}

function BecomePickup ()
{
	if ( Physics != 2 )
	{
		RemoteRole=2;
	}
	Mesh=PickupViewMesh;
	DrawScale=PickupViewScale;
	bOnlyOwnerSee=False;
	bHidden=False;
	bCarriedItem=False;
	NetPriority=2.00;
	SetCollision(True,False,False);
}

function BecomeItem ()
{
	RemoteRole=1;
	Mesh=PlayerViewMesh;
	DrawScale=PlayerViewScale;
	bOnlyOwnerSee=True;
	bHidden=True;
	bCarriedItem=True;
	NetPriority=2.00;
	SetCollision(False,False,False);
	SetPhysics(0);
	SetTimer(0.00,False);
	AmbientGlow=0;
}

function GiveTo (Pawn Other)
{
	Instigator=Other;
	BecomeItem();
	Other.AddInventory(self);
	GotoState('Idle2');
}

function Inventory SpawnCopy (Pawn Other)
{
	local Inventory Copy;

	if ( Level.Game.ShouldRespawn(self) )
	{
		Copy=Spawn(Class,Other);
		Copy.Tag=Tag;
		Copy.Event=Event;
		GotoState('Sleeping');
	}
	else
	{
		Copy=self;
	}
	Copy.RespawnTime=0.00;
	Copy.bHeldItem=True;
	Copy.GiveTo(Other);
	return Copy;
}

function SetRespawn ()
{
	if ( Level.Game.ShouldRespawn(self) )
	{
		GotoState('Sleeping');
	}
	else
	{
		Destroy();
	}
}

function Activate ()
{
	if ( bActivatable )
	{
		if ( Level.Game.LocalLog != None )
		{
			Level.Game.LocalLog.LogItemActivate(self,Pawn(Owner));
		}
		if ( Level.Game.WorldLog != None )
		{
			Level.Game.WorldLog.LogItemActivate(self,Pawn(Owner));
		}
		Pawn(Owner).ClientMessage(ItemName $ M_Activated);
		GotoState('Activated');
	}
}

function bool HandlePickupQuery (Inventory Item)
{
	if ( Item.Class == Class )
	{
		return True;
	}
	if ( Inventory == None )
	{
		return False;
	}
	return Inventory.HandlePickupQuery(Item);
}

function Inventory SelectNext ()
{
	if ( bActivatable )
	{
		Pawn(Owner).ClientMessage(ItemName $ M_Selected);
		return self;
	}
	if ( Inventory != None )
	{
		return Inventory.SelectNext();
	}
	else
	{
		return None;
	}
}

function DropFrom (Vector StartLocation)
{
	if (  !SetLocation(StartLocation) )
	{
		return;
	}
	RespawnTime=0.00;
	SetPhysics(2);
	RemoteRole=1;
	BecomePickup();
	NetPriority=6.00;
	bCollideWorld=True;
	if ( Pawn(Owner) != None )
	{
		Pawn(Owner).DeleteInventory(self);
	}
	GotoState('Pickup','dropped');
}

function float InventoryCapsFloat (name Property, Pawn Other, Actor test);

function string InventoryCapsString (name Property, Pawn Other, Actor test);

function Fire (float Value);

function AltFire (float Value);

function Use (Pawn User);

function Weapon WeaponChange (byte F)
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

function int ReduceDamage (int Damage, name DamageType, Vector HitLocation)
{
	local Inventory FirstArmor;
	local int ReducedAmount;
	local int ArmorDamage;

	if ( Damage < 0 )
	{
		return 0;
	}
	ReducedAmount=Damage;
	FirstArmor=PrioritizeArmor(Damage,DamageType,HitLocation);
JL0033:
	if ( (FirstArmor != None) && (ReducedAmount > 0) )
	{
		ReducedAmount=FirstArmor.ArmorAbsorbDamage(ReducedAmount,DamageType,HitLocation);
		FirstArmor=FirstArmor.NextArmor;
		goto JL0033;
	}
	return ReducedAmount;
}

function Inventory PrioritizeArmor (int Damage, name DamageType, Vector HitLocation)
{
	local Inventory FirstArmor;
	local Inventory InsertAfter;

	if ( Inventory != None )
	{
		FirstArmor=Inventory.PrioritizeArmor(Damage,DamageType,HitLocation);
	}
	else
	{
		FirstArmor=None;
	}
	if ( bIsAnArmor )
	{
		if ( FirstArmor == None )
		{
			NextArmor=None;
			return self;
		}
		if ( FirstArmor.ArmorPriority(DamageType) < ArmorPriority(DamageType) )
		{
			NextArmor=FirstArmor;
			return self;
		}
		InsertAfter=FirstArmor;
JL0092:
		if ( (InsertAfter.NextArmor != None) && (InsertAfter.NextArmor.ArmorPriority(DamageType) > ArmorPriority(DamageType)) )
		{
			InsertAfter=InsertAfter.NextArmor;
			goto JL0092;
		}
		NextArmor=InsertAfter.NextArmor;
		InsertAfter.NextArmor=self;
	}
	return FirstArmor;
}

function int ArmorAbsorbDamage (int Damage, name DamageType, Vector HitLocation)
{
	local int ArmorDamage;

	if ( DamageType != 'drowned' )
	{
		ArmorImpactEffect(HitLocation);
	}
	if ( (DamageType != 'None') && ((ProtectionType1 == DamageType) || (ProtectionType2 == DamageType)) )
	{
		return 0;
	}
	if ( DamageType == 'drowned' )
	{
		return Damage;
	}
	ArmorDamage=Damage * ArmorAbsorption / 100;
	if ( ArmorDamage >= Charge )
	{
		ArmorDamage=Charge;
		Destroy();
	}
	else
	{
		Charge -= ArmorDamage;
	}
	return Damage - ArmorDamage;
}

function int ArmorPriority (name DamageType)
{
	if ( DamageType == 'drowned' )
	{
		return 0;
	}
	if ( (DamageType != 'None') && ((ProtectionType1 == DamageType) || (ProtectionType2 == DamageType)) )
	{
		return 1000000;
	}
	return AbsorptionPriority;
}

function ArmorImpactEffect (Vector HitLocation)
{
}

function OwnerJumped ()
{
	if ( Inventory != None )
	{
		Inventory.OwnerJumped();
	}
}

function ChangedWeapon ()
{
	if ( Inventory != None )
	{
		Inventory.ChangedWeapon();
	}
}

function SetOwnerDisplay ()
{
	if ( Inventory != None )
	{
		Inventory.SetOwnerDisplay();
	}
}

auto state Pickup
{
	singular function ZoneChange (ZoneInfo NewZone)
	{
		local float splashSize;
		local Actor splash;
	
		if ( NewZone.bWaterZone &&  !Region.Zone.bWaterZone )
		{
			splashSize=0.00 * Mass * (250 - 0.50 * Velocity.Z);
			if ( NewZone.EntrySound != None )
			{
				PlaySound(NewZone.EntrySound,3,splashSize);
			}
			if ( NewZone.EntryActor != None )
			{
				splash=Spawn(NewZone.EntryActor);
				if ( splash != None )
				{
					splash.DrawScale=2.00 * splashSize;
				}
			}
		}
	}
	
	function bool ValidTouch (Actor Other)
	{
		local Actor A;
	
		if ( Other.bIsPawn && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other),self) )
		{
			if ( Event != 'None' )
			{
				foreach AllActors(Class'Actor',A,Event)
				{
					A.Trigger(Other,Other.Instigator);
				}
			}
			return True;
		}
		return False;
	}
	
	function Touch (Actor Other)
	{
		if ( ValidTouch(Other) )
		{
			if ( Level.Game.LocalLog != None )
			{
				Level.Game.LocalLog.LogPickup(self,Pawn(Other));
			}
			if ( Level.Game.WorldLog != None )
			{
				Level.Game.WorldLog.LogPickup(self,Pawn(Other));
			}
			SpawnCopy(Pawn(Other));
			Pawn(Other).ClientMessage(PickupMessage,'Pickup');
			PlaySound(PickupSound);
			if ( Level.Game.Difficulty > 1 )
			{
				Other.MakeNoise(0.10 * Level.Game.Difficulty);
			}
		}
	}
	
	function Landed (Vector HitNormal)
	{
		local Rotator NewRot;
	
		NewRot=Rotation;
		NewRot.Pitch=0;
		SetRotation(NewRot);
		SetTimer(2.00,False);
	}
	
	function CheckTouching ()
	{
		local int i;
	
		bSleepTouch=False;
		i=0;
	JL000F:
		if ( i < 4 )
		{
			if ( (Touching[i] != None) && Touching[i].IsA('Pawn') )
			{
				Touch(Touching[i]);
			}
			i++;
			goto JL000F;
		}
	}
	
	function Timer ()
	{
		if ( RemoteRole != 2 )
		{
			NetPriority=2.00;
			RemoteRole=2;
			if ( bHeldItem )
			{
				SetTimer(40.00,False);
			}
			return;
		}
		if ( bHeldItem )
		{
			Destroy();
		}
	}
	
	function BeginState ()
	{
		BecomePickup();
		bCollideWorld=True;
		if ( bHeldItem )
		{
			SetTimer(45.00,False);
		}
	}
	
	function EndState ()
	{
		bCollideWorld=False;
		bSleepTouch=False;
	}
	
Begin:
	BecomePickup();
	if ( bRotatingPickup && (Physics != 2) )
	{
		SetPhysics(5);
	}
dropped:
	if ( bAmbientGlow )
	{
		AmbientGlow=255;
	}
	if ( bSleepTouch )
	{
		CheckTouching();
	}
}

state Activated
{
	function BeginState ()
	{
		bActive=True;
		if ( Pawn(Owner).bIsPlayer && (ProtectionType1 != 'None') )
		{
			Pawn(Owner).ReducedDamageType=ProtectionType1;
		}
	}
	
	function EndState ()
	{
		bActive=False;
		if ( (Pawn(Owner) != None) && Pawn(Owner).bIsPlayer && (ProtectionType1 != 'None') )
		{
			Pawn(Owner).ReducedDamageType='None';
		}
	}
	
	function Activate ()
	{
		if ( Level.Game.LocalLog != None )
		{
			Level.Game.LocalLog.LogItemDeactivate(self,Pawn(Owner));
		}
		if ( Level.Game.WorldLog != None )
		{
			Level.Game.WorldLog.LogItemDeactivate(self,Pawn(Owner));
		}
		if ( Pawn(Owner) != None )
		{
			Pawn(Owner).ClientMessage(ItemName $ M_Deactivated);
		}
		GotoState('DeActivated');
	}
	
}

state Sleeping
{
	function BeginState ()
	{
		BecomePickup();
		bHidden=True;
	}
	
	function EndState ()
	{
		local int i;
	
		bSleepTouch=False;
		i=0;
	JL000F:
		if ( i < 4 )
		{
			if ( (Touching[i] != None) && Touching[i].IsA('Pawn') )
			{
				bSleepTouch=True;
			}
			i++;
			goto JL000F;
		}
	}
	
Begin:
	Sleep(RespawnTime);
	PlaySound(RespawnSound);
	Sleep(Level.Game.PlaySpawnEffect(self));
	GotoState('Pickup');
}

function ActivateTranslator (bool bHint)
{
	if ( Inventory != None )
	{
		Inventory.ActivateTranslator(bHint);
	}
}

state Idle2
{
}

defaultproperties
{
    bAmbientGlow=True
    bRotatingPickup=True
    PickupMessage="Snagged an item"
    ItemArticle="a"
    PlayerViewScale=1.00
    BobDamping=0.96
    PickupViewScale=1.00
    ThirdPersonScale=1.00
    MaxDesireability=0.00
    M_Activated=" activated"
    M_Selected=" selected"
    M_Deactivated=" deactivated"
    bIsItemGoal=True
    bTravel=True
    RemoteRole=ROLE_DumbProxy
    DrawType=DT_Sprite
    Texture=Texture'S_Inventory'
    AmbientGlow=255
    CollisionRadius=30.00
    CollisionHeight=30.00
    bCollideActors=True
    bFixedRotationDir=True
    RotationRate=(Pitch=0,Yaw=5000,Roll=0)
    DesiredRotation=(Pitch=0,Yaw=30000,Roll=0)
    NetPriority=2.00
}