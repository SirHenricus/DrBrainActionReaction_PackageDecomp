//================================================================================
// Projectile.
//================================================================================
class Projectile expands Actor
	native
	abstract;

var() float speed;
var() float MaxSpeed;
var() float Damage;
var() int MomentumTransfer;
var() name MyDamageType;
var() Sound SpawnSound;
var() Sound ImpactSound;
var() Sound MiscSound;
var() float ExploWallOut;

function bool EncroachingOn (Actor Other)
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
	{
		return True;
	}
	return False;
}

singular simulated function Touch (Actor Other)
{
	local Actor HitActor;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector TestLocation;

	if ( Other.IsA('BlockAll') )
	{
		HitWall(Normal(Location - Other.Location),Other);
		return;
	}
	if ( Other.bProjTarget || Other.bBlockActors && Other.bBlockPlayers )
	{
		HitActor=Trace(HitLocation,HitNormal,Location,OldLocation,True);
		if ( HitActor == Other )
		{
			if ( (Pawn(Other) != None) &&  !Pawn(Other).AdjustHitLocation(HitLocation,Velocity) )
			{
				return;
			}
			ProcessTouch(Other,HitLocation);
		}
		else
		{
			ProcessTouch(Other,Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
		}
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
}

simulated function HitWall (Vector HitNormal, Actor Wall)
{
	if ( Role == 4 )
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
		{
			Wall.TakeDamage(Damage,Instigator,Location,MomentumTransfer * Normal(Velocity),'None');
		}
		MakeNoise(1.00);
	}
	Explode(Location + ExploWallOut * HitNormal,HitNormal);
}

simulated function Explode (Vector HitLocation, Vector HitNormal)
{
	Destroy();
}

final simulated function RandSpin (float spinRate)
{
	DesiredRotation=RotRand();
	RotationRate.Yaw=spinRate * 2 * FRand() - spinRate;
	RotationRate.Pitch=spinRate * 2 * FRand() - spinRate;
	RotationRate.Roll=spinRate * 2 * FRand() - spinRate;
}

defaultproperties
{
    MaxSpeed=2000.00
    bNetTemporary=True
    bReplicateInstigator=True
    Physics=PHYS_Walking
    LifeSpan=140.00
    bDirectional=True
    DrawType=DT_Sprite
    Texture=Texture'S_Camera'
    bGameRelevant=True
    SoundVolume=0
    CollisionRadius=0.00
    CollisionHeight=0.00
    bCollideActors=True
    bCollideWorld=True
    NetPriority=6.00
}