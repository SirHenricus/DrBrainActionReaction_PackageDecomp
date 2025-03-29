//================================================================================
// SPPushProjectile.
//================================================================================
class SPPushProjectile expands Projectile;

var() int MaxWallHits;
var int NumWallHits;
var bool bCanHitInstigator;
var bool bHitWater;
var int CurPitch;
var int PitchStart;
var int YawStart;
var int CurYaw;
var Rotator CurRotation;
var Vector StartVelocity;
var() Class<SPExhaust> Exhaust;
var() float ExhaustUpdateTime;

simulated event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Level.bEnhancedContent && (Level.NetMode != 1) )
	{
		SetTimer(ExhaustUpdateTime,True);
	}
}

simulated function Timer ()
{
	local Vector Loc;
	local int i;

	i=0;
JL0007:
	if ( i < 10 )
	{
		Loc=Location - vector(Rotation) * 40;
		Loc += VRand() * 7;
		Spawn(Exhaust,,,Loc);
		i++;
		goto JL0007;
	}
}

function SetSpeed (int S)
{
	local Vector X;

	speed=S;
	X=vector(Rotation);
	StartVelocity=speed * X;
}

function Go ()
{
	Velocity=StartVelocity;
}

auto state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local Vector Momentum;
	
		if ( bCanHitInstigator || (Other != Instigator) )
		{
			if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight) && (Instigator.IsA('PlayerPawn') || (Instigator.Skill > 1)) )
			{
				Other.TakeDamage(0,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),'pushedInHead');
			}
			else
			{
				if ( Other.IsA('SPBall') )
				{
					Other.HitWall(Normal(Other.Location - Location),self);
				}
				else
				{
					Other.TakeDamage(0,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),'pushed');
				}
			}
			PlaySound(MiscSound,1,2.00);
			Destroy();
		}
	}
	
	simulated function HitWall (Vector HitNormal, Actor Wall)
	{
		bCanHitInstigator=True;
		if ( (RemoteRole == 1) || (Level.NetMode != 1) )
		{
			PlaySound(ImpactSound,1,2.00);
		}
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
		{
			Wall.TakeDamage(Damage,Instigator,Location,MomentumTransfer * Normal(Velocity),'None');
			Destroy();
			return;
		}
		NumWallHits++;
		SetTimer(0.00,False);
		MakeNoise(0.30);
		if ( NumWallHits > MaxWallHits )
		{
			Destroy();
		}
		Velocity -= 2 * Velocity Dot HitNormal * HitNormal;
	}
	
	simulated function Bump (Actor Other)
	{
		Touch(Other);
	}
	
	simulated function Destroyed ()
	{
		local int i;
		local SPGloveBit bit;
		local SPBall ball;
		local int MaxSpeed;
		local SPPlayer P;
	
		MaxSpeed=500;
		foreach AllActors(Class'SPPlayer',P)
		{
			goto JL001F;
		}
		i=0;
	JL0027:
		if ( i < 15 )
		{
			if ( i >= 5 )
			{
				bit=Spawn(Class'SPGloveBit1');
				bit.Texture=Texture'Star11';
			}
			else
			{
				if ( i >= 2 )
				{
					bit=Spawn(Class'SPGloveBit2');
					bit.Texture=Texture'Star15';
				}
				else
				{
					bit=Spawn(Class'SPGloveBit3');
					bit.Texture=Texture'Star14';
				}
			}
			bit.DrawType=1;
			bit.Velocity.X=Rand(MaxSpeed) - MaxSpeed / 2;
			bit.Velocity.Y=Rand(MaxSpeed) - MaxSpeed / 2;
			bit.Velocity.Z=Rand(MaxSpeed) - MaxSpeed / 2;
			bit.DrawScale=0.50 * FRand();
			bit.RotationRate.Yaw=30000 + Rand(30000);
			if ( Rand(2) == 0 )
			{
				bit.RotationRate.Yaw *= -1;
			}
			bit.bFixedRotationDir=True;
			bit.LifeSpan=1.50;
			i++;
			goto JL0027;
		}
		PlaySound(Sound'helpwosh',0);
	}
	
	simulated function BeginState ()
	{
		local Vector X;
	
		X=vector(Rotation);
		StartVelocity=speed * X;
		if ( Level.NetMode == 0 )
		{
			SoundPitch=200 + 50 * FRand();
		}
		if ( (Instigator != None) && Instigator.HeadRegion.Zone.bWaterZone )
		{
			bHitWater=True;
		}
	}
	
Begin:
	Sleep(0.20);
	bCanHitInstigator=True;
}

defaultproperties
{
    Exhaust=Class'SPExhaust'
    ExhaustUpdateTime=0.03
    speed=1000.00
    MaxSpeed=10000.00
    MomentumTransfer=15000
    RemoteRole=ROLE_DumbProxy
    Mesh=LodMesh'SPPUSH'
    DrawScale=0.50
    SoundRadius=9
    SoundVolume=255
    AmbientSound=Sound'Projectile.woshglov'
    CollisionRadius=22.00
    CollisionHeight=22.00
    bBlockActors=True
    LightType=LT_Steady
    LightBrightness=129
    LightSaturation=64
    LightRadius=7
    bBounce=True
}