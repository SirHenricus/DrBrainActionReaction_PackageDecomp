//================================================================================
// SPBall.
//================================================================================
class SPBall expands SPActor;

var() float Elasticity;
var() float RollingFriction;
var() float RollingFrictionCutOff;
var() float hitNormalZcutOff;
var() bool SoundOn;
var() Sound BallSound;
var() bool bSilentDestroy;

event HitWall (Vector HitNormal, Actor Wall)
{
	local Vector oldVel;
	local Vector oldWallVel;
	local Vector rollVelocity;
	local float oldVelSize;
	local float oldWallVelSize;
	local float oldNormalVelSize;
	local float oldNormalWallVelSize;
	local float SoundVolume;

	oldVel=Velocity;
	oldWallVel=Wall.Velocity;
	oldVelSize=VSize(oldVel);
	oldWallVelSize=VSize(oldWallVel);
	if ( SPBall(Wall) != None )
	{
		HitNormal=Normal(Location - Wall.Location);
	}
	oldNormalVelSize=oldVel Dot HitNormal;
	if ( (SPBall(Wall) == None) && (PlayerPawn(Wall) == None) && (SPPawn(Wall) == None) && (SPPushProjectile(Wall) == None) )
	{
		Velocity=oldNormalVelSize * HitNormal * -2.00 + oldVel;
		if ( VSize(Velocity) > RollingFrictionCutOff )
		{
			Velocity *= Elasticity;
		}
		else
		{
			Velocity *= RollingFriction;
		}
		if ( Location == OldLocation )
		{
			Velocity += 10 * HitNormal;
		}
		if ( (SPStunTurret(Wall) != None) && (Charge != 0) )
		{
			Wall.TakeDamage(0,None,vect(0.00,0.00,0.00),vect(0.00,0.00,0.00),'stun');
		}
	}
	else
	{
		oldNormalWallVelSize=oldWallVel Dot  -HitNormal;
		Velocity=oldVel - oldNormalVelSize * HitNormal - (2 * Wall.Mass * oldNormalWallVelSize + (Wall.Mass - Mass) * oldNormalVelSize) / (Mass + Wall.Mass) * HitNormal;
		if ( VSize(Velocity) > RollingFrictionCutOff )
		{
			Velocity *= Elasticity;
		}
		else
		{
			Velocity *= RollingFriction;
		}
		Wall.Velocity=oldWallVel - oldNormalWallVelSize *  -HitNormal - (2 * Mass * oldNormalVelSize + (Wall.Mass - Mass) * oldNormalWallVelSize) / (Mass + Wall.Mass) *  -HitNormal;
		if ( VSize(Velocity) > RollingFrictionCutOff )
		{
			Wall.Velocity *= Elasticity;
		}
		else
		{
			Wall.Velocity *= RollingFriction;
		}
		if ( (PlayerPawn(Wall) != None) || (SPPawn(Wall) != None) )
		{
			if ( Wall.Velocity.Z <= 0 )
			{
				Wall.Velocity.Z=100.00;
			}
			if ( Wall.Location == Wall.OldLocation )
			{
				Velocity += 10 * HitNormal;
			}
			if ( Wall.Physics == 1 )
			{
				Wall.SetPhysics(2);
			}
		}
	}
	if ( Charge == 0 )
	{
		if ( (Physics == 2) && (VSize(Velocity) < 50) && (HitNormal.Z >= hitNormalZcutOff) )
		{
			bBounce=False;
		}
		else
		{
			if ( (Physics != 2) && (VSize(Velocity) >= 50) )
			{
				SetPhysics(2);
				bBounce=True;
			}
		}
	}
	if ( (SPBall(Wall) != None) && (Charge == 0) )
	{
		if ( (Wall.Physics == 2) && (VSize(Wall.Velocity) < 50) && (HitNormal.Z >= hitNormalZcutOff) )
		{
			Wall.bBounce=False;
		}
		else
		{
			if ( (Wall.Physics != 2) && (VSize(Wall.Velocity) >= 50) )
			{
				Wall.SetPhysics(2);
				Wall.bBounce=True;
			}
		}
	}
	rollVelocity=Velocity - Velocity Dot HitNormal * HitNormal;
	AxisRotationRate=65536.00 * VSize(rollVelocity) / 2 * 3.14 * CollisionRadius;
	RotationAxis=Normal(Velocity Cross HitNormal);
	RotationAxis.X= -RotationAxis.X;
	if ( SoundOn )
	{
		oldNormalVelSize=Abs(oldNormalVelSize);
		if ( oldNormalVelSize > 100 )
		{
			SoundVolume=1.00;
		}
		else
		{
			SoundVolume=oldNormalVelSize / 100;
		}
		PlaySound(BallSound,3,SoundVolume);
	}
}

event Landed (Vector HitNormal)
{
	Acceleration=vect(0.00,0.00,0.00);
	Velocity=vect(0.00,0.00,0.00);
	AxisRotationRate=0.00;
}

event Bump (Actor Other)
{
	local Vector HitNormal;

	if ( (PlayerPawn(Other) != None) || (SPPawn(Other) != None) )
	{
		HitNormal=Location - Other.Location;
		if ( HitNormal.Z < 0 )
		{
			HitNormal.Z=0.00;
		}
		HitNormal=Normal(HitNormal);
		HitWall(HitNormal,Other);
	}
}

event Timer ()
{
	if ( bSilentDestroy )
	{
		Destroy();
	}
	else
	{
		Explode();
	}
}

function Explode ()
{
	GotoState('Exploding');
}

function SpawnBits ()
{
	local SPBallBit bit;
	local int i;
	local float MaxSpeed;

	MaxSpeed=500.00;
	i=0;
JL0012:
	if ( i < 15 )
	{
		bit=Spawn(Class'SPBallbit1');
		bit.Skin=Skin;
		bit.Velocity=MaxSpeed * VRand();
		bit.SetDrawScale(0.40);
		bit.SetRotation(rotator(bit.Velocity));
		bit.SetPhysics(6);
		bit.SetLifeSpan(0.40);
		i++;
		goto JL0012;
	}
}

function SetLifeSpan (float Seconds)
{
	SetTimer(Seconds,False);
}

state Exploding
{
	ignores  Explode;
	
	event Tick (float DeltaTime)
	{
		DrawScale=LifeSpan;
	}
	
Begin:
	SetPhysics(0);
	PlaySound(Sound'ball_e',3);
	SpawnBits();
	LifeSpan=0.40;
}

defaultproperties
{
    Elasticity=0.95
    RollingFriction=0.95
    RollingFrictionCutOff=100.00
    hitNormalZcutOff=0.99
    SoundOn=True
    BallSound=Sound'Balls.ball_m'
    ApplyDrag=True
    RotationAxis=(X=0.00,Y=0.00,Z=1.00)
    Physics=PHYS_Falling
    DrawType=DT_Sprite
    Mesh=LodMesh'Moon1t'
    DrawScale=0.50
    CollisionRadius=32.00
    CollisionHeight=32.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    bProjTarget=True
    bBounce=True
    bFixedRotationDir=True
    NetPriority=7.00
}