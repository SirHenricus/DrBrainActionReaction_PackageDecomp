//================================================================================
// SPPushWeapon.
//================================================================================
class SPPushWeapon expands Weapon;

enum EAnimState {
	AS_None,
	AS_ChargeUp,
	AS_ChargeDown
};

var() int ProjectileSpeed;
var() float AnimDelay;
var() int NumSkins;
var() Texture SkinList[10];
var float LastAnimTime;
var int CurSkin;
var EAnimState AnimState;

simulated function PreBeginPlay ()
{
	Super.PreBeginPlay();
	ProjectileClass=Class'SPPushProjectile';
}

event Tick (float dTime)
{
	if ( (AnimState != 0) && (Level.TimeSeconds - LastAnimTime >= AnimDelay) )
	{
		ChangeSkin();
		LastAnimTime=Level.TimeSeconds;
	}
}

function ChangeSkin ()
{
	if ( AnimState == 2 )
	{
		CurSkin++;
		if ( CurSkin == NumSkins - 1 )
		{
			AnimState=1;
		}
	}
	else
	{
		if ( AnimState == 1 )
		{
			CurSkin--;
			if ( CurSkin == 0 )
			{
				AnimState=0;
			}
		}
	}
	Skin=SkinList[CurSkin];
}

function Fire (float Value)
{
	GotoState('NormalFire');
	ProjectileFire(ProjectileClass,ProjectileSpeed,bWarnTarget);
	PlayFiring();
}

function Projectile ProjectileFire (Class<Projectile> ProjClass, float projSpeed, bool bWarn)
{
	local Vector Start;
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Projectile proj;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	Start=Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim=Pawn(Owner).AdjustAim(projSpeed,Start,aimerror,True,bWarn);
	proj=Spawn(ProjClass,Owner,,Start,AdjustedAim);
	if ( SPPushProjectile(proj) != None )
	{
		SPPushProjectile(proj).SetSpeed(ProjectileSpeed);
		SPPushProjectile(proj).Mass=100000.00 / ProjectileSpeed;
		SPPushProjectile(proj).Go();
		Owner.PlaySound(Sound'helpingh',0);
		AnimState=2;
		CurSkin=0;
		Skin=SkinList[CurSkin];
	}
	return proj;
}

function PlayFiring ()
{
	PlayAnim('Fire',1.00,0.05);
}

function PlayAltFiring ()
{
}

function AltFire (float Value)
{
	if ( (AmmoType != None) && AmmoType.UseAmmo(1) )
	{
		CheckVisibility();
		bPointing=True;
		PlayAltFiring();
		GotoState('AltFiring');
	}
}

function PlaySelect ()
{
}

state NormalFire expands NormalFire
{
	function Fire (float F)
	{
	}
	
	function AltFire (float F)
	{
	}
	
Begin:
	FinishAnim();
	Sleep(0.50);
	Finish();
}

state AltFiring expands AltFiring
{
	function Projectile ProjectileFire (Class<Projectile> ProjClass, float projSpeed, bool bWarn)
	{
		local Vector Start;
		local Vector X;
		local Vector Y;
		local Vector Z;
	
		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		if ( FireOffset.Y > 0 )
		{
			FireOffset.Y= -FireOffset.Y;
		}
		Start=Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
		AdjustedAim=Pawn(Owner).AdjustAim(projSpeed,Start,aimerror,True,bWarn);
		AdjustedAim.Roll += 12768;
	}
	
Begin:
	FinishAnim();
Repeater:
	ProjectileFire(AltProjectileClass,AltProjectileSpeed,bAltWarnTarget);
	if ( (Pawn(Owner).bAltFire != 0) && (Pawn(Owner).Weapon == self) && AmmoType.UseAmmo(1) )
	{
		goto ('Repeater');
	}
	if ( (Pawn(Owner).bFire != 0) && (Pawn(Owner).Weapon == self) )
	{
		Global.Fire(0.00);
	}
	else
	{
		GotoState('Idle');
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
	NewRot.Pitch -= 6000;
	SetRotation(NewRot);
	Canvas.DrawActor(self,False);
}

function PlayIdleAnim ()
{
	LoopAnim('Idle',0.40);
}

defaultproperties
{
    ProjectileSpeed=5000
    AnimDelay=0.20
    NumSkins=3
    SkinList(1)=Texture'SporeSkin.Lips.helphand.GAUGE1'
    SkinList(2)=Texture'SporeSkin.Lips.helphand.GAUGE2'
    AmmoName=Class'SPGloveAmmo'
    PickupMessage="You picked up the Helping Hand"
    PlayerViewOffset=(X=7.00,Y=-2.00,Z=-4.00)
    PlayerViewMesh=LodMesh'helphandhi'
    PlayerViewScale=0.09
    PickupViewMesh=LodMesh'helphandhi'
    ThirdPersonMesh=LodMesh'helphandhi'
    ThirdPersonScale=0.40
    Mesh=LodMesh'helphandhi'
    DrawScale=2.00
}