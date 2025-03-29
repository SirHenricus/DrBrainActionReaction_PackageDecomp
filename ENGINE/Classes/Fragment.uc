//================================================================================
// Fragment.
//================================================================================
class Fragment expands Projectile;

var() Mesh Fragments[11];
var int numFragmentTypes;
var bool bFirstHit;

function PostBeginPlay ()
{
	if ( Region.Zone.bDestructive )
	{
		Destroy();
	}
	else
	{
		Super.PostBeginPlay();
	}
}

simulated function CalcVelocity (Vector Momentum, float ExplosionSize)
{
	Velocity=VRand() * (ExplosionSize + FRand() * 150.00 + 100.00 + VSize(Momentum) / 80);
}

simulated function HitWall (Vector HitNormal, Actor HitWall)
{
	Velocity=0.50 * (Velocity Dot HitNormal * HitNormal * -2.00 + Velocity);
	speed=VSize(Velocity);
	if ( bFirstHit && (speed < 400) )
	{
		bFirstHit=False;
		bRotateToDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;
		DesiredRotation.Yaw=FRand() * 65536;
		DesiredRotation.Roll=0;
	}
	RotationRate.Yaw=RotationRate.Yaw * 0.75;
	RotationRate.Roll=RotationRate.Roll * 0.75;
	RotationRate.Pitch=RotationRate.Pitch * 0.75;
	if ( (speed < 60) && (HitNormal.Z > 0.70) )
	{
		SetPhysics(0);
		bBounce=False;
		GotoState('Dying');
	}
	else
	{
		if ( speed > 50 )
		{
			if ( FRand() < 0.50 )
			{
				PlaySound(ImpactSound,0,0.50 + FRand() * 0.50,,300.00,0.85 + FRand() * 0.30);
			}
			else
			{
				PlaySound(MiscSound,0,0.50 + FRand() * 0.50,,300.00,0.85 + FRand() * 0.30);
			}
		}
	}
}

auto state Flying
{
	simulated function Timer ()
	{
		GotoState('Dying');
	}
	
	simulated function Touch (Actor Other)
	{
		if ( Pawn(Other) == None )
		{
			return;
		}
		if (  !Pawn(Other).bIsPlayer )
		{
			Destroy();
		}
	}
	
	singular simulated function ZoneChange (ZoneInfo NewZone)
	{
		local float splashSize;
		local Actor splash;
	
		if ( NewZone.bWaterZone )
		{
			Velocity=0.20 * Velocity;
			splashSize=0.00 * (250 - 0.50 * Velocity.Z);
			if ( Level.NetMode != 1 )
			{
				if ( NewZone.EntrySound != None )
				{
					PlaySound(NewZone.EntrySound,3,splashSize);
				}
				if ( NewZone.EntryActor != None )
				{
					splash=Spawn(NewZone.EntryActor);
					if ( splash != None )
					{
						splash.DrawScale=4.00 * splashSize;
					}
				}
			}
			if ( bFirstHit )
			{
				bFirstHit=False;
				bRotateToDesired=True;
				bFixedRotationDir=False;
				DesiredRotation.Pitch=0;
				DesiredRotation.Yaw=FRand() * 65536;
				DesiredRotation.Roll=0;
			}
			RotationRate=0.20 * RotationRate;
			GotoState('Dying');
		}
		if ( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
		{
			Destroy();
		}
	}
	
	simulated function BeginState ()
	{
		RandSpin(125000.00);
		if ( (RotationRate.Pitch > -10000) && (RotationRate.Pitch < 10000) )
		{
			RotationRate.Pitch=10000;
		}
		if ( (RotationRate.Roll > -10000) && (RotationRate.Roll < 10000) )
		{
			RotationRate.Roll=10000;
		}
		Mesh=Fragments[FRand() * numFragmentTypes];
		if ( Level.NetMode == 0 )
		{
			LifeSpan=20.00 + 40 * FRand();
		}
		SetTimer(5.00,True);
	}
	
}

state Dying
{
	simulated function HitWall (Vector HitNormal, Actor HitWall)
	{
		Velocity=0.50 * (Velocity Dot HitNormal * HitNormal * -2.00 + Velocity);
		speed=VSize(Velocity);
		if ( bFirstHit && (speed < 400) )
		{
			bFirstHit=False;
			bRotateToDesired=True;
			bFixedRotationDir=False;
			DesiredRotation.Pitch=0;
			DesiredRotation.Yaw=FRand() * 65536;
			DesiredRotation.Roll=0;
		}
		RotationRate.Yaw=RotationRate.Yaw * 0.75;
		RotationRate.Roll=RotationRate.Roll * 0.75;
		RotationRate.Pitch=RotationRate.Pitch * 0.75;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.70) )
		{
			SetPhysics(0);
			bBounce=False;
		}
		else
		{
			if ( speed > 80 )
			{
				if ( FRand() < 0.50 )
				{
					PlaySound(ImpactSound,0,0.50 + FRand() * 0.50,,300.00,0.85 + FRand() * 0.30);
				}
				else
				{
					PlaySound(MiscSound,0,0.50 + FRand() * 0.50,,300.00,0.85 + FRand() * 0.30);
				}
			}
		}
	}
	
	function TakeDamage (int Dam, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
	{
		Destroy();
	}
	
	simulated function Timer ()
	{
		if (  !PlayerCanSeeMe() )
		{
			Destroy();
		}
	}
	
	simulated function BeginState ()
	{
		SetTimer(1.50,True);
		SetCollision(True,False,False);
	}
	
}

defaultproperties
{
    bFirstHit=True
    bNetTemporary=False
    bNetOptional=True
    Physics=PHYS_Walking
    RemoteRole=ROLE_DumbProxy
    LifeSpan=20.00
    CollisionRadius=18.00
    CollisionHeight=4.00
    bCollideActors=False
    bBounce=True
    bFixedRotationDir=True
    NetPriority=2.00
}